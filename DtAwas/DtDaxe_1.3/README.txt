To try Daxe, copy the daxe folder on a web server and open the test.html file in a web browser (scripts cannot open local files, so don't even try to open test.html locally). It will open a new XPAGES document.

An XML file can be opened by adding the file parameter and the Jaxe config path to the URL, for instance:
daxe.html?file=test.xml&config=config/XPAGES_config.xml

To save the file, a script is required on the server, and can be specified with the save parameter in the URL.

For integration in a CMS, take a look at WebJaxe.
