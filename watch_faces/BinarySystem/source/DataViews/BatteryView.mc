using Toybox.System as Sys;
using Toybox.Application as App;
using Toybox.Graphics as Gfx;
using Toybox.WatchUi as Ui;
using Toybox.Math as Math;


class BatteryView extends Ui.Drawable
{
    function initialize(params)
    {
        Drawable.initialize(params);

        var x = params.get(:x);
        var y = params.get(:y);
        showBatteryBar = params.get(:showBatteryBar);

        Ui.Drawable.setLocation(x, y);
    }


    var batHist = {};
    var batHistCount = 0;

    var timeInterval = 0;
    var remainingBattery;
    var showBatteryBar = false;

    function drawBatteryBars(dc, battery)
    {
        // API draw references
            // fillRectangle(x, y, width, height) ⇒ Object
            // drawLine(x1, y1, x2, y2) ⇒ Object
            //  drawArc(x, y, r, attr, degreeStart, degreeEnd) ⇒ Object

        var barHorizontal = true;
        var barLength = 100;
        var barThickness = 2;
        var locX= 109;
        var locY = 50;
        var batteryPercentageBar = Math.round(barLength / 100.0f * battery).toLong();
        var batteryPercentageOffset =(barLength -  batteryPercentageBar);   // this is needed to shift the percentage bar to its correct coordinate


        if (showBatteryBar)
        {
            if (barHorizontal == true) //draw horizontal battery bar
            {
                if (battery > 99){
                    dc.fillRectangle(locX + barLength / 2 - barThickness,  locY - 8, barThickness, 8);
                }
                if (battery >= 75) {
                    dc.drawLine(locX + barLength * 0.25 , locY, locX + barLength * 0.25, locY - 5);
                }
                if (battery >= 50) {
                    dc.drawLine(locX , locY, locX, locY - 8);
                }
                if (battery >= 25) {
                    dc.drawLine(locX - barLength * 0.25 , locY, locX - barLength * 0.25, locY - 5);
                }
                dc.fillRectangle(locX - barLength / 2, locY - 8,  barThickness, 8);   //0% mark
                dc.fillRectangle(locX - barLength / 2, locY, batteryPercentageBar, barThickness);

            } else {     // draw vertical battery bar
                if (battery > 99){
                    dc.fillRectangle(locX - 8,  locY , 8, barThickness);
                }
                if (battery >= 75) {
                    dc.drawLine(locX - 5, locY  + barLength * 0.25, locX,  locY+ barLength * 0.25);
                }
                if (battery >= 50) {
                    dc.drawLine(locX - 8, locY  + barLength * 0.5, locX,  locY+ barLength * 0.5);
                }
                if (battery >= 25) {
                    dc.drawLine(locX - 5, locY  + barLength * 0.75, locX,  locY+ barLength * 0.75);
                }
                dc.fillRectangle(locX - 8, locY + barLength - barThickness, 8, barThickness);     //0% mark
                dc.fillRectangle(locX,  locY + batteryPercentageOffset , barThickness, batteryPercentageBar);
            }
        }
    }


    function drawBatteryBar(dc)
    {
        var sysStats = Sys.getSystemStats();
        var battery = sysStats.battery;

        var width = dc.getWidth();
        var height = dc.getHeight();

        var dot_color = App.getApp().getProperty("ForegroundColor");
        var bg_color = Gfx.COLOR_BLACK;
        var fg_color = Gfx.COLOR_WHITE;
        var bg_transp = Gfx.COLOR_TRANSPARENT;
        var fontHeight = 12;

        //===============================
        //!battery bar
        //===============================
        var batteryBarWidth = width/2-Gfx.FONT_TINY;
        var batteryBar = batteryBarWidth / 100.0f * battery;
        var borderOffset_Battery = 6;


        //draw batterybar background
        //dc.setColor(fg_color, bg_transp);
        //dc.fillRectangle(borderOffset_Battery, height/2-20, batteryBarWidth-borderOffset_Battery, 2);

        dc.setColor(fg_color, bg_transp);
        drawBatteryBars(dc, 100);

        dc.setColor(dot_color, bg_transp);
        drawBatteryBars(dc, battery);
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

            //Sys.println(batHistCount);
            //Sys.println(batHist);

            if (batHist[0] > batHist[1])  {
                var batLoss = batHist[0]-batHist[1];
                remainingBattery = battery / batLoss / divider / timeDiff ; //batRemaining is is a global var
                Sys.println("rem: " + remainingBattery);
            }
        }
    }
    function drawBatteryPercentage(dc)
    {
        var remainingBatteryEstimateMode = App.getApp().getProperty("RemainingBatteryEstimate");
        var sysStats = Sys.getSystemStats();
        var battery = sysStats.battery;
            //===============================
            //!battery percentage
            //===============================
            var batteryPercentageStr = battery.format("%d");
            //batteryPrediction(seconds, battery, 24);

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
            var dot_color = App.getApp().getProperty("ForegroundColor");
            var bg_transp = Gfx.COLOR_TRANSPARENT;
            dc.setColor(dot_color, bg_transp);
            dc.drawText(locX, locY, Gfx.FONT_TINY, batteryPercentageStr, Gfx.TEXT_JUSTIFY_CENTER);
    }

    function draw(dc)
    {
        drawBatteryBar(dc);
        drawBatteryPercentage(dc);
    }
}
