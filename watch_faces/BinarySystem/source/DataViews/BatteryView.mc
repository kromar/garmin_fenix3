using Toybox.System as Sys;
using Toybox.Application as App;
using Toybox.Graphics as Gfx;
using Toybox.WatchUi as Ui;
using Toybox.Math as Math;


class BatteryView extends Ui.Drawable
{

    var showBatteryBar = true;
    var showBatteryPercentage = true;
    var batteryBarHorizontal = true;

    var batHist = {};
    var batHistCount = 0;
    var timeInterval = 0;
    var remainingBattery;

    var batteryBarSize = 50;
    var batteryBarThickness = 2;
    var batteryBarLocX= 109;
    var batteryBarLocY = 50;

    var batteryPercentageLocX = 109;
    var batteryPercentageLocY =10;

    var fg_color = Gfx.COLOR_WHITE;
    var bg_transp = Gfx.COLOR_TRANSPARENT;
    var dot_color = Application.Properties.getValue("ForegroundColor");


    function initialize(params)
    {
        Drawable.initialize(params);

        batteryBarHorizontal = params.get(:batteryBarHorizontal);
        batteryBarSize = params.get(:batteryBarSize);
        batteryBarThickness = params.get(:batteryBarThickness);
        batteryBarLocX = params.get(:batteryBarLocX);
        batteryBarLocY = params.get(:batteryBarLocY);
        batteryPercentageLocX = params.get(:batteryPercentageLocX);
        batteryPercentageLocY = params.get(:batteryPercentageLocY);
    }



function draw(dc)
    {


        var showBatteryBar = Application.Properties.getValue("showBatteryBar");
        var showBatteryPercentage = Application.Properties.getValue("showBatteryPercentage");

        if (showBatteryBar)
        {
            drawBatteryBar(dc);
        }
        if (showBatteryPercentage)
        {
            drawBatteryPercentage(dc);
        }
    }


    function drawBatteryBars(dc, battery)
    {
    // API draw references
        // fillRectangle(x, y, width, height) ⇒ Object
        // drawLine(x1, y1, x2, y2) ⇒ Object
        //  drawArc(x, y, r, attr, degreeStart, degreeEnd) ⇒ Object

        var batteryPercentageBar = Math.round(batteryBarSize / 100.0f * battery).toLong();
        var batteryPercentageOffset =(batteryBarSize -  batteryPercentageBar);   // this is needed to shift the percentage bar to its correct coordinate

        if (batteryBarHorizontal == true) //draw horizontal battery bar
        {
            if (battery > 99){
                dc.fillRectangle(batteryBarLocX + batteryBarSize / 2 - batteryBarThickness,  batteryBarLocY - 8, batteryBarThickness, 8);
            }
            if (battery >= 75) {
                dc.drawLine(batteryBarLocX + batteryBarSize * 0.25 , batteryBarLocY, batteryBarLocX + batteryBarSize * 0.25, batteryBarLocY - 5);
            }
            if (battery >= 50) {
                dc.drawLine(batteryBarLocX , batteryBarLocY, batteryBarLocX, batteryBarLocY - 8);
            }
            if (battery >= 25) {
                dc.drawLine(batteryBarLocX - batteryBarSize * 0.25 , batteryBarLocY, batteryBarLocX - batteryBarSize * 0.25, batteryBarLocY - 5);
            }
            dc.fillRectangle(batteryBarLocX - batteryBarSize / 2, batteryBarLocY - 8,  batteryBarThickness, 8);   //0% mark
            dc.fillRectangle(batteryBarLocX - batteryBarSize / 2, batteryBarLocY, batteryPercentageBar, batteryBarThickness);

        } else {     // draw vertical battery bar
            if (battery > 99){
                dc.fillRectangle(batteryBarLocX - 8,  batteryBarLocY , 8, batteryBarThickness);
            }
            if (battery >= 75) {
                dc.drawLine(batteryBarLocX - 5, batteryBarLocY  + batteryBarSize * 0.25, batteryBarLocX,  batteryBarLocY+ batteryBarSize * 0.25);
            }
            if (battery >= 50) {
                dc.drawLine(batteryBarLocX - 8, batteryBarLocY  + batteryBarSize * 0.5, batteryBarLocX,  batteryBarLocY+ batteryBarSize * 0.5);
            }
            if (battery >= 25) {
                dc.drawLine(batteryBarLocX - 5, batteryBarLocY  + batteryBarSize * 0.75, batteryBarLocX,  batteryBarLocY+ batteryBarSize * 0.75);
            }
            dc.fillRectangle(batteryBarLocX - 8, batteryBarLocY + batteryBarSize - batteryBarThickness, 8, batteryBarThickness);     //0% mark
            dc.fillRectangle(batteryBarLocX,  batteryBarLocY + batteryPercentageOffset , batteryBarThickness, batteryPercentageBar);
        }
    }


    function drawBatteryBar(dc)
    {
        var sysStats = Sys.getSystemStats();
        var battery = sysStats.battery;

        //===============================
        //!battery bar
        //===============================
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
        var remainingBatteryEstimateMode = Application.Properties.getValue("RemainingBatteryEstimate");
        var sysStats = Sys.getSystemStats();
        var battery = sysStats.battery;
            //===============================
            //!battery percentage
            //===============================           
            var batteryPercentageStr = Math.round(battery).format("%d");
            //Sys.println("string: "+  batteryPercentageString);
            
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
            var font = Gfx.FONT_TINY;
            dc.setColor(dot_color, bg_transp);
            dc.drawText(batteryBarLocX + batteryPercentageLocX , batteryBarLocY +batteryPercentageLocY, font, batteryPercentageStr, Gfx.TEXT_JUSTIFY_CENTER);
    }


}
