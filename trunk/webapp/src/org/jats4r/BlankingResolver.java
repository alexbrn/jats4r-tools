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

import java.io.ByteArrayInputStream;
import java.io.IOException;

import org.xml.sax.EntityResolver;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

public class BlankingResolver implements EntityResolver
{

    public InputSource resolveEntity( String arg0, String arg1 ) throws SAXException,
            IOException
    {

        return new InputSource( new ByteArrayInputStream( "".getBytes() ) );
    }

}
