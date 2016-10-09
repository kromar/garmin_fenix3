using Toybox.Application as App;
using Toybox.Graphics as Gfx;
using Toybox.Time.Gregorian as Gregorian;
using Toybox.Time as Time;
using Toybox.WatchUi as Ui;

class BinaryView extends Ui.Drawable
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
	
	function draw(dc)
	{
		var now = Time.now();
        var time = Gregorian.info(now, Time.FORMAT_LONG);
		
		drawBinaryArray(dc, 6, 0, time.sec, binaryLocation.method(:circularLocation));
		drawBinaryArray(dc, 6, 1, time.min, binaryLocation.method(:circularLocation));
		drawBinaryArray(dc, 6, 2, time.hour, binaryLocation.method(:circularLocation));
	}
    
 }