using Toybox.Application as App;
using Toybox.Graphics as Gfx;
using Toybox.Time.Gregorian as Gregorian;
using Toybox.Time as Time;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class BinaryView extends Ui.Drawable
{
	var typeMethod = null;
	var showSeconds = true;
	var isLowPowerMode = false;
	function initialize(params)
	{
		Drawable.initialize(params);

		locX = params.get(:x);
		locY = params.get(:y);
		showSeconds = params.get(:showSeconds);
		binaryLocation = new BinaryLocation();
		binaryLocation.locX = locX;
		binaryLocation.locY = locY;
		binaryLocation.borderDistance = params.get(:borderDistance);

		var type = params.get(:type);
		Sys.println("binary type: " + type);
		if (type.equals(Circular))
		{
			Sys.println("Using Circular location");
			typeMethod = binaryLocation.method(:circularLocation);
		}
		else if (type.equals(Vertical))
		{
			Sys.println("Using Vertical locations");
			typeMethod = binaryLocation.method(:verticalLocation);
		}
			else if (type.equals(Horizontal))
		{
			Sys.println("Using Vertical locations");
			typeMethod = binaryLocation.method(:horizontalLocation);
		}
	}
	var binaryLocation;

	function drawBinaryArray(dc, rows, column, count, locationCallback)
	{
		var binaryRadius = Application.Properties.getValue("BinaryRadius");
		var color_rgb = Application.Properties.getValue("ForegroundColor");
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
            dc.drawCircle(xLocation, yLocation, binaryRadius);

			if (count & value == value)
			{
				dc.setColor(color_rgb, color_bg);
    	        dc.fillCircle(xLocation, yLocation, binaryRadius - 1);

			}
		}
	}

	function onExitSleep() {
        isLowPowerMode = false;
    }

    //! Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
        isLowPowerMode = true;
        Ui.requestUpdate();
    }

	function draw(dc)
	{
		var now = Time.now();
        var time = Gregorian.info(now, Time.FORMAT_LONG);


		var appShowSeconds = Application.Properties.getValue("ShowSeconds");
		if (isLowPowerMode == false
			&& appShowSeconds == true
			&& showSeconds == true)
		{
			drawBinaryArray(dc, 6, 0, time.sec, typeMethod);
		}
		drawBinaryArray(dc, 6, 1, time.min, typeMethod);
		drawBinaryArray(dc, 6, 2, time.hour, typeMethod);
	}
 }