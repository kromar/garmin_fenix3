using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.ActivityMonitor as ActMon;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Gregorian;
using Toybox.Lang as Lang;
using Toybox.Application as App;
using Toybox.Math as Math;


//!sunrise/sunset
//https://github.com/anderssonfilip/SunriseSunset


class BinarySystemView extends Ui.WatchFace {

	var binaryLocation = new BinaryLocation();
	var batteryView = new BatteryView();
	var stepsView = new StepsView();
	var notificationView = new NotificationView();
	
    function initialize() {
        WatchFace.initialize();
    }

    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    }
	
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
    
    //===============================
    //! Update the view
    //===============================
    function onUpdate(dc) {
        // Get the current time and format it correctly

        var geekMode = App.getApp().getProperty("GeekMode");
        Sys.println("geek mode: " + geekMode);

        var sysStats = Sys.getSystemStats();
        var battery = sysStats.battery;
        var alarm = Sys.getTimer();

        var deviceSettings = Sys.getDeviceSettings();
        var notificationCount = deviceSettings.notificationCount;
        var alarmCount = deviceSettings.alarmCount;
        var phoneConnected = deviceSettings.phoneConnected;
        //var temperature = deviceSettings.temperature;
        //var altitude = deviceSettings.altitude;

        var activityInfo = ActMon.getInfo();

        var width = dc.getWidth();
        var height = dc.getHeight();
        //var fontheight = dc.getFontHeight();
        var dot_color = App.getApp().getProperty("ForegroundColor");
        var bg_color = Gfx.COLOR_BLACK;
        var fg_color = Gfx.COLOR_WHITE;
        var bg_transp = Gfx.COLOR_TRANSPARENT;
        var fontHeight = 12;



        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        // Include anything that needs to be updated here

        var now = Time.now();
        var time = Gregorian.info(now, Time.FORMAT_LONG);
        var clockTime = Sys.getClockTime();
        var hours = time.hour;
        var minutes = time.min;
        var seconds = time.sec;

        if (!Sys.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        }


        //===============================
        //!draw time
        //===============================
        if (geekMode) {
            //===============================
            //!draw date
            //===============================
            var dateStr = Lang.format("$1$ $2$", [time.day_of_week, time.day]);
            dc.setColor(dot_color, bg_transp);
            dc.drawText(10, height/2-fontHeight, Gfx.FONT_TINY, dateStr, Gfx.TEXT_JUSTIFY_LEFT);
        }
        else {
            var timeStr = Lang.format("$1$:$2$", [hours, minutes.format("%02d")]);
            dc.setColor(fg_color, bg_transp);
            dc.drawText(94, 90, Gfx.FONT_LARGE, timeStr, Gfx.TEXT_JUSTIFY_RIGHT);
            //===============================
            //!draw date
            //===============================
            var dateStr = Lang.format("$1$ $2$", [time.day_of_week, time.day]);
            dc.setColor(dot_color, bg_transp);
            dc.drawText(94, 120, Gfx.FONT_TINY, dateStr, Gfx.TEXT_JUSTIFY_RIGHT);
        }



        if (geekMode) {

            //===============================
            //!battery percentage
            //===============================
            var batteryPercentageStr = battery.format("%d");
            batteryPrediction(seconds, battery, 24);

            if (remainingBatteryEstimateMode) {
                if (remainingBattery) {
                    Sys.println("remaining: " + remainingBattery);
                    if (remainingBattery < 1.0) {
                        //convert to hours remaining
                        var remainingBatteryHours = remainingBattery * 60;
                        batteryPercentageStr = (remainingBatteryHours.format("%.f") + "h - " + batteryPercentageStr + "%");
                    } else {
                        //show remaining in days
                        batteryPercentageStr = (remainingBattery.format("%.f") + "d - " + batteryPercentageStr + "%");
                    }
                } else {
                    batteryPercentageStr = (batteryPercentageStr + "%");
                }

            } else {
                batteryPercentageStr = (batteryPercentageStr + "%");
            }
            dc.setColor(dot_color, bg_transp);
            dc.drawText(width/2, height-20-fontHeight, Gfx.FONT_TINY, batteryPercentageStr, Gfx.TEXT_JUSTIFY_CENTER);

        }
        else {
			
			batteryView.drawBatteryBar(dc);
			batteryView.drawBatteryPercentage(dc);


         }


        //===============================
        //!distance
        //===============================
		stepsView.drawSteps(dc);
        
        //===============================
        //!calories
        //===============================



        //===============================
        //!alarm
        //===============================
        //Toybox::System::DeviceSettings
        //alarmCount


        //===============================
        //!timer
        //===============================
        //Toybox::System
        //getTimer

        //===============================
        //!phone connected
        //===============================
        //Toybox::System::DeviceSettings
        //phoneConnected


        //===============================
        //!temperature
        //===============================
        //Toybox::System::DeviceSettings
        //temperatureUnits

        //===============================
        //!binary clock numbers
        //===============================
        //dc.setColor(fg_color, bg_transp);
        //dc.drawText(dotX,height-border-fontHeight, 1, "1", Gfx.TEXT_JUSTIFY_CENTER);
        //dc.drawText(dotX,height-1*dotY-border-fontHeight, 1, "2", Gfx.TEXT_JUSTIFY_CENTER);
        //dc.drawText(dotX,height-2*dotY-border-fontHeight, 1, "4", Gfx.TEXT_JUSTIFY_CENTER);
        //dc.drawText(dotX,height-3*dotY-border-fontHeight, 1, "8", Gfx.TEXT_JUSTIFY_CENTER);
        //dc.drawText(dotX,height-4*dotY-border-fontHeight, 1, "16", Gfx.TEXT_JUSTIFY_CENTER);
        //dc.drawText(dotX,height-5*dotY-border-fontHeight, 1, "32", Gfx.TEXT_JUSTIFY_CENTER);


        //===============================
        //!binary clock hours
        //===============================
        //drawBinaryLayout(dc, height, width, hours, minutes, seconds, geekMode);
		drawBinaryArray(dc, 6, 0, seconds, binaryLocation.method(:linearLocation));
		drawBinaryArray(dc, 6, 0, minutes, binaryLocation.method(:circularLocation));
		drawBinaryArray(dc, 6, 1, hours, binaryLocation.method(:circularLocation));
    }



    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    }

    //! The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    //! Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

}
