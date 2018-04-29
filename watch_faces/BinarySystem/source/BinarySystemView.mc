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

    function initialize() {
        WatchFace.initialize();
        //App.getApp().setProperty("IsLowPowerMode", false);
    }

    //get screen type so we can scale thee ui depending on screen type, and proportions
    function layoutScaling(dc) {
        // var deviceID = Ant.deviceType;     //requires additional permissions! so lets go with screen size
        var screenShape = Sys.getDeviceSettings().screenShape;
        var width = dc.getWidth();
        var height = dc.getHeight();
        var screenType = null;

       //shapes: https://developer.garmin.com/connect-iq/user-experience-guide/appendices/
       //   1 = circle           //   2 = semi circle           //   3= rect / tall / square

       // identify screen type and proportions
       if (screenShape == 1)
       {
            screenType = "circle";
       }
       else if (screenShape == 2)
       {
            screenType = "semicircle";
       }
       else if (screenShape == 3)
       {
	       if (height > width)
	        {
	           screenType = "tall";
	        }
	        else if (height < width)
	        {
	           screenType = "rect";
           }
            else
            {
                screenType = "square";
            }
	    }

       Sys.println("screenShape: " + screenShape + " width: " +  width + " height: " + height);
       Sys.println("screenType: " + screenType);
    }



    //! Load your resources here
    function onLayout(dc) {
        layoutScaling(dc);
        var layoutMode = App.getApp().getProperty("LayoutType");
        {
            //this is a round watchface... HACK
            if (dc.getHeight() > 200)
            {
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
        App.getApp().setProperty("IsLowPowerMode", false);
    }

    //! Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
        App.getApp().setProperty("IsLowPowerMode", true);
        Ui.requestUpdate();
    }

    function onSettingsChanged() {
        isDirty = true;
    }

}
