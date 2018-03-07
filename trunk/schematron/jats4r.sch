<?xml version="1.0"?>
<sch:schema xmlns:xsl="http://www.w3.org/1991/XSL/Transform"
	xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:mml="http://www.w3.org/1998/Math/MathML"
	schemaVersion="Alpha 20180228" queryBinding="xslt2">

	<sch:title>JATS4R Schematron Schema</sch:title>

	<!-- <sch:let name="registry-values" value="document('registry.xml')"/> -->

	<sch:ns uri="http://www.w3.org/2001/XMLSchema-instance" prefix="xsi"/>
	<sch:ns uri="http://www.w3.org/1998/Math/MathML" prefix="mml"/>

	<sch:let name="registry-values" value="document('/work/jats4r/trunk/schematron/registry.xml')"/>


	<!-- General -->
	<sch:pattern id="gen">
		<sch:rule id="gen-03" context="/article[@xsi:noNamespaceSchemaLocation]" flag="error">
			<sch:assert diagnostics="diag.gen-03"
				test="@xsi:noNamespaceSchemaLocation
                = $registry-values//xsd-uris/value"
				> Unrecognized URI " <sch:value-of select="@xsi:noNamespaceSchemaLocation"/> "
			</sch:assert>
		</sch:rule>

		<!-- XML model TODO: Schematron implementation not up to this? -->
		<!-- <sch:pattern> <sch:rule id="gen-04a" context="/processing-instruction('xml-model')"> 
			<sch:assert diagnostics="diag.gen-04a" test="contains(.,'href=')">No href 
			pseudo-attribute</sch:assert> </sch:rule> -->

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
			<sch:assert diagnostics="diag.perm-01" test="permissions">No permissions </sch:assert>
		</sch:rule>

		<sch:rule id="perm-02" flag="info"
			context="app|array|boxed-text|chem-struct-wrap|disp-formula|disp-quote|fig|
            front-stub|graphic|media|preformat|sec-meta|statement|supplementary-material|
            table-wrap|table-wrap-foot|verse-group">
			<sch:assert diagnostics="diag.perm-02" test=".//permissions">No permissions for
				sub-items </sch:assert>
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

	</sch:diagnostics>




</sch:schema>
