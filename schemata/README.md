## schemata folder

This folder contains the schemas needed for the cgrid project.

* `tei_jtei.odd.xml`: the compiled ODD of the jTEI customization. It servers as the source for the cgrid customization. Copied from the [TEI customization page](http://www.tei-c.org/Guidelines/Customization/) and compiled with [OxGarage](http://www.tei-c.org/oxgarage/).
* `cgrid.odd`: the cgrid customization expressed as ODD file.
* `cgrid.rng`: the cgrid customization expressed as RelaxNG schema. The files within the tei folder should be validated against this schema.
