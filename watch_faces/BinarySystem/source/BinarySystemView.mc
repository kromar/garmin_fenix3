using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.ActivityMonitor as ActMon;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Gregorian;
using Toybox.Lang as Lang;
using Toybox.Application as App;


var batHist = {};
var batHistCount = 0;
var timeInterval = 0;
var remainingBattery;


//!sunrise/sunset
//https://github.com/anderssonfilip/SunriseSunset


class BinarySystemView extends Ui.WatchFace {

    function initialize() {
        WatchFace.initialize();
        //BAT_graph = new LineGraph( 20, 1, Gfx.COLOR_RED );
        //string_BAT = "--%";
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
    //! draw binary layout
    //===============================
    function drawBinaryLayout(dc,h,w,hours,minutes,seconds, geekMode) {
        //Sys.println("drawing binary");

        var r = 9; //keep this a uneven number for better circle
        var r1 = 1;
        var r2 = 2;
        var lines = 3;
        var rows = 6;
        var b = 51;

        var x = w/2+r+r2;
        var o = 8;
        var y = (h-2*b)/(rows-1)+1;
        var ox = o + 2*(r+r2);

        var color_rgb = App.getApp().getProperty("ForegroundColor");
        var color_bg = Gfx.COLOR_BLACK;
        var color_fg = Gfx.COLOR_WHITE;
        var color_a = Gfx.COLOR_TRANSPARENT;

        var activeSeconds = feedingTime(seconds, true);
        var activeMinutes = feedingTime(minutes, true);
        var activeHours = feedingTime(hours, false);

        if (geekMode) {

            x = w/2 - ox;
        }
        else {

            x = w/2+r+r2;


            }
         for (var iL=0; iL<lines; iL++) {
            for (var iR=0; iR<rows; iR++) {
                //draw circles
                dc.setColor(color_fg, color_bg);
                    dc.fillCircle(x+iL*ox, h-iR*y-b, r+r2);
                dc.setColor(color_bg, color_bg);
                    dc.fillCircle(x+iL*ox, h-iR*y-b, r+r1);
                //seconds
                if (activeSeconds[rows-iR-1] == true and iL == 2) {
                    dc.setColor(color_rgb, color_bg);
                        dc.fillCircle(x+iL*ox, h-iR*y-b, r);
                }
                //minutes
                else if (activeMinutes[rows-iR-1] == true and iL == 1) {
                    dc.setColor(color_rgb, color_bg);
                        dc.fillCircle(x+iL*ox, h-iR*y-b, r);
                }
                //hours
                else if (activeHours[rows-iR-1] == true and iL == 0) {
                    dc.setColor(color_rgb, color_bg);
                        dc.fillCircle(x+iL*ox, h-iR*y-b, r);
                }
                else {
                    dc.setColor(color_bg, color_bg);
                        dc.fillCircle(x+iL*ox, h-iR*y-b, r);
                }
            }
        }

        //===============================
        //!debug objects
        //===============================
        //dc.setColor(Gfx.COLOR_YELLOW, color_a);
        //dc.drawLine(b, b, w-b, b);

        //dc.drawLine(w/2, 0, w/2, h);
        //dc.drawLine(0, h/2, w, h/2);
    }


    //===============================
    //!feed time to binary processing
    //===============================
    function feedingTime(time, maxConvertion) {
        var input = [32,16,8,4,2,1];
        var output = {};
        var size = input.size();
        //Sys.println("start time: " + time);

        //convert time to 60 if 0
        if (maxConvertion and time == 0){
            time = 60;
        }

        for (var i=0; i<size; i++) {
            if (time/input[i] >= 1) {
                output[i]= true;
                time -= input[i];
            } else {
                output[i] = false;
            }
        }
        //Sys.println(output);
        //Sys.println("-----------------------------");
        return output;
    }

    //===============================
    //!battery prediction
    //===============================
    function batteryPrediction(input, battery, divider) {
        //remember battery percentage and do a prediction how long the battery will last
        var timeDiff = 1;
        if (timeInterval != input) {
            if (input-timeInterval > 1) {
                timeDiff = input-timeInterval;
            }
            timeInterval = input;
            if (batHistCount == 0) {
                batHist[0] = battery;
                batHist[1] = battery;
                batHistCount = 1;
            } else {
                batHist[0] = batHist[1];
                batHist[1] = battery;
            }

            Sys.println(batHistCount);
            Sys.println(batHist);

            if (batHist[0] > batHist[1])  {
                var batLoss = batHist[0]-batHist[1];
                remainingBattery = battery / batLoss / divider / timeDiff ; //batRemaining is is a global var
                Sys.println("rem: " + remainingBattery);
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
        var distance = activityInfo.distance;
        var steps = activityInfo.steps;
        var stepGoal = activityInfo.stepGoal;
        var calories = activityInfo.calories;

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
            dc.setColor(dot_color, bg_transp);
            dc.drawText(width/2, height-20-fontHeight, Gfx.FONT_TINY, batteryPercentageStr, Gfx.TEXT_JUSTIFY_CENTER);

        }
        else {
            //===============================
            //!battery bar
            //===============================
            var batteryBarWidth = width/2-fontHeight;
            var batteryBar = batteryBarWidth / 100.0f * battery;
            var borderOffset_Battery = 6;


            //draw batterybar background
            dc.setColor(fg_color, bg_transp);
            dc.fillRectangle(borderOffset_Battery, height/2-20, batteryBarWidth-borderOffset_Battery, 2);

            //color vertical lines depending on percentage
            if (battery == 100) {
                dc.setColor(dot_color, bg_transp);
                //draw battery bar vertical lines
                dc.fillRectangle(batteryBarWidth-2, height/2-28, 2, 8);
                dc.drawLine(batteryBarWidth*0.75, height/2-20, batteryBarWidth*0.75, height/2-25);
                dc.drawLine(batteryBarWidth*0.5, height/2-20, batteryBarWidth*0.5, height/2-28);
                dc.drawLine(batteryBarWidth*0.25, height/2-20, batteryBarWidth*0.25, height/2-25);
                dc.fillRectangle(borderOffset_Battery, height/2-25, 1, 5);
            }
            else if (battery < 100 and battery >= 75) {
                //draw battery bar vertical lines
                dc.setColor(fg_color, bg_transp);
                dc.fillRectangle(batteryBarWidth-2, height/2-28, 2, 8);
                dc.setColor(dot_color, bg_transp);
                dc.drawLine(batteryBarWidth*0.75, height/2-20, batteryBarWidth*0.75, height/2-25);
                dc.drawLine(batteryBarWidth*0.5, height/2-20, batteryBarWidth*0.5, height/2-28);
                dc.drawLine(batteryBarWidth*0.25, height/2-20, batteryBarWidth*0.25, height/2-25);
                dc.fillRectangle(borderOffset_Battery, height/2-25, 1, 5);
            }
            else if (battery < 75 and battery >= 50) {
                //draw battery bar vertical lines
                dc.setColor(fg_color, bg_transp);
                dc.fillRectangle(batteryBarWidth-2, height/2-28, 2, 8);
                dc.drawLine(batteryBarWidth*0.75, height/2-20, batteryBarWidth*0.75, height/2-25);
                dc.setColor(dot_color, bg_transp);
                dc.drawLine(batteryBarWidth*0.5, height/2-20, batteryBarWidth*0.5, height/2-28);
                dc.drawLine(batteryBarWidth*0.25, height/2-20, batteryBarWidth*0.25, height/2-25);
                dc.fillRectangle(borderOffset_Battery, height/2-25, 1, 5);
            }
            else if (battery < 50 and battery >= 25) {
                //draw battery bar vertical lines
                dc.setColor(fg_color, bg_transp);
                dc.fillRectangle(batteryBarWidth-2, height/2-28, 2, 8);
                dc.drawLine(batteryBarWidth*0.75, height/2-20, batteryBarWidth*0.75, height/2-25);
                dc.drawLine(batteryBarWidth*0.5, height/2-20, batteryBarWidth*0.5, height/2-28);
                dc.setColor(dot_color, bg_transp);
                dc.drawLine(batteryBarWidth*0.25, height/2-20, batteryBarWidth*0.25, height/2-25);
                dc.fillRectangle(borderOffset_Battery, height/2-25, 1, 5);
            }
            else if (battery < 25 and battery > 0) {
                //draw battery bar vertical lines
                dc.setColor(fg_color, bg_transp);
                dc.fillRectangle(batteryBarWidth-2, height/2-28, 2, 8);
                dc.drawLine(batteryBarWidth*0.75, height/2-20, batteryBarWidth*0.75, height/2-25);
                dc.drawLine(batteryBarWidth*0.5, height/2-20, batteryBarWidth*0.5, height/2-28);
                dc.drawLine(batteryBarWidth*0.25, height/2-20, batteryBarWidth*0.25, height/2-25);
                dc.setColor(dot_color, bg_transp);
                dc.fillRectangle(borderOffset_Battery, height/2-25, 1, 5);
            }
            else if (battery  == 0) {
                //draw battery bar vertical lines
                dc.setColor(fg_color, bg_transp);
                dc.fillRectangle(batteryBarWidth-2, height/2-28, 2, 8);
                dc.drawLine(batteryBarWidth*0.75, height/2-20, batteryBarWidth*0.75, height/2-25);
                dc.drawLine(batteryBarWidth*0.5, height/2-20, batteryBarWidth*0.5, height/2-28);
                dc.drawLine(batteryBarWidth*0.25, height/2-20, batteryBarWidth*0.25, height/2-25);
                dc.fillRectangle(borderOffset_Battery, height/2-25, 1, 5);
            }
            //draw battery bar
            dc.setColor(dot_color, bg_transp);
            dc.fillRectangle(borderOffset_Battery, height/2-20, batteryBar-borderOffset_Battery, 2);
            //System.print("battery: ", battery.format("%02d"));



            //===============================
            //!battery percentage
            //===============================
            var batteryPercentageStr = battery.format("%d");
            batteryPrediction(seconds, battery, 24);

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
            dc.setColor(dot_color, bg_transp);
            dc.drawText(92, 62, Gfx.FONT_TINY, batteryPercentageStr, Gfx.TEXT_JUSTIFY_RIGHT);
         }


        //===============================
        //!notifications
        //===============================
        //Toybox::System::DeviceSettings
        //notificationCount
        if (geekMode) {
            if (notificationCount > 0) {
                //draw notification box
                var w = width/2-20;
                var h = 10;
                dc.setColor(fg_color, bg_transp);
                dc.drawRoundedRectangle(w, h, 40, 18, 4);
                dc.drawRectangle(w+2, h+4, 10, 1, 1);
                dc.drawRectangle(w+2, h+8, 16, 1, 1);
                dc.drawRectangle(w+2, h+12, 10, 1, 1);

                //draw notification count
                var notificationCountStr = notificationCount.toString();
                dc.setColor(dot_color, bg_transp);
                dc.drawText(w+36, h-3, Gfx.FONT_TINY, notificationCountStr, Gfx.TEXT_JUSTIFY_RIGHT);
            }
        }
        else{
            if (notificationCount > 0) {
                //draw notification box
                var w = width/2-56;
                var h = height/2-70;
                dc.setColor(fg_color, bg_transp);
                dc.drawRoundedRectangle(w, h, 40, 18, 4);
                dc.drawRectangle(w+2, h+4, 10, 1, 1);
                dc.drawRectangle(w+2, h+8, 16, 1, 1);
                dc.drawRectangle(w+2, h+12, 10, 1, 1);

                //draw notification count
                var notificationCountStr = notificationCount.toString();
                dc.setColor(dot_color, bg_transp);
                dc.drawText(w+36, h-3, Gfx.FONT_TINY, notificationCountStr, Gfx.TEXT_JUSTIFY_RIGHT);
            }
        }


        //===============================
        //!distance
        //===============================
        //Toybox::ActivityMonitor::Info
        //distance
        if (geekMode) {


            dc.setColor(dot_color, bg_transp);
            if (distance < 100000) {
                var distanceStr = (distance*0.01).toLong() + "m";
                dc.drawText(width-10, height/2-fontHeight, Gfx.FONT_TINY, distanceStr, Gfx.TEXT_JUSTIFY_RIGHT);
            } else {
                var distanceStr = (distance*0.01*0.001).format("%.2f") + "km";
                dc.drawText(width-10, height/2-fontHeight, Gfx.FONT_TINY, distanceStr, Gfx.TEXT_JUSTIFY_RIGHT);
            }
        }
        else {

            dc.setColor(dot_color, bg_transp);
            if (distance < 100000) {
                var distanceStr = (distance*0.01).toLong() + "m";
                dc.drawText(96, 156, Gfx.FONT_TINY, distanceStr, Gfx.TEXT_JUSTIFY_RIGHT);
            } else {
                var distanceStr = (distance*0.01*0.001).format("%.2f") + "km";
                dc.drawText(96, 156, Gfx.FONT_TINY, distanceStr, Gfx.TEXT_JUSTIFY_RIGHT);
            }


            //System.println(distanceKM);


            //===============================
            //!steps
            //===============================
            var stepsStr = steps.toString();
            dc.setColor(dot_color, bg_transp);
            dc.drawText(96, 178, Gfx.FONT_TINY, stepsStr, Gfx.TEXT_JUSTIFY_RIGHT);

            //draw step goal bar
            var stepBarWidth = width/2-fontHeight;
            var stepGoalPercentage = stepBarWidth.toFloat()/stepGoal*steps;

            var borderOffset_Goal = 30;

            dc.setColor(fg_color, bg_transp);
            dc.drawLine(borderOffset_Goal, height-40, stepBarWidth, height-40);

            dc.setColor(dot_color, bg_transp);
            dc.fillRectangle(borderOffset_Goal, height-45, 1, 5);

            if (stepGoalPercentage <= stepBarWidth and stepGoalPercentage >=0) {
                dc.drawLine(borderOffset_Goal, height-40, borderOffset_Goal + stepGoalPercentage, height-40);
            }
            else {
                dc.drawLine(borderOffset_Goal, height-40, stepBarWidth, height-40);
            }
            System.println("steps percentage: " + stepGoalPercentage.toString());
        }

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
        drawBinaryLayout(dc, height, width, hours, minutes, seconds, geekMode);

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
