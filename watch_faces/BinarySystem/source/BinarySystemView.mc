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

	var binaryView = new BinaryView();
	var batteryView = new BatteryView();
	var stepsView = new StepsView();
	var notificationView = new NotificationView();
	var timeView = new TimeView();
	
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
	
    //===============================
    //! Update the view
    //===============================
    function onUpdate(dc) {
        // Get the current time and format it correctly

        //var deviceSettings = Sys.getDeviceSettings();

        //var temperature = deviceSettings.temperature;
        //var altitude = deviceSettings.altitude;


        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        // Include anything that needs to be updated here



        //===============================
        //!draw time
        //===============================
        var now = Time.now();
        var time = Gregorian.info(now, Time.FORMAT_LONG);
        timeView.drawTime(dc, time);


        //===============================
        //!binary clock hours
        //===============================
		binaryView.drawBinaryLayout(dc, time);


        //===============================
        //!distance
        //===============================
		stepsView.drawSteps(dc);

		//===============================
		//!Battery
		//===============================
		batteryView.drawItem(dc);

        
        //===============================
        //!calories
        //===============================



        //===============================
        //!alarm
        //===============================
        //var alarm = Sys.getTimer();
        //var alarmCount = deviceSettings.alarmCount;
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
        //var phoneConnected = deviceSettings.phoneConnected;
        //Toybox::System::DeviceSettings
        //phoneConnected


        //===============================
        //!temperature
        //===============================
        //Toybox::System::DeviceSettings
        //temperatureUnits


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
