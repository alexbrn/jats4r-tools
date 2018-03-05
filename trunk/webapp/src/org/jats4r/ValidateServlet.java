/*
 * This file is part of the source of:
 * 
 * JATS4R validator
 * 
 * Developed by Griffin Brown Digital Publishing Ltd.
 * 
 * Contact: alexb@griffinbrown.co.uk
 * 
 * This source is licensed under the Mozilla Public License Version 2.0
 * 
 * https://www.mozilla.org/en-US/MPL/2.0/
 */

package org.jats4r;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.UUID;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

@SuppressWarnings("serial")
public class ValidateServlet extends HttpServlet
{

    static Logger logger = Logger.getLogger( ValidateServlet.class );
    static String tempFolder;


    @Override
    protected void doPost( HttpServletRequest req, HttpServletResponse resp )
            throws ServletException, IOException
    {
        ServletContext sc = getServletContext();

        tempFolder = Utils.isWindows() ? sc.getInitParameter( "temp-folder-win" ) : sc
                .getInitParameter( "temp-folder-nix" );

        Store.init( tempFolder, true ); // to get the storage layer up
        // and
        // running

        WebSubmission sub = new WebSubmission( req );
        int retCode = sub.fetchFromClient(); // persists body of request to file system

        if( retCode != 200 )
        {
            logger.trace( "returning HTTP response code " + sub.getResponseErr() );
            resp.sendError( retCode, sub.getResponseErr() );
            return;
        }

        boolean hasErrors = false;

        synchronized( ValidateServlet.class )
        {
            logger.info( "Validating resource " + sub.uuid.toString() + "|" + sub.getFilename() );
            String format = "html"; //TODO sub.isMultiPart() ? "html" : "svrl";

            hasErrors = doValidate( resp, sub.uuid, format );
        }

        // delete working folder
        // Store.delete( sub.uuid );

    }


    private boolean doValidate( HttpServletResponse resp, UUID uuid, String format )
            throws IOException
    {
        ServletContext sc = getServletContext();
        String resultBaseFilename = tempFolder + File.separator + uuid.toString();
        String resultBaseUri = new File( resultBaseFilename ).toURI().toString();

        logger.info( "Using working folder of: " + resultBaseUri );

        resp.setHeader( "Cache-Control", "no-cache" );

        boolean hasErrors = false;

        String dir = tempFolder + File.separator + uuid.toString();
        String filename = dir + File.separator + uuid.toString() + ".bin";

        String cmd = Utils.isWindows() ? sc.getInitParameter( "win-invoke" ) : sc
                .getInitParameter( "nix-invoke" );
        cmd += " " + new File( filename ).toURI().toURL() + " " + filename;
        cmd += " format=" + format;

        // The command from web.xml is invoked and two params send: the file
        // to be processed first as a URL, then as a system-specific filename
        //
        // The script must write two files whose names are the system-specific filename
        // but the the suffixes ".out" and ".err". These are the process results

        logger.info( "cmd is: " + cmd );

        synchronized( ValidateServlet.class )
        {
            Runtime r = Runtime.getRuntime();
            try
            {
                Process p = r.exec( cmd );
                p.waitFor();

            }
            catch( Exception e )
            {
                logger.fatal( e.getMessage() ); // cannot recover
            }

        }

        // TODO: see if there's an error

        String outfile = filename + ".out";

        File f = new File( outfile );
        FileInputStream fis = new FileInputStream( f );
        resp.setContentType( "text/html" );
        resp.setContentLength( ( int )f.length() );

        Utils.transferBytesToEndOfStream( fis, resp.getOutputStream(), Utils.CLOSE_IN
                | Utils.CLOSE_OUT );

        return hasErrors;

    }

}
