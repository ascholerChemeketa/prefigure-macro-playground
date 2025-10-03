Each directory has a sample "macro" to transform an author-defined element into prefig commands.

Contents of each:
* a `diagram-raw.xml` file that is the authored xml
* a `*-macro.xsl` file with the macro
* a `build.sh` script to run the xsl on the xml, resulting in `document.xml` in `processed/` and then `prefig` on that to produce an svg.

simple_variable
: macro for drawing variables in a memory diagram

annotated_variable
: same as simple_variable but with extra rules to generate annotations for the variables
