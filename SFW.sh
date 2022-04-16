#/bin/sh
# VERSION 1.0
# Author: incompetent-tester <incompetent.tester@gmail.com>

# --------------------------------- Constant --------------------------------- #
TMP_DIR="sfwtmp"

# ------------------------------- Misc Methods ------------------------------- #
help(){
	echo "SFW Sensible Firewall Log parser"
	echo
	echo "Usage: SFW.sh [-o] [-h] [-g] [-c] <log_file>"
	echo
	echo "options:"
	echo "	-g                  Determine IP geolocation"
	echo "  -ge <excluded_ips>  Specific excluded ips for geolocation e.g. \"172.16.32.1,172.16.32.2\""
	echo "	-h                  Show help"
	echo "	-c                  Output .csv instead of .ods"
	echo "	-o  <output_name>   Specific output file name"
	echo
	echo "Examples: "
	echo "	./SFW.sh -o mylog -g ./example/ufw.log"
	echo "	./SFW.sh -o mylog -g -c ./example/ufw.log"
	echo 
}

# -------------------------------- ODS Methods ------------------------------- #
ods_create_placeholder(){
	mkdir "./${TMP_DIR}"   # placeholder

	# ODS required folder / files
	mkdir "./${TMP_DIR}/META-INF"

	cat <<-EOF > "./${TMP_DIR}/META-INF/manifest.xml"
		<manifest:manifest xmlns:manifest="urn:oasis:names:tc:opendocument:xmlns:manifest:1.0" xmlns:loext="urn:org:documentfoundation:names:experimental:office:xmlns:loext:1.0" manifest:version="1.3"><manifest:file-entry manifest:full-path="/" manifest:version="1.3" manifest:media-type="application/vnd.oasis.opendocument.spreadsheet"/><manifest:file-entry manifest:full-path="Configurations2/" manifest:media-type="application/vnd.sun.xml.ui.configuration"/><manifest:file-entry manifest:full-path="manifest.rdf" manifest:media-type="application/rdf+xml"/><manifest:file-entry manifest:full-path="meta.xml" manifest:media-type="text/xml"/><manifest:file-entry manifest:full-path="styles.xml" manifest:media-type="text/xml"/><manifest:file-entry manifest:full-path="content.xml" manifest:media-type="text/xml"/><manifest:file-entry manifest:full-path="settings.xml" manifest:media-type="text/xml"/><manifest:file-entry manifest:full-path="Thumbnails/thumbnail.png" manifest:media-type="image/png"/></manifest:manifest> 
	EOF

	cat <<- EOF > "./${TMP_DIR}/manifest.rdf"
		<?xml version="1.0" encoding="utf-8"?><rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"><rdf:Description rdf:about="styles.xml"><rdf:type rdf:resource="http://docs.oasis-open.org/ns/office/1.2/meta/odf#StylesFile"/></rdf:Description><rdf:Description rdf:about=""><ns0:hasPart xmlns:ns0="http://docs.oasis-open.org/ns/office/1.2/meta/pkg#" rdf:resource="styles.xml"/></rdf:Description><rdf:Description rdf:about="content.xml"><rdf:type rdf:resource="http://docs.oasis-open.org/ns/office/1.2/meta/odf#ContentFile"/></rdf:Description><rdf:Description rdf:about=""><ns0:hasPart xmlns:ns0="http://docs.oasis-open.org/ns/office/1.2/meta/pkg#" rdf:resource="content.xml"/></rdf:Description><rdf:Description rdf:about=""><rdf:type rdf:resource="http://docs.oasis-open.org/ns/office/1.2/meta/pkg#Document"/></rdf:Description></rdf:RDF>
	EOF

	cat <<- EOF > "./${TMP_DIR}/meta.xml"
		<office:document-meta xmlns:grddl="http://www.w3.org/2003/g/data-view#" xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:ooo="http://openoffice.org/2004/office" xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" office:version="1.3"><office:meta><meta:document-statistic meta:table-count="1" meta:cell-count="45" meta:object-count="0"/><meta:generator>LibreOffice/7.2.6.2$Linux_X86_64 LibreOffice_project/20$Build-2</meta:generator></office:meta></office:document-meta>
	EOF

	echo -n "application/vnd.oasis.opendocument.spreadsheet" > "./${TMP_DIR}/mimetype"

	cat <<- EOF > "./${TMP_DIR}/settings.xml"
		<office:document-settings xmlns:config="urn:oasis:names:tc:opendocument:xmlns:config:1.0" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:ooo="http://openoffice.org/2004/office" xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" office:version="1.3"><office:settings><config:config-item-set config:name="ooo:view-settings"><config:config-item config:name="VisibleAreaTop" config:type="int">0</config:config-item><config:config-item config:name="VisibleAreaLeft" config:type="int">0</config:config-item><config:config-item config:name="VisibleAreaWidth" config:type="int">28052</config:config-item><config:config-item config:name="VisibleAreaHeight" config:type="int">2257</config:config-item><config:config-item-map-indexed config:name="Views"><config:config-item-map-entry><config:config-item config:name="ViewId" config:type="string">view1</config:config-item><config:config-item-map-named config:name="Tables"><config:config-item-map-entry config:name="default"><config:config-item config:name="CursorPositionX" config:type="int">0</config:config-item><config:config-item config:name="CursorPositionY" config:type="int">0</config:config-item><config:config-item config:name="HorizontalSplitMode" config:type="short">0</config:config-item><config:config-item config:name="VerticalSplitMode" config:type="short">0</config:config-item><config:config-item config:name="HorizontalSplitPosition" config:type="int">0</config:config-item><config:config-item config:name="VerticalSplitPosition" config:type="int">0</config:config-item><config:config-item config:name="ActiveSplitRange" config:type="short">2</config:config-item><config:config-item config:name="PositionLeft" config:type="int">0</config:config-item><config:config-item config:name="PositionRight" config:type="int">0</config:config-item><config:config-item config:name="PositionTop" config:type="int">0</config:config-item><config:config-item config:name="PositionBottom" config:type="int">0</config:config-item><config:config-item config:name="ZoomType" config:type="short">0</config:config-item><config:config-item config:name="ZoomValue" config:type="int">100</config:config-item><config:config-item config:name="PageViewZoomValue" config:type="int">60</config:config-item><config:config-item config:name="ShowGrid" config:type="boolean">true</config:config-item><config:config-item config:name="AnchoredTextOverflowLegacy" config:type="boolean">false</config:config-item></config:config-item-map-entry></config:config-item-map-named><config:config-item config:name="ActiveTable" config:type="string">default</config:config-item><config:config-item config:name="HorizontalScrollbarWidth" config:type="int">1256</config:config-item><config:config-item config:name="ZoomType" config:type="short">0</config:config-item><config:config-item config:name="ZoomValue" config:type="int">100</config:config-item><config:config-item config:name="PageViewZoomValue" config:type="int">60</config:config-item><config:config-item config:name="ShowPageBreakPreview" config:type="boolean">false</config:config-item><config:config-item config:name="ShowZeroValues" config:type="boolean">true</config:config-item><config:config-item config:name="ShowNotes" config:type="boolean">true</config:config-item><config:config-item config:name="ShowGrid" config:type="boolean">true</config:config-item><config:config-item config:name="GridColor" config:type="int">12632256</config:config-item><config:config-item config:name="ShowPageBreaks" config:type="boolean">true</config:config-item><config:config-item config:name="HasColumnRowHeaders" config:type="boolean">true</config:config-item><config:config-item config:name="HasSheetTabs" config:type="boolean">true</config:config-item><config:config-item config:name="IsOutlineSymbolsSet" config:type="boolean">true</config:config-item><config:config-item config:name="IsValueHighlightingEnabled" config:type="boolean">false</config:config-item><config:config-item config:name="IsSnapToRaster" config:type="boolean">false</config:config-item><config:config-item config:name="RasterIsVisible" config:type="boolean">false</config:config-item><config:config-item config:name="RasterResolutionX" config:type="int">1000</config:config-item><config:config-item config:name="RasterResolutionY" config:type="int">1000</config:config-item><config:config-item config:name="RasterSubdivisionX" config:type="int">1</config:config-item><config:config-item config:name="RasterSubdivisionY" config:type="int">1</config:config-item><config:config-item config:name="IsRasterAxisSynchronized" config:type="boolean">true</config:config-item><config:config-item config:name="AnchoredTextOverflowLegacy" config:type="boolean">false</config:config-item></config:config-item-map-entry></config:config-item-map-indexed></config:config-item-set><config:config-item-set config:name="ooo:configuration-settings"><config:config-item config:name="AllowPrintJobCancel" config:type="boolean">true</config:config-item><config:config-item config:name="ApplyUserData" config:type="boolean">true</config:config-item><config:config-item config:name="AutoCalculate" config:type="boolean">true</config:config-item><config:config-item config:name="CharacterCompressionType" config:type="short">0</config:config-item><config:config-item config:name="EmbedAsianScriptFonts" config:type="boolean">true</config:config-item><config:config-item config:name="EmbedComplexScriptFonts" config:type="boolean">true</config:config-item><config:config-item config:name="EmbedFonts" config:type="boolean">false</config:config-item><config:config-item config:name="EmbedLatinScriptFonts" config:type="boolean">true</config:config-item><config:config-item config:name="EmbedOnlyUsedFonts" config:type="boolean">false</config:config-item><config:config-item config:name="GridColor" config:type="int">12632256</config:config-item><config:config-item config:name="HasColumnRowHeaders" config:type="boolean">true</config:config-item><config:config-item config:name="HasSheetTabs" config:type="boolean">true</config:config-item><config:config-item config:name="IsDocumentShared" config:type="boolean">false</config:config-item><config:config-item config:name="IsKernAsianPunctuation" config:type="boolean">false</config:config-item><config:config-item config:name="IsOutlineSymbolsSet" config:type="boolean">true</config:config-item><config:config-item config:name="IsRasterAxisSynchronized" config:type="boolean">true</config:config-item><config:config-item config:name="IsSnapToRaster" config:type="boolean">false</config:config-item><config:config-item config:name="LinkUpdateMode" config:type="short">3</config:config-item><config:config-item config:name="LoadReadonly" config:type="boolean">false</config:config-item><config:config-item config:name="PrinterName" config:type="string"/><config:config-item config:name="PrinterPaperFromSetup" config:type="boolean">false</config:config-item><config:config-item config:name="PrinterSetup" config:type="base64Binary"/><config:config-item config:name="RasterIsVisible" config:type="boolean">false</config:config-item><config:config-item config:name="RasterResolutionX" config:type="int">1000</config:config-item><config:config-item config:name="RasterResolutionY" config:type="int">1000</config:config-item><config:config-item config:name="RasterSubdivisionX" config:type="int">1</config:config-item><config:config-item config:name="RasterSubdivisionY" config:type="int">1</config:config-item><config:config-item config:name="SaveThumbnail" config:type="boolean">true</config:config-item><config:config-item config:name="SaveVersionOnClose" config:type="boolean">false</config:config-item><config:config-item config:name="ShowGrid" config:type="boolean">true</config:config-item><config:config-item config:name="ShowNotes" config:type="boolean">true</config:config-item><config:config-item config:name="ShowPageBreaks" config:type="boolean">true</config:config-item><config:config-item config:name="ShowZeroValues" config:type="boolean">true</config:config-item><config:config-item config:name="UpdateFromTemplate" config:type="boolean">true</config:config-item><config:config-item-map-named config:name="ScriptConfiguration"><config:config-item-map-entry config:name="default"><config:config-item config:name="CodeName" config:type="string">Sheet1</config:config-item></config:config-item-map-entry></config:config-item-map-named></config:config-item-set></office:settings></office:document-settings>
	EOF

	cat <<- EOF > "./${TMP_DIR}/styles.xml"
		<office:document-styles xmlns:presentation="urn:oasis:names:tc:opendocument:xmlns:presentation:1.0" xmlns:css3t="http://www.w3.org/TR/css3-text/" xmlns:rpt="http://openoffice.org/2005/report" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0" xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0" xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0" xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" xmlns:oooc="http://openoffice.org/2004/calc" xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" xmlns:ooow="http://openoffice.org/2004/writer" xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0" xmlns:ooo="http://openoffice.org/2004/office" xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0" xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0" xmlns:of="urn:oasis:names:tc:opendocument:xmlns:of:1.2" xmlns:calcext="urn:org:documentfoundation:names:experimental:calc:xmlns:calcext:1.0" xmlns:tableooo="http://openoffice.org/2009/table" xmlns:drawooo="http://openoffice.org/2010/draw" xmlns:grddl="http://www.w3.org/2003/g/data-view#" xmlns:loext="urn:org:documentfoundation:names:experimental:office:xmlns:loext:1.0" xmlns:dom="http://www.w3.org/2001/xml-events" xmlns:field="urn:openoffice:names:experimental:ooo-ms-interop:xmlns:field:1.0" xmlns:math="http://www.w3.org/1998/Math/MathML" xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0" xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0" xmlns:xhtml="http://www.w3.org/1999/xhtml" office:version="1.3"><office:font-face-decls><style:font-face style:name="Liberation Sans" svg:font-family="'Liberation Sans'" style:font-family-generic="swiss" style:font-pitch="variable"/><style:font-face style:name="Lohit Devanagari" svg:font-family="'Lohit Devanagari'" style:font-family-generic="system" style:font-pitch="variable"/><style:font-face style:name="Noto Sans CJK SC" svg:font-family="'Noto Sans CJK SC'" style:font-family-generic="system" style:font-pitch="variable"/></office:font-face-decls><office:styles><style:default-style style:family="table-cell"><style:paragraph-properties style:tab-stop-distance="1.25cm"/><style:text-properties style:font-name="Liberation Sans" fo:font-size="10pt" fo:language="en" fo:country="GB" style:font-name-asian="Noto Sans CJK SC" style:font-size-asian="10pt" style:language-asian="zh" style:country-asian="CN" style:font-name-complex="Lohit Devanagari" style:font-size-complex="10pt" style:language-complex="hi" style:country-complex="IN"/></style:default-style><number:number-style style:name="N0"><number:number number:min-integer-digits="1"/></number:number-style><style:style style:name="Default" style:family="table-cell"/><style:style style:name="Heading" style:family="table-cell" style:parent-style-name="Default"><style:text-properties fo:color="#000000" fo:font-size="24pt" fo:font-style="normal" fo:font-weight="bold" style:font-size-asian="24pt" style:font-style-asian="normal" style:font-weight-asian="bold" style:font-size-complex="24pt" style:font-style-complex="normal" style:font-weight-complex="bold"/></style:style><style:style style:name="Heading_20_1" style:display-name="Heading 1" style:family="table-cell" style:parent-style-name="Heading"><style:text-properties fo:color="#000000" fo:font-size="18pt" fo:font-style="normal" fo:font-weight="normal" style:font-size-asian="18pt" style:font-style-asian="normal" style:font-weight-asian="normal" style:font-size-complex="18pt" style:font-style-complex="normal" style:font-weight-complex="normal"/></style:style><style:style style:name="Heading_20_2" style:display-name="Heading 2" style:family="table-cell" style:parent-style-name="Heading"><style:text-properties fo:color="#000000" fo:font-size="12pt" fo:font-style="normal" fo:font-weight="normal" style:font-size-asian="12pt" style:font-style-asian="normal" style:font-weight-asian="normal" style:font-size-complex="12pt" style:font-style-complex="normal" style:font-weight-complex="normal"/></style:style><style:style style:name="Text" style:family="table-cell" style:parent-style-name="Default"/><style:style style:name="Note" style:family="table-cell" style:parent-style-name="Text"><style:table-cell-properties fo:background-color="#ffffcc" style:diagonal-bl-tr="none" style:diagonal-tl-br="none" fo:border="0.74pt solid #808080"/><style:text-properties fo:color="#333333" fo:font-size="10pt" fo:font-style="normal" fo:font-weight="normal" style:font-size-asian="10pt" style:font-style-asian="normal" style:font-weight-asian="normal" style:font-size-complex="10pt" style:font-style-complex="normal" style:font-weight-complex="normal"/></style:style><style:style style:name="Footnote" style:family="table-cell" style:parent-style-name="Text"><style:text-properties fo:color="#808080" fo:font-size="10pt" fo:font-style="italic" fo:font-weight="normal" style:font-size-asian="10pt" style:font-style-asian="italic" style:font-weight-asian="normal" style:font-size-complex="10pt" style:font-style-complex="italic" style:font-weight-complex="normal"/></style:style><style:style style:name="Hyperlink" style:family="table-cell" style:parent-style-name="Text"><style:text-properties fo:color="#0000ee" fo:font-size="10pt" fo:font-style="normal" style:text-underline-style="solid" style:text-underline-width="auto" style:text-underline-color="#0000ee" fo:font-weight="normal" style:font-size-asian="10pt" style:font-style-asian="normal" style:font-weight-asian="normal" style:font-size-complex="10pt" style:font-style-complex="normal" style:font-weight-complex="normal"/></style:style><style:style style:name="Status" style:family="table-cell" style:parent-style-name="Default"/><style:style style:name="Good" style:family="table-cell" style:parent-style-name="Status"><style:table-cell-properties fo:background-color="#ccffcc"/><style:text-properties fo:color="#006600" fo:font-size="10pt" fo:font-style="normal" fo:font-weight="normal" style:font-size-asian="10pt" style:font-style-asian="normal" style:font-weight-asian="normal" style:font-size-complex="10pt" style:font-style-complex="normal" style:font-weight-complex="normal"/></style:style><style:style style:name="Neutral" style:family="table-cell" style:parent-style-name="Status"><style:table-cell-properties fo:background-color="#ffffcc"/><style:text-properties fo:color="#996600" fo:font-size="10pt" fo:font-style="normal" fo:font-weight="normal" style:font-size-asian="10pt" style:font-style-asian="normal" style:font-weight-asian="normal" style:font-size-complex="10pt" style:font-style-complex="normal" style:font-weight-complex="normal"/></style:style><style:style style:name="Bad" style:family="table-cell" style:parent-style-name="Status"><style:table-cell-properties fo:background-color="#ffcccc"/><style:text-properties fo:color="#cc0000" fo:font-size="10pt" fo:font-style="normal" fo:font-weight="normal" style:font-size-asian="10pt" style:font-style-asian="normal" style:font-weight-asian="normal" style:font-size-complex="10pt" style:font-style-complex="normal" style:font-weight-complex="normal"/></style:style><style:style style:name="Warning" style:family="table-cell" style:parent-style-name="Status"><style:text-properties fo:color="#cc0000" fo:font-size="10pt" fo:font-style="normal" fo:font-weight="normal" style:font-size-asian="10pt" style:font-style-asian="normal" style:font-weight-asian="normal" style:font-size-complex="10pt" style:font-style-complex="normal" style:font-weight-complex="normal"/></style:style><style:style style:name="Error" style:family="table-cell" style:parent-style-name="Status"><style:table-cell-properties fo:background-color="#cc0000"/><style:text-properties fo:color="#ffffff" fo:font-size="10pt" fo:font-style="normal" fo:font-weight="bold" style:font-size-asian="10pt" style:font-style-asian="normal" style:font-weight-asian="bold" style:font-size-complex="10pt" style:font-style-complex="normal" style:font-weight-complex="bold"/></style:style><style:style style:name="Accent" style:family="table-cell" style:parent-style-name="Default"><style:text-properties fo:color="#000000" fo:font-size="10pt" fo:font-style="normal" fo:font-weight="bold" style:font-size-asian="10pt" style:font-style-asian="normal" style:font-weight-asian="bold" style:font-size-complex="10pt" style:font-style-complex="normal" style:font-weight-complex="bold"/></style:style><style:style style:name="Accent_20_1" style:display-name="Accent 1" style:family="table-cell" style:parent-style-name="Accent"><style:table-cell-properties fo:background-color="#000000"/><style:text-properties fo:color="#ffffff" fo:font-size="10pt" fo:font-style="normal" fo:font-weight="normal" style:font-size-asian="10pt" style:font-style-asian="normal" style:font-weight-asian="normal" style:font-size-complex="10pt" style:font-style-complex="normal" style:font-weight-complex="normal"/></style:style><style:style style:name="Accent_20_2" style:display-name="Accent 2" style:family="table-cell" style:parent-style-name="Accent"><style:table-cell-properties fo:background-color="#808080"/><style:text-properties fo:color="#ffffff" fo:font-size="10pt" fo:font-style="normal" fo:font-weight="normal" style:font-size-asian="10pt" style:font-style-asian="normal" style:font-weight-asian="normal" style:font-size-complex="10pt" style:font-style-complex="normal" style:font-weight-complex="normal"/></style:style><style:style style:name="Accent_20_3" style:display-name="Accent 3" style:family="table-cell" style:parent-style-name="Accent"><style:table-cell-properties fo:background-color="#dddddd"/></style:style><style:style style:name="Result" style:family="table-cell" style:parent-style-name="Default"><style:text-properties fo:color="#000000" fo:font-size="10pt" fo:font-style="italic" style:text-underline-style="solid" style:text-underline-width="auto" style:text-underline-color="#000000" fo:font-weight="bold" style:font-size-asian="10pt" style:font-style-asian="italic" style:font-weight-asian="bold" style:font-size-complex="10pt" style:font-style-complex="italic" style:font-weight-complex="bold"/></style:style></office:styles><office:automatic-styles><number:number-style style:name="N2"><number:number number:decimal-places="2" number:min-decimal-places="2" number:min-integer-digits="1"/></number:number-style><style:page-layout style:name="Mpm1"><style:page-layout-properties style:writing-mode="lr-tb"/><style:header-style><style:header-footer-properties fo:min-height="0.75cm" fo:margin-left="0cm" fo:margin-right="0cm" fo:margin-bottom="0.25cm"/></style:header-style><style:footer-style><style:header-footer-properties fo:min-height="0.75cm" fo:margin-left="0cm" fo:margin-right="0cm" fo:margin-top="0.25cm"/></style:footer-style></style:page-layout><style:page-layout style:name="Mpm2"><style:page-layout-properties style:writing-mode="lr-tb"/><style:header-style><style:header-footer-properties fo:min-height="0.75cm" fo:margin-left="0cm" fo:margin-right="0cm" fo:margin-bottom="0.25cm" fo:border="2.49pt solid #000000" fo:padding="0.018cm" fo:background-color="#c0c0c0"><style:background-image/></style:header-footer-properties></style:header-style><style:footer-style><style:header-footer-properties fo:min-height="0.75cm" fo:margin-left="0cm" fo:margin-right="0cm" fo:margin-top="0.25cm" fo:border="2.49pt solid #000000" fo:padding="0.018cm" fo:background-color="#c0c0c0"><style:background-image/></style:header-footer-properties></style:footer-style></style:page-layout></office:automatic-styles><office:master-styles><style:master-page style:name="Default" style:page-layout-name="Mpm1"><style:header><text:p><text:sheet-name>???</text:sheet-name></text:p></style:header><style:header-left style:display="false"/><style:header-first style:display="false"/><style:footer><text:p>Page<text:page-number>1</text:page-number></text:p></style:footer><style:footer-left style:display="false"/><style:footer-first style:display="false"/></style:master-page><style:master-page style:name="Report" style:page-layout-name="Mpm2"><style:header><style:region-left><text:p><text:sheet-name>???</text:sheet-name><text:s/>(<text:title>???</text:title>)</text:p></style:region-left><style:region-right><text:p><text:date style:data-style-name="N2" text:date-value="2022-04-15">00/00/0000</text:date>,<text:time>00:00:00</text:time></text:p></style:region-right></style:header><style:header-left style:display="false"/><style:header-first style:display="false"/><style:footer><text:p>Page<text:page-number>1</text:page-number><text:s/>/<text:page-count>99</text:page-count></text:p></style:footer><style:footer-left style:display="false"/><style:footer-first style:display="false"/></style:master-page></office:master-styles></office:document-styles>
	EOF
}

ods_write_content_header(){
	cat <<- EOF >> "./${TMP_DIR}/content.xml" 
	<office:document-content xmlns:presentation="urn:oasis:names:tc:opendocument:xmlns:presentation:1.0" xmlns:css3t="http://www.w3.org/TR/css3-text/" xmlns:grddl="http://www.w3.org/2003/g/data-view#" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:formx="urn:openoffice:names:experimental:ooxml-odf-interop:xmlns:form:1.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:rpt="http://openoffice.org/2005/report" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0" xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0" xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0" xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" xmlns:oooc="http://openoffice.org/2004/calc" xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" xmlns:ooow="http://openoffice.org/2004/writer" xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0" xmlns:ooo="http://openoffice.org/2004/office" xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0" xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0" xmlns:of="urn:oasis:names:tc:opendocument:xmlns:of:1.2" xmlns:calcext="urn:org:documentfoundation:names:experimental:calc:xmlns:calcext:1.0" xmlns:tableooo="http://openoffice.org/2009/table" xmlns:drawooo="http://openoffice.org/2010/draw" xmlns:loext="urn:org:documentfoundation:names:experimental:office:xmlns:loext:1.0" xmlns:dom="http://www.w3.org/2001/xml-events" xmlns:field="urn:openoffice:names:experimental:ooo-ms-interop:xmlns:field:1.0" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:math="http://www.w3.org/1998/Math/MathML" xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0" xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0" xmlns:xforms="http://www.w3.org/2002/xforms" office:version="1.3"><office:scripts/><office:font-face-decls><style:font-face style:name="Liberation Sans" svg:font-family="'Liberation Sans'" style:font-family-generic="swiss" style:font-pitch="variable"/><style:font-face style:name="Lohit Devanagari" svg:font-family="'Lohit Devanagari'" style:font-family-generic="system" style:font-pitch="variable"/><style:font-face style:name="Noto Sans CJK SC" svg:font-family="'Noto Sans CJK SC'" style:font-family-generic="system" style:font-pitch="variable"/></office:font-face-decls><office:automatic-styles><style:style style:name="co1" style:family="table-column"><style:table-column-properties fo:break-before="auto" style:column-width="2.813cm"/></style:style><style:style style:name="co2" style:family="table-column"><style:table-column-properties fo:break-before="auto" style:column-width="2.05cm"/></style:style><style:style style:name="co3" style:family="table-column"><style:table-column-properties fo:break-before="auto" style:column-width="2.104cm"/></style:style><style:style style:name="co4" style:family="table-column"><style:table-column-properties fo:break-before="auto" style:column-width="2.54cm"/></style:style><style:style style:name="co5" style:family="table-column"><style:table-column-properties fo:break-before="auto" style:column-width="1.804cm"/></style:style><style:style style:name="co6" style:family="table-column"><style:table-column-properties fo:break-before="auto" style:column-width="5.918cm"/></style:style><style:style style:name="co7" style:family="table-column"><style:table-column-properties fo:break-before="auto" style:column-width="2.378cm"/></style:style><style:style style:name="co8" style:family="table-column"><style:table-column-properties fo:break-before="auto" style:column-width="1.723cm"/></style:style><style:style style:name="co9" style:family="table-column"><style:table-column-properties fo:break-before="auto" style:column-width="2.35cm"/></style:style><style:style style:name="co10" style:family="table-column"><style:table-column-properties fo:break-before="auto" style:column-width="1.614cm"/></style:style><style:style style:name="co11" style:family="table-column"><style:table-column-properties fo:break-before="auto" style:column-width="2.759cm"/></style:style><style:style style:name="co12" style:family="table-column"><style:table-column-properties fo:break-before="auto" style:column-width="2.258cm"/></style:style><style:style style:name="ro1" style:family="table-row"><style:table-row-properties style:row-height="0.452cm" fo:break-before="auto" style:use-optimal-row-height="true"/></style:style><style:style style:name="ta1" style:family="table" style:master-page-name="Default"><style:table-properties table:display="true" style:writing-mode="lr-tb"/></style:style></office:automatic-styles><office:body><office:spreadsheet><table:calculation-settings table:automatic-find-labels="false" table:use-regular-expressions="false" table:use-wildcards="true"/>
	EOF
}

ods_write_content_footer(){
	cat <<- EOF >> "./${TMP_DIR}/content.xml"
	<table:named-expressions/>
	<table:database-ranges>
	<table:database-range table:name="__Anon0" table:target-range-address="logs.A1:logs.M1" table:display-filter-buttons="true"/>
	<table:database-range table:name="__Anon1" table:target-range-address="geolocation.A1:geolocation.I1" table:display-filter-buttons="true"/>
	</table:database-ranges>
	</office:spreadsheet></office:body></office:document-content>
	EOF
}


# Create ODS Table
#
# ARGUMENTS:
#   Name NumberOfColumns
ods_write_content_start_table(){
	cat <<- EOF >> "./${TMP_DIR}/content.xml"
		<table:table table:name="$1" table:style-name="ta1">
		<table:table-column table:style-name="co1"  table:number-columns-repeated="$2" table:default-cell-style-name="Default"/>
	EOF
}

ods_write_content_end_table(){
	cat <<- EOF >> "./${TMP_DIR}/content.xml"
		</table:table>
	EOF
}

ods_write_content_create_row(){
	echo '<table:table-row table:style-name="ro1">' >> "./${TMP_DIR}/content.xml" 
}

ods_write_content_end_row(){
	echo '</table:table-row>' >> "./${TMP_DIR}/content.xml" 
}

ods_write_content_basic_col(){
	rows=""

	for param in "$@"
	do
		rows+='<table:table-cell office:value-type="string" calcext:value-type="string"><text:p>'"$param"'</text:p></table:table-cell>'
	done

	echo $rows >> "./${TMP_DIR}/content.xml" 
}

ods_write_content_formula_col(){
	rows=""

	for param in "$@"
	do
		rows+='<table:table-cell '$param' office:value-type="string" calcext:value-type="string"><text:p>'" "'</text:p></table:table-cell>'
	done

	echo $rows >> "./${TMP_DIR}/content.xml" 
}

ods_create_file(){
	cd ${TMP_DIR}
	zip -r "../$1.ods" "./content.xml" "./mimetype"  "./meta.xml"  "./manifest.rdf"  "./META-INF/manifest.xml"
	cd ..
}

ods_remove_tmp_files(){
	rm -r ${TMP_DIR}
}

# ---------------------------------------------------------------------------- #
#                                   --------                                   #
# ---------------------------------------------------------------------------- #
# ---------------------------------------------------------------------------- #
#                                   --------                                   #
# ---------------------------------------------------------------------------- #
# ---------------------------------------------------------------------------- #
#                           Main Program Starts Here                           #
# ---------------------------------------------------------------------------- #
# Init variables
geoFlag=0
csvFlag=0

# Parse parameters
while [ ! $# -eq 0 ]; do
	case "$1" in
		-o | --out)
			if [ "$2" ]; then
				outFile="$2"
				shift
			else
				echo '-o or --out requires an argument'
				exit 1
			fi
		;;
		-h | --help)
			help
			exit
		;;
		-g | --geolocation)
			geoFlag=1
		;;
		-c | --csv)
			csvFlag=1
		;;
		-ge | --geolocation-ip-exclude)
			if [ "$2" ]; then
				geolocationIpExclude="$2"
				shift
			else
				echo '-ge or --geolocation-ip-exclude requires a comma separated argument e.g. "172.16.32.1,172.16.32.2"'
				exit 1
			fi
		;;
		*)
			inFile=$1 
		;;
	esac
	shift
done

# Check input file exist
if [ -z ${inFile} ]; then
	echo 'Error : Missing log file.'  
	exit 1    
elif [ ! -f $inFile ]; then
	echo "Error : Log file '$inFile' does not exist."
	exit 1 
fi

if [ -z ${outFile} ]; then
	echo 'Warning : missing -o flag. Using default output file.'  
	outFile="default"
fi

unset IFS

# -------------------------------- Global Var -------------------------------- #
matchTimeNName="match(\$0,/.*? kernel/); timeNName = substr(\$0,RSTART,RLENGTH-7);"
matchTag="match(\$0,/\].*?IN=/); tag = substr(\$0,RSTART+2,RLENGTH-6);"
matchOut="match(\$0,/OUT=.*? M/); outInterface = substr(\$0,RSTART+4,RLENGTH-6);"
matchIn="match(\$0,/IN=.* O/); inInterface = substr(\$0,RSTART+3,RLENGTH-5);"
matchDst="match(\$0,/DST=[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+/); dst = substr(\$0,RSTART+4,RLENGTH-4);"
matchDpt="match(\$0,/DPT=[0-9]{0,5}/); dpt = substr(\$0,RSTART+4,RLENGTH-4);"
matchSrc="match(\$0,/SRC=[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+/); src = substr(\$0,RSTART+4,RLENGTH-4);"
matchSpt="match(\$0,/SPT=[0-9]{0,5}/); spt = substr(\$0,RSTART+4,RLENGTH-4);"
matchProto="match(\$0,/PROTO=\\w+/); proto = substr(\$0,RSTART+6,RLENGTH-6);"
matchMac="match(\$0,/MAC=(\\w+:?){14}/); mac = substr(\$0,RSTART+4,RLENGTH-4);"
matchOutput='print src "," spt "," mac "," inInterface "," dst "," dpt "," outInterface "," proto "," timeNName "," tag'

declare -A srcMap
declare -A destMap
declare -A srcIPGeoLocMap
declare -A destIPGeoLocMap

# Storage for writing to file
logStore=""
geoStore=""

# -------------------------------- Parse file -------------------------------- #
numberOfLines=`wc -l ${inFile}`

processedLine=0
while read -r line
do
	processedLine=$((processedLine + 1))
	echo -en "\r - Parsing ${processedLine} / ${numberOfLines} "
	row=`echo  "$line" | awk "{ ${matchTimeNName} ${matchTag} ${matchOut} ${matchIn} ${matchDst} ${matchDpt} ${matchSrc} ${matchSpt} ${matchProto} ${matchMac} ${matchOutput} }"`
	IFS=',' read -r -a rowData <<< "$row"

	time=`echo ${rowData[8]% *}`
	timeStd=`date --date "$time"`
	name=`echo ${rowData[8]##* }`

	src=${rowData[0]}
	spt=${rowData[1]}
	mac=${rowData[2]}
	inInterface=${rowData[3]}

	dst=${rowData[4]}
	dpt=${rowData[5]}
	outInterface=${rowData[6]}
	proto=${rowData[7]}
	tag=${rowData[9]}
	
	# If invalid line, skipped
	if [ -z "${src}" ]; then
		continue
	fi
	
	# Src Histogram (TODO : do something with this data)
	src_ip_pt="${src}:${spt}"
	
	if [ -v srcMap[${src_ip_pt}] ];
	then
		srcMap[${src_ip_pt}]=srcMap[${src_ip_pt}]+1
	else
		srcMap[${src_ip_pt}]=1
	fi
	
	# Dest Histogram (TODO : do something with this data)
	dst_ip_pt="${dst}:${dpt}"
	
	if [ -v destMap[${dst_ip_pt}] ];
	then
		destMap[${dst_ip_pt}]=destMap[${dst_ip_pt}]+1
	else
		destMap[${dst_ip_pt}]=1
	fi
	
	logStore+="${timeStd},${name},${inInterface},${src},${spt},${mac},${outInterface},${dst},${dpt},${proto},${tag};"
done < "$inFile"

# ------------------ Retrieve IP Geolocation via ip-api.com ------------------ #
unset IFS

if [ $geoFlag -eq 1 ]; then 
	echo "Determining IP Geolocations "
	patternCountry='(\"country\":\").*?(\")'
	patternRegion='(\"regionName\":\").*?(\")'
	patternCity='(\"city\":\").*?(\")'
	patternZip='(\"zip\":\").*?(\")'
	patternIsp='(\"isp\":\").*?(\")'
	patternLat='(\"lat\":)\-?\d+.\d+'
	patternLon='(\"lon":)\-?\d+.\d+'
	patternTz='(\"timezone\":\").*?(\")'
	patternQuery='(\"query\":\").*?(\")'

	matchCountry="match(\$0,/\"country\":\"\\w+\" /); country = substr(\$0,RSTART+11,RLENGTH-13);"
	matchRegion="match(\$0,/\"regionName\":\"\\w+\" /); regionName = substr(\$0,RSTART+14,RLENGTH-16);"
	matchCity="match(\$0,/\"city\":\"\\w+\" /); city = substr(\$0,RSTART+8,RLENGTH-10);"
	matchZip="match(\$0,/\"zip\":\"\\w+\" /); zip = substr(\$0,RSTART+7,RLENGTH-9);"
	matchIsp="match(\$0,/\"isp\":\".*?(\" \")/); isp = substr(\$0,RSTART+7,RLENGTH-11);"
	matchLat="match(\$0,/\"lat\":(-?)[0-9]+.[0-9]+/); lat = substr(\$0,RSTART+6,RLENGTH-6);"
	matchLon="match(\$0,/\"lon\":(-?)[0-9]+.[0-9]+/); lon = substr(\$0,RSTART+6,RLENGTH-6);"
	matchTz="match(\$0,/(\"timezone\":\")\\w+\/?\\w+\"/); tz = substr(\$0,RSTART+12,RLENGTH-13);"
	matchQuery="match(\$0,/\"query\":\".*?\" /); ip = substr(\$0,RSTART+9,RLENGTH-11);"

	matchOutput='print ip  "~" country "~" regionName "~" city "~" zip "~" isp "~" lat "~" lon "~" tz ";" '

	# Private ips
	patternRMPrivateIPs="s/10[.]\\w+[.]\\w+[.]\\w+[ ]?|"
	patternRMPrivateIPs+="192[.]168[.]\\w+[.]\\w+[ ]?|"
	patternRMPrivateIPs+="172[.]1[6-9][.]\\w+[.]\\w+[ ]?|172[.]2[0-9][.]\\w+[.]\\w+[ ]?|172[.]3[0-1][.]\\w+[.]\\w+[ ]?//g"
	
	patternRMPort="s/(:\\w+)//g"
	patternRMLoopback="s/127.0.0.1//g"

	# Extract valid IPs
	srcKeyIPs=${!srcMap[@]}
	srcKeyIPs=`echo $srcKeyIPs | sed -r "$patternRMPort"` # Remove ports
	srcKeyIPs=`echo $srcKeyIPs | sed -r "$patternRMPrivateIPs"` # Remove Private IP
	srcKeyIPs=`echo $srcKeyIPs | sed "$patternRMLoopback"` # Remove loopback
	srcKeyIPs=`echo $srcKeyIPs | sed -r 's/(^[ ]*)|([ ]*$)//g'` # Trim whitespaces

	# Remove user defined ips
	IFS=","
	for ip in $geolocationIpExclude; do
		srcKeyIPs=`echo $srcKeyIPs | sed "s/${ip} //g"`
	done
	unset IFS

	srcKeyIPs=`echo $srcKeyIPs | sed -r 's/ * /","/g'`

	
	# Only post data if there IPs
	if [ -n "${srcKeyIPs}" ]; then 
		# Retrieve geolocation of api
		jsonData=`curl http://ip-api.com/batch --data [\"${srcKeyIPs}\"]`
		
		# Extract Json Data
		jsonExtracted=`echo $jsonData | grep -oP "${patternCountry}|${patternRegion}|${patternCity}|${patternZip}|${patternIsp}|${patternLat}|${patternLon}|${patternTz}|${patternQuery}"`
		i=0
		dataGroup=""
		while read -r line
		do
			dataGroup+="$line "
			i=$((i+1))
			
			if [[ $i == 9 ]]; then
				geoStore+="`echo "$dataGroup" | awk "{ ${matchCountry} ${matchRegion} ${matchCity} ${matchZip} ${matchIsp} ${matchLat} ${matchLon} ${matchTz} ${matchQuery} ${matchOutput} }"`"
				i=0
				dataGroup=""
			fi
		done < <(echo $jsonExtracted)
	fi
fi

# ------------------------------- Write To File ------------------------------ #

IFS=";"
logRows=($logStore)
geoRows=($geoStore)

if [ $csvFlag -eq 1 ]; then
	# Write logs
	echo "DateTime,Label,In Interface,SRC IP,SRC Port,MAC,Out Interface,DEST IP,DEST PORT,Protocol,Tag" > "${outFile}_logs.csv"	# Header row
	
	unset IFS
	rowIdx=2
	for r in "${logRows[@]}"; do
		IFS=","
		c=(${r})
	
		echo "${c[0]},${c[1]},${c[2]},${c[3]},${c[4]},${c[5]},${c[6]},${c[7]},${c[8]},${c[9]},${c[10]} " >> "${outFile}_logs.csv"

		rowIdx=$((rowIdx + 1))
	done

	# Write Geolocation
	echo "IP,Country,Region,City,Zip,ISP,Lat,Lon,Timezone" > "${outFile}_geo.csv"

	unset IFS
	for r in "${geoRows[@]}"; do
		IFS="~"
		c=(${r})
		echo "${c[0]},${c[1]},${c[2]},${c[3]},${c[4]},${c[5]},${c[6]},${c[7]},${c[8]} " >> "${outFile}_geo.csv"
	done

else
	# --------------------------- Create tmp ods files --------------------------- #
	ods_create_placeholder
	ods_write_content_header

	geoCount=$((${#geoRows[@]}+1))

	## Write logs
	ods_write_content_start_table "logs" 13

	ods_write_content_create_row 	# header row
	ods_write_content_basic_col "DateTime" "Label" "In Interface" "SRC IP" "SRC Port" "MAC" "Out Interface" "DEST IP" "DEST PORT" "Protocol" "Tag" "Country" "Region"
	ods_write_content_end_row

	unset IFS
	rowIdx=2
	for r in "${logRows[@]}"; do
		IFS=","
		c=(${r})
		ods_write_content_create_row
		ods_write_content_basic_col "${c[0]} " "${c[1]} " "${c[2]} " "${c[3]} " "${c[4]} " "${c[5]} " "${c[6]} " "${c[7]} " "${c[8]} " "${c[9]} " "${c[10]} "
		ods_write_content_formula_col 'table:formula="of:=LOOKUP([.$D'$rowIdx'];[$geolocation.$A$2:.$A$'$geoCount'];[$geolocation.$B$2:.$B$'$geoCount'])"' 'table:formula="of:=LOOKUP([.$D'$rowIdx'];[$geolocation.$A$2:.$A$'$geoCount'];[$geolocation.$C$2:.$C$'$geoCount'])"'
		ods_write_content_end_row

		rowIdx=$((rowIdx + 1))
	done
	ods_write_content_end_table

	## Write Geolocation
	ods_write_content_start_table "geolocation" 9
	
	ods_write_content_create_row	# header row
	ods_write_content_basic_col "IP" "Country" "Region" "City" "Zip" "ISP" "Lat" "Lon" "Timezone"
	ods_write_content_end_row

	unset IFS
	for r in "${geoRows[@]}"; do
		IFS="~"
		c=(${r})
		ods_write_content_create_row
		ods_write_content_basic_col "${c[0]} " "${c[1]} " "${c[2]} " "${c[3]} " "${c[4]} " "${c[5]} " "${c[6]} " "${c[7]} " "${c[8]} "
		ods_write_content_end_row
	done
	
	ods_write_content_end_table
	ods_write_content_footer

	# ------------------ Zip Into .ods file and remove tmp files ----------------- #
	ods_create_file $outFile
	ods_remove_tmp_files
fi

echo
echo "Complete..."

