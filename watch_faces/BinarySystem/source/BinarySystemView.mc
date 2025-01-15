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

    var isDirty = false;
    var isLowPowerMode = false;

    function initialize() {
        WatchFace.initialize();
        AppStorage.setApp(Application.getApp());
    }

    //! Load your resources here
    function onLayout(dc) {
        
        var layoutMode = AppStorage.getProperty("LayoutType");
        {
        	if (dc.getHeight() >= 260)
        	{
        		Sys.println("Fenix 6 detected");
        		setLayout(Rez.Layouts.Fenix6Layout(dc));
        	}
            // this is a round watchface... HACK
            else if (dc.getHeight() > 200)
            {
            	Sys.println("Fenix 3 detected");
            	if (layoutMode == 0)
            	{
		            setLayout(Rez.Layouts.GeekModeLayout(dc));
                }
                else if (layoutMode == 1)
                {
		            setLayout(Rez.Layouts.VerticalLayout(dc));
                }
                else if (layoutMode == 2)
                {
		            setLayout(Rez.Layouts.HorizontalLayout(dc));                
                }
                else if (layoutMode == 3)
                {
		            setLayout(Rez.Layouts.NormalModeLayout(dc));     
                }
                else if (layoutMode == 4)
                {
		            setLayout(Rez.Layouts.NormalModeLayout2(dc));     
                }
                else
                {
                	Sys.println("!!Could not find correct value for LayoutType, fallback to default!!");
		            setLayout(Rez.Layouts.NormalModeLayout2(dc));                     
                }
            }
            
            else
            {
                // ForeRunner 735XT
                setLayout(Rez.Layouts.NormalModeLayoutFR735(dc));
            }
        }
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
        if (isDirty)
        {
            onLayout(dc);
            isDirty = false;
        }
        View.onUpdate(dc);

    }



    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    }

    //! The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
        isLowPowerMode = false;
    }

    //! Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
        isLowPowerMode = true;
        Ui.requestUpdate();
    }

    function onSettingsChanged() {
        isDirty = true;
    }

}
