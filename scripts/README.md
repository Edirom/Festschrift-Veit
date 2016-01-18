## scripts folder

This folder contains various scripts needed for the cgrid project. 

* `tei-raw2jTEI.xsl`: basic transformation from OxGarage TEI P5 input to jTEI.
* `listPersons.xsl`: scans for `<name/>`s in `//tei:body` and prints them in alphabetical order as `listPerson/person/p`, enclosed by a `<particDesc/>`
* `listWorks.xsl`: scans for `<title/>`s in `//tei:body` and prints them in alphabetical order as `listPerson/person/p@n='work'`, enclosed by a `<particDesc/>`
* `extract-URLs.xsl`: extracts URLs from all TEI files for the ANT linkchecker task
* `to-latex`: main script for transforming TEI -> LaTeX