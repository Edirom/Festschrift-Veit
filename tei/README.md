## tei folder

This folder contains the articles in TEI P5 format. These files are the source for later transformations to PDF and HTML. 

The filenames are normalized to `author.xml`.

The special file `master.xml` wraps up all the chapters of the book via xinclude.

### Workflow

1. Transform files from `../inbox` folder via [OxGarage](http://www.tei-c.org/oxgarage/) to TEI P5. 
2. Apply transformation `../scripts/tei-raw2jTEI.xsl` to create a basic jTEI format.
3. Manually edit the files, especially:
	* remove quotation marks and add respective `<q>`, `<soCalled>`  or `<quote>` encoding 
	* move `<note>`s into `<bibl>` and `<ref>` where applicable
	* create bibliography in the `<back>` part
	* add abstract(?)
	* add figures
	* normalize and replace various Unicode characters (especially whitespaces and dashes)
	* document changes in `<revisionDesc>`
