<?xml version="1.0"?>
<sch:schema xmlns:xsl="http://www.w3.org/1991/XSL/Transform"
	xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:mml="http://www.w3.org/1998/Math/MathML"
	xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:ali="http://www.niso.org/schemas/ali/1.0"
	schemaVersion="Alpha 20180228" queryBinding="xslt2">

	<sch:title>JATS4R Schematron Schema</sch:title>

	<!-- <sch:let name="registry-values" value="document('registry.xml')"/> -->

	<sch:ns uri="http://www.w3.org/2001/XMLSchema-instance" prefix="xsi"/>
	<sch:ns uri="http://www.w3.org/1998/Math/MathML" prefix="mml"/>
	<sch:ns uri="http://www.niso.org/schemas/ali/1.0" prefix="ali"/>
	<sch:ns uri="http://www.w3.org/1999/xlink" prefix="xlink"/>

	<sch:let name="registry-values" value="document('/work/jats4r/trunk/schematron/registry.xml')"/>
	<sch:let name="candidate-ver" value="/article/@dtd-version"/>


	<!-- General -->
	<sch:pattern id="gen">
		<sch:rule id="gen-03" context="/article[@xsi:noNamespaceSchemaLocation]" flag="error">
			<sch:assert diagnostics="diag.gen-03"
				test="@xsi:noNamespaceSchemaLocation
                = $registry-values//xsd-uris/value"
				> Unrecognized URI " <sch:value-of select="@xsi:noNamespaceSchemaLocation"/> "
			</sch:assert>
		</sch:rule>


	</sch:pattern>

	<!-- Citations -->
	<sch:pattern id="cit">
		<sch:rule id="cit-02" context="*[@publication-type]" flag="warning">
			<sch:assert diagnostics="diag.cit-02"
				test="@publication-type = $registry-values//publication-type/value"> Unrecognized
				publication type " <sch:value-of select="@publication-type"/> " </sch:assert>
		</sch:rule>

		<sch:rule id="cit-08" context="year[not(@iso-8601-date)]" flag="error">
			<sch:assert diagnostics="diag.cit-08" test="matches(.,'^\d\d\d\d$')"> Year value "
					<sch:value-of select="."/> " must be available as a-4 digit value </sch:assert>
		</sch:rule>
	</sch:pattern>

	<!-- Clinical Trials -->

	<!-- COI -->

	<!-- Data -->

	<!-- Data availability -->

	<!-- Display Objects -->
	<sch:pattern id="disp">

		<sch:rule id="disp-01" flag="error"
			context="fig|fig-group|table-wrap|table-wrap-group|boxed-text|chem-struct-wrap|disp-formula-group">
			<sch:assert diagnostics="diag.disp-01" test="@id"> &lt; <sch:value-of
					select="local-name()"/> > elements must have an ID </sch:assert>
		</sch:rule>

	</sch:pattern>

	<!-- Math -->

	<sch:pattern id="math">

		<sch:rule id="math-01" context="mml:math|tex-math" flag="error">
			<sch:assert diagnostics="diag.math-01"
				test="*[parent::disp-formula or parent::inline-formula]"> Unwrapped &lt;<value-of
					select="name()"/>> element.</sch:assert>
		</sch:rule>

	</sch:pattern>

	<!-- Permissions -->
	<sch:pattern id="perm">

		<sch:rule id="perm-01" flag="error" context="article-meta">
			<sch:assert diagnostics="diag.perm-01" test="permissions">No permissions</sch:assert>
		</sch:rule>

		<sch:rule id="perm-02" flag="info"
			context="app|array|boxed-text|chem-struct-wrap|disp-formula|disp-quote|fig|
            front-stub|graphic|media|preformat|sec-meta|statement|supplementary-material|
            table-wrap|table-wrap-foot|verse-group">
			<sch:assert diagnostics="diag.perm-02" test=".//permissions">No permissions for
				sub-items </sch:assert>
		</sch:rule>

		<sch:rule id="perm-03" flag="error" context="copyright-year">
			<sch:assert diagnostics="diag.perm-03" test="matches(.,'^\d\d\d\d$')">Bad copyright
				year</sch:assert>
		</sch:rule>

		<sch:rule id="perm04" flag="info" context="copyright-holder[(normalize-space(.)='')]">
			<sch:report diagnostics="diag.perm-04" test="true()">&lt;copyright holder> cannot be
				blank</sch:report>
		</sch:rule>

		<sch:rule id="perm04a" flag="info" context="permissions[not(copyright-holder)]">
			<sch:report diagnostics="diag.perm-04" test="true()">No valid copyright
				holder</sch:report>
		</sch:rule>

		<!-- Need to find list of published versions to do these right -->
		<!--<sch:rule id="perm-05a" flag="warn"
			context="article-meta/permissions/license[$candidate-ver='1.1d3']">
			<sch:assert diagnostics="diag.perm-05a" test="ali:license_ref">No license
				referenced</sch:assert>
		</sch:rule>

		<sch:rule id="perm-05b" flag="warn"
			context="article-meta/permissions/license[$candidate-ver!='1.1d3']">
			<sch:assert diagnostics="diag.perm-05b" test="@xlink:href">No license
				referenced</sch:assert>
		</sch:rule>-->

		<!-- Perm 06 v. hard to test with the standard as written -->

		<sch:rule id="perm-07" flag="info"
			context="p[ancestor::license]|license-p[ancestor::license]">
			<sch:report diagnostics="diag.perm-07" test="true()">Human-readable license text
				present</sch:report>
		</sch:rule>

		<sch:rule id="perm-08" flag="info" context="ali:free_to_read">
			<sch:report diagnostics="diag.perm-08" test="true()">Content tagged as free-to-read
				present</sch:report>
		</sch:rule>




	</sch:pattern>



	<sch:diagnostics>

		<!-- General -->
		<sch:diagnostic xml:lang="en" id="diag.gen-03">Error if the value of the attribute doesn't
			exactly match the full, canonical URL of the W3C XSD version of an official NLM or NISO
			JATS schema. </sch:diagnostic>
		<sch:diagnostic xml:lang="en" id="diag.gen-04a">The xml-model processing instruction MUST
			have an @href pseudo-attribute. </sch:diagnostic>

		<!-- Citations -->
		<sch:diagnostic xml:lang="en" id="diag.cit-02">The value of @publication-type must be a
			registered JATS4R value. </sch:diagnostic>
		<sch:diagnostic xml:lang="en" id="diag.cit-08">This should contain the 4-digit year of
			publication. If the element contains anything other than a single 4-digit year (such as,
			for example, "2012A", "2005Q1"), then use the @iso-8601-date attribute to specify the
			4-digit year. </sch:diagnostic>

		<!-- Display Objects -->
		<sch:diagnostic xml:lang="en" id="diag.disp-01">To cross-reference an object (for instance
			link a mention in a piece of text to the object), the object must have an ID that is
			unique within the document. </sch:diagnostic>

		<!-- Math -->
		<sch:diagnostic id="diag.math-01" xml:lang="en">Math should be marked up within
			&lt;inline-formula> and &lt;disp-formula> using either &lt;tex-math> or
			&lt;mml:math>.</sch:diagnostic>

		<!-- Permissions -->
		<sch:diagnostic xml:lang="en" id="diag.perm-01">&lt;article-meta> must contain a
			&lt;permissions> child element.</sch:diagnostic>

		<sch:diagnostic xml:lang="en" id="diag.perm-02">If any object within the article (for
			example, a figure or a table) has different permissions from the article as a whole,
			&lt;permissions> must be included in that element to ensure the object does not inherit
			the permissions that apply to the document as a whole. </sch:diagnostic>

		<sch:diagnostic xml:lang="en" id="diag.perm-03">When a work is protected by copyright (i.e.,
			the work is not in the public domain), this element should be used and should contain a
			full four-digit year with no whitespace. </sch:diagnostic>

		<sch:diagnostic xml:lang="en" id="diag.perm-04">When a work is protected by copyright, this
			element should be used and should identify the person or institution that holds the
			copyright. </sch:diagnostic>

		<sch:diagnostic xml:lang="en" id="diag.perm-05a">For JATS version 1.1d3 and forward, the
			license URI should be contained within &lt;ali:license_ref>. </sch:diagnostic>

		<sch:diagnostic xml:lang="en" id="diag.perm-05b">For JATS version 1.1d2 and backward, use
			the URI as the value of @xlink:href on &lt;license>. </sch:diagnostic>

		<sch:diagnostic xml:lang="en" id="diag.perm-07">This element is not required, but is
			intended for human readable consumption so there are no guidelines for the content used
			within the tag. Not to be used for the machine-readable, canonical URI for the
			license.</sch:diagnostic>

		<sch:diagnostic xml:lang="en" id="diag.perm-08">Content that is not behind access barriers,
			irrespective of any license specifications, should also contain this tag. It is used to
			indicate the content can be accessed by any user without payment or authentication. If
			the content is only available for a certain period, then @start_date and @end_date
			attributes can be used to indicate this. </sch:diagnostic>

	</sch:diagnostics>




</sch:schema>
