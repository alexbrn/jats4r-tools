<?xml version="1.0"?>
<p:pipeline xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    version="2.0" xpath-version="2.0">

    <p:serialization port="result" encoding="utf-8" indent="true"/>
    <p:option name="format" select="'svrl'"/>

    <p:identity name="candidate"/>
    <p:sink/>

    <p:load name="schematron-schema" href="../schematron/jats4r.sch"/>
    <p:sink/>

    <p:validate-with-schematron name="sch-validate" assert-valid="false" xml:base="../schematron">
        <p:input port="schema">
            <p:pipe port="result" step="schematron-schema"/>
        </p:input>
        <p:input port="source">
            <p:pipe port="result" step="candidate"/>
        </p:input>
    </p:validate-with-schematron>
    <p:sink/>

    <p:identity name="svrl-report">
        <p:input port="source">
            <p:pipe port="report" step="sch-validate"/>
        </p:input>
    </p:identity>

    <p:choose>

        <!-- web report -->
        <p:when test="$format='html'">

            <!-- mash together the schema and the SVRL to provide basis for a nice report transform -->

            <p:wrap-sequence wrapper="wrapper">
                <p:input port="source">
                    <p:pipe port="result" step="schematron-schema"/>
                    <p:pipe port="result" step="svrl-report"/>
                </p:input>
            </p:wrap-sequence>

            <p:xslt>
                <p:input port="stylesheet">
                    <p:inline>
                        <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                            version="2.0">


                            <xsl:template match="/">

                                <html xmlns="http://www.w3.org/1999/xhtml">
                                    <head>
                                        <title>JATS4R validation report</title>
                                        <style type="text/css">
                                            <![CDATA[
html,
table
{
    font-family:'Open sans', sans-serif !important;
}

td{
    padding:2px;
}

th{
    background-color:#cfc
}

body{
    margin-left:5%;
    margin-right:5%;
}

h1,
h2,
h3{
    color:#3a3;
}

/* Tooltip container */
.tooltip{
    position:relative;
    display:inline-block;
    border-bottom:1px dotted black; /* If you want dots under the hoverable text */
}

/* Tooltip text */
.tooltip .tooltiptext{
    visibility:hidden;
    width:320px;
    background-color:#050;
    color:#fff;
    text-align:center;
    padding:15px;
    border-radius:6px;

    /* Position the tooltip text - see examples below! */
    position:absolute;
    z-index:1;
}

/* Show the tooltip text when you mouse over the tooltip container */
.tooltip:hover .tooltiptext{
    visibility:visible;
}
                                            
                                           ]]>
                                        </style>
                                    </head>
                                    <body>

                                        <h1>JATS4R Validation Report</h1>
                                        <p>Produced at <xsl:value-of select="current-dateTime()"/>
                                            by Schematron schema version <xsl:value-of
                                                select="//svrl:schematron-output/@schemaVersion"
                                            />.</p>
                                        <h2>Summary</h2>
                                        <p>There are <xsl:value-of
                                                select="count(//svrl:failed-assert|//svrl:successful-report)"
                                            /> message(s) for the candidate document.</p>
                                        <h2>Messages</h2>
                                        <table>
                                            <tbody>
                                                <thead>
                                                  <tr>
                                                      <th>&#160;Message ID&#160;</th>
                                                      <th>&#160;Message type&#160;</th>
                                                      <th>&#160;Location&#160;</th>
                                                      <th>&#160;Description&#160;</th>
                                                  </tr>
                                                </thead>
                                                <xsl:apply-templates
                                                  select="//svrl:failed-assert|//svrl-successful-report"
                                                />
                                            </tbody>
                                        </table>
                                    </body>
                                </html>
                            </xsl:template>

                            <xsl:template match="svrl:failed-assert|svrl-successful-report">
                                <xsl:variable name="rule-id"
                                    select="preceding-sibling::svrl:fired-rule[1]/@id"/>
                                <xsl:variable name="loc" select="@location"/>
                                <xsl:variable name="rule" select="//sch:rule[@id=$rule-id]"/>

                                <tr xmlns="http://www.w3.org/1999/xhtml" class="{$rule/@flag}">
                                    <td>
                                        <xsl:value-of select="$rule-id"/>
                                    </td>

                                    <td>
                                        <xsl:value-of select="$rule/@flag"/>
                                    </td>
                                    <td class="tooltip"> XPath<span class="tooltiptext">
                                            <xsl:value-of select="$loc"/></span>
                                    </td>
                                    <td>
                                        <xsl:value-of select="svrl:text"/> &#160; <span
                                            class="tooltip">?<span class="tooltiptext">
                                                <xsl:value-of select="svrl:diagnostic-reference"
                                                /></span></span>
                                    </td>
                                </tr>
                            </xsl:template>
                        </xsl:stylesheet>

                    </p:inline>
                </p:input>
            </p:xslt>
        </p:when>

        <p:otherwise>
            <!-- tidy up the SVRL -->
            <!-- delete some elements which don't contain information that's useful to us -->
            <!-- <p:delete
                match="svrl:fired-rule|svrl:ns-prefix-in-attribute-values|svrl:active-pattern|@test"/>-->

            <p:identity/>
        </p:otherwise>
    </p:choose>

    <!-- tidy whitespace -->
    <p:xslt>
        <p:input port="stylesheet">
            <p:inline>
                <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
                    <xsl:template match="*">
                        <xsl:element name="{local-name(.)}" namespace="{namespace-uri(.)}">
                            <xsl:copy-of select="@*"/>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:template>
                    <xsl:template match="text()">
                        <xsl:value-of select="normalize-space(.)"/>
                    </xsl:template>
                </xsl:stylesheet>
            </p:inline>
        </p:input>

    </p:xslt>

</p:pipeline>
