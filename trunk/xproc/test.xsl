<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xf="http://xmlfirst.com"
    exclude-result-prefixes="xs" version="2.0">

    <xsl:function name="xf:validate-registry-value">
        <xsl:param name="key"/>
        <xsl:param name="value"/>
        <xsl:variable name="registry">
            <jats4t-registry>

                <!-- HTTP URIs for the XSD schemas -->
                <xsd-uri>
                    <value>http://jats.nlm.nih.gov/publishing/1.1/xsd/JATS-journalpublishing1.xsd</value>
                </xsd-uri>

                <!-- reference @publication-type values -->
                <publication-type>
                    <value>journal</value>
                    <value>book</value>
                    <value>letter</value>
                    <value>review</value>
                    <value>patent</value>
                    <value>report</value>
                    <value>standard</value>
                    <value>data</value>
                    <value>working-paper</value>
                </publication-type>

            </jats4t-registry>
        </xsl:variable>
        <xsl:variable name="match"
            select="$registry/jats4t-registry/*[local-name()=$key and value=$value]"/>
        <xsl:choose>
            <xsl:when test="$match">
                <xsl:text>true</xsl:text>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:function>

    <xsl:template match="/">
        <foo>
            <xsl:value-of select="xf:validate-registry-value('foo','bar')"/>
        </foo>
    </xsl:template>



</xsl:stylesheet>
