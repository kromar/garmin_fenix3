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

    //! Load your resources here
    function onLayout(dc) {

        var geekMode = App.getApp().getProperty("GeekMode");
        if (!geekMode)
        {
            if (dc.getHeight() > 200)
            {
                setLayout(Rez.Layouts.NormalModeLayout2(dc));
            }
            else
            {
                // ForeRunner 735XT
                setLayout(Rez.Layouts.NormalModeLayoutFR735(dc));
            }
        }
        else
        {
            setLayout(Rez.Layouts.GeekModeLayout(dc));
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
