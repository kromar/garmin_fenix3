using Toybox.Application as App;
using Toybox.Graphics as Gfx;

class BinaryView
{
	var binaryLocation = new BinaryLocation();

	function drawBinaryArray(dc, rows, column, count, locationCallback)
	{
		var binaryRadius = App.getApp().getProperty("BinaryRadius");
		var color_rgb = App.getApp().getProperty("ForegroundColor");
        var color_bg = Gfx.COLOR_BLACK;
	    var color_fg = Gfx.COLOR_WHITE;
		
		var width = dc.getWidth();
        var height = dc.getHeight();
		
		for(var iL = 0; iL < rows; iL++)
		{
			var value = 1 << iL;

			// using location through callback
			var location = locationCallback.invoke(dc, column, iL);
			var xLocation = location[0];
			var yLocation = location[1];

			dc.setColor(color_fg, color_bg);
            dc.fillCircle(xLocation, yLocation, binaryRadius);
			dc.setColor(color_bg, color_bg);
            dc.fillCircle(xLocation, yLocation, binaryRadius - 1);
			
			if (count & value == value)
			{
				dc.setColor(color_rgb, color_bg);
    	        dc.fillCircle(xLocation, yLocation, binaryRadius - 2);
			
			}
		}
	}
	
	function drawBinaryLayout(dc, seconds, minutes, hours)
	{
		drawBinaryArray(dc, 6, 0, seconds, binaryLocation.method(:circularLocation));
		drawBinaryArray(dc, 6, 1, minutes, binaryLocation.method(:circularLocation));
		drawBinaryArray(dc, 6, 2, hours, binaryLocation.method(:circularLocation));
	}
    
 }