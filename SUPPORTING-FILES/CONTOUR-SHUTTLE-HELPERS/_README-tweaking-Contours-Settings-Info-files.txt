To create these files, open the Contour ShuttlePRO settings app & select "Export Settings Info" from the "Options" button under the given settings name in the pulldown menu on the left.

Make these small changes to any HTML helper file you export from Contour Pro Shuttle:

1) Add this text:

	<div align="center">

	Paste it just below this line, at the top:
	
	<font face="Tahoma" size="3">

2) Find the line, near the bottom, of what setting this is. It's probably the 3rd to last line. It looks like this:

	<font size="2">SETTING NAME HERE</font>
	
	Cut it and paste it near the top - just below the align center DIV you added in the first step.
	
	Change the font size to 8 or 10. That will make it big and readable.
	
NOTE:

The Contour Shuttle Settings app links to the background file (the image of whichever ShuttlePRO model) in the directory where it gets installed. Just beware of that if you are trying to use my modified files as is. - Ben