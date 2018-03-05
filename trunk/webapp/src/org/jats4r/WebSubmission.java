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

import java.io.IOException;
import java.io.InputStream;
import java.util.Enumeration;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.fileupload.FileItemIterator;
import org.apache.commons.fileupload.FileItemStream;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.log4j.Logger;

public class WebSubmission extends Submission
{

    static Logger logger = Logger.getLogger( WebSubmission.class );

    private HttpServletRequest request;
    private String responseErr;
    private String filename;
    private boolean isMultipart;


    public WebSubmission( HttpServletRequest req )
    {
        this.request = req;
    }


    public int fetchFromClient() throws IOException
    {
        int ret = 200;

        isMultipart = ServletFileUpload.isMultipartContent( this.request );

        if( isMultipart )
        {
            parseMultiPart( this.request );
        }
        else
        {
            parseDirect( this.request );
        }

        return ret;
    }


    /**
     * Retrieves items contained in a multipart servlet request.
     * 
     * @param req
     * @return a map, mapping between item names and the UUIDs for their stored values
     * @throws IOException
     */
    public void parseMultiPart( HttpServletRequest req ) throws IOException
    {

        logger.debug( "Processing multipart submission" );
        ServletFileUpload upload = new ServletFileUpload();

        try
        {
            FileItemIterator iter = upload.getItemIterator( req );

            while( iter.hasNext() )
            {
                FileItemStream item = iter.next();
                String name = item.getFieldName();

                InputStream sis = item.openStream();

                if( name.equalsIgnoreCase( "candidate" ) )
                {
                    this.filename = item.getName();
                    logger.debug( "Got file item named: " + filename );
                    this.uuid = Store.putZippedResource( this, sis, name );
                    sis.close();
                    sis = null;
                    System.gc();
                    logger.debug( "Persisted candidate item with UUID: " + this.uuid );
                }
                else
                {
                    byte[] ba = Utils.getBytesToEndOfStream( sis, true ); // closes stream
                    String val = new String( ba );
                    logger.debug( "Setting option " + name + " = " + val );
                    // this.optionMap.put( name, val );
                }
            }
        }
        catch( FileUploadException e )
        {
            logger.fatal( e.getMessage() );
            throw new RuntimeException( e.getMessage() );
        }

    }


    @SuppressWarnings("unchecked")
    public void parseDirect( HttpServletRequest request ) throws IOException
    {
        logger.debug( "Processing direct submission" );
        InputStream sis = request.getInputStream();
        this.uuid = Store.putZippedResource( this, sis, null ); // closes stream

        Enumeration< String > en = request.getParameterNames();
        while( en.hasMoreElements() )
        {
            String name = en.nextElement();
            String val = request.getParameter( name );
            // this.optionMap.put( name, val );
        }
    }


    public String getResponseErr()
    {
        return responseErr;
    }


    public HttpServletRequest getRequest()
    {
        return request;
    }


    public String getFilename()
    {
        return filename;
    }


    public boolean isMultiPart()
    {
        return isMultipart;
    }

}
