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
import java.util.UUID;

import org.apache.log4j.Logger;

/**
 * Represents the inputs to a validation session. This includes a resource to be validated
 * (which may need to be de-referenced) and options to affect the validation process.
 */
abstract public class Submission
{
    static Logger logger = Logger.getLogger( Submission.class );
    UUID uuid;



    public String getCandidateFile()
    {
        if( uuid == null )
        {
            throw new IllegalStateException( "No resource has been localized" );
        }

        return Store.getFilename( uuid );
    }


    public File getEntryFile( String entryName )
    {
        if( uuid == null )
        {
            throw new IllegalStateException( "No resource has been localized" );
        }

        return new File( Store.urlForEntry( uuid, entryName ) );
    }


 

    
}
