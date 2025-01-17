using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.ActivityMonitor as ActMon;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Gregorian;
using Toybox.Lang as Lang;
using Toybox.Application as App;
using Toybox.Math as Math;


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
            if (layoutMode == 0)
            {
                Sys.println("Loading Layout: GeekModeLayout");
                setLayout(Rez.Layouts.GeekModeLayout(dc));
            }
            else if (layoutMode == 1)
            {
                Sys.println("Loading Layout: VerticalLayout");
                setLayout(Rez.Layouts.VerticalLayout(dc));
            }
            else if (layoutMode == 2)
            {
                Sys.println("Loading Layout: HorizontalLayout");
                setLayout(Rez.Layouts.HorizontalLayout(dc));                
            }
            else if (layoutMode == 3)
            {
                Sys.println("Loading Layout: NormalModeLayout");
                setLayout(Rez.Layouts.NormalModeLayout(dc));     
            }
            else if (layoutMode == 4)
            {
                Sys.println("Loading Layout: NormalModeLayout2");
                setLayout(Rez.Layouts.NormalModeLayout2(dc));     
            }
            else if (layoutMode == 5)
            {
                Sys.println("Loading Layout: Fenix6Layout");
                setLayout(Rez.Layouts.Fenix6Layout(dc));   
            }      
            else if (layoutMode == 6)
            {
                // ForeRunner 735XT
                Sys.println("Loading Layout: NormalModeLayoutFR735");
                setLayout(Rez.Layouts.NormalModeLayoutFR735(dc));
            }             
            else
            {
                Sys.println("!!Could not find correct value for LayoutType, fallback to NormalModeLayout2!!");
                setLayout(Rez.Layouts.NormalModeLayout2(dc));                     
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
