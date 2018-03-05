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
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.util.HashMap;
import java.util.UUID;

import org.apache.log4j.Logger;

public class Store
{
    static Logger logger = Logger.getLogger( Store.class );

    static String tmpFolder;
    static boolean webMode;

    static HashMap< UUID, String > localMap = new HashMap< UUID, String >();


    public static void init( String tmpFolder, boolean webMode )
    {
        Store.tmpFolder = tmpFolder;
        File tmp = new File( tmpFolder );
        if( !tmp.isDirectory() )
        {
            tmp.mkdirs();
            tmp.mkdir();

        }

        Store.webMode = webMode;
    }


    public static UUID putZippedResource( Submission sub, InputStream is, String filename )
            throws IOException
    {

        UUID uuid = UUID.randomUUID();
        String fn = filename;
        new File( getDirectory( uuid ) ).mkdir();

        // Save the file locally only for web mode
        if( webMode )
        {
            fn = getDirectory( uuid ) + File.separator + uuid + ".bin";
            long written = Utils.streamToFile( is, fn, false );
            logger.debug( "Wrote " + written + " bytes to file" );
        }

        localMap.put( uuid, fn );

        return uuid;
    }


    // MediaType detectResourceType( UUID uuid) throws IOException
    // {
    // String fn = getFilename( uuid );
    // File f = new File( fn );
    // InputStream is = new FileInputStream( f );
    //
    // TikaConfig config = TikaConfig.getDefaultConfig();
    // Detector detector = config.getDetector();
    //
    // TikaInputStream stream = TikaInputStream.get( is );
    //
    // Metadata metadata = new Metadata();
    // // metadata.add(Metadata.RESOURCE_NAME_KEY, filenameWithExtension);
    // MediaType mediaType = detector.detect( stream, metadata );
    //
    // is.close();
    // return mediaType;
    // }

    public static InputStream getStream( UUID uuid )
    {
        String fn = localMap.get( uuid );
        InputStream is = null;
        if( fn != null )
        {
            File f = new File( fn );

            try
            {
                is = new FileInputStream( f );
            }
            catch( FileNotFoundException e )
            {
                // we'll return null in this case
            }
        }

        return is;
    }


    public static URI urlForEntry( UUID uuid, String name )
    {
        String fn = getDirectory( uuid ) + File.separator + name;
        URI uri = new File( fn ).toURI();
        return uri;
    }


    public static void delete( UUID uuid )
    {
        File dir = new File( getDirectory( uuid ) );
        Utils.deleteDir( dir );
        localMap.remove( uuid );
    }


    public static String getDirectory( UUID uuid )
    {
        return tmpFolder + File.separator + uuid;
    }


    public static String getFilename( UUID uuid )
    {
        return localMap.get( uuid );
    }

}