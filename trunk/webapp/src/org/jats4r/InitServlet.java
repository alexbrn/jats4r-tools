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
 * 
 */

package org.jats4r;

import java.io.File;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;

import org.apache.log4j.BasicConfigurator;
import org.apache.log4j.PropertyConfigurator;

/**
 * @author Alex
 */
@SuppressWarnings("serial")
public class InitServlet extends HttpServlet
{

    public void init( ServletConfig config ) throws ServletException
    {
        System.out.println( "Log4JInitServlet is initializing log4j" );
        String log4jLocation = config.getInitParameter( "log4j-properties-location" );

        ServletContext sc = config.getServletContext();

        if( log4jLocation == null )
        {
            System.err
                    .println( "*** No log4j-properties-location init param, so initializing log4j with BasicConfigurator" );
            BasicConfigurator.configure();
        }
        else
        {
            String webAppPath = sc.getRealPath( "/" );
            String log4jProp = webAppPath + log4jLocation;
            File yoMamaYesThisSaysYoMama = new File( log4jProp );
            if( yoMamaYesThisSaysYoMama.exists() )
            {
                System.out.println( "Initializing log4j with: " + log4jProp );
                PropertyConfigurator.configure( log4jProp );
            }
            else
            {
                System.err.println( "*** " + log4jProp
                        + " file not found, so initializing log4j with BasicConfigurator" );
                BasicConfigurator.configure();
            }
        }


        super.init( config );
    }
}
