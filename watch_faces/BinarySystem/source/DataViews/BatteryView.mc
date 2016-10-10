using Toybox.System as System;
using Toybox.Application as App;
using Toybox.Graphics as Gfx;
using Toybox.WatchUi as Ui;

class BatteryView extends Ui.Drawable
{
	function initialize(params)
	{
		Drawable.initialize(params);
		
		var x = params.get(:x);
        var y = params.get(:y);
		Ui.Drawable.setLocation(x, y);
	} 


	var batHist = {};
	var batHistCount = 0;

	var timeInterval = 0;
	var remainingBattery;
	
    function drawBatteryBars(dc, battery) 
	{
        var width = dc.getWidth();
    	var height = dc.getHeight();
    	var fontHeight = 12;
    	
        var batteryBarWidth = width/2-fontHeight;
        var batteryBar = batteryBarWidth / 100.0f * battery;
        var borderOffset_Battery = 6;

		 //draw battery bar vertical lines
		 if (battery > 99){
        	dc.fillRectangle(batteryBarWidth-2, height/2-28, 2, 8);
        }
        if (battery >= 75) { 
        	dc.drawLine(batteryBarWidth*0.75, height/2-20, batteryBarWidth*0.75, height/2-25);
        }
        if (battery >= 50) {
        	dc.drawLine(batteryBarWidth*0.5, height/2-20, batteryBarWidth*0.5, height/2-28);
        }
        if (battery >= 25) {
        dc.drawLine(batteryBarWidth*0.25, height/2-20, batteryBarWidth*0.25, height/2-25);
        }
        dc.fillRectangle(borderOffset_Battery, height/2-25, 1, 5);
        
        // This is the bottom bar of the Battery
        dc.fillRectangle(borderOffset_Battery, height/2-20, batteryBar-borderOffset_Battery, 2);
    }
                
                
    function drawBatteryBar(dc)
    {
        var sysStats = System.getSystemStats();
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
        var sysStats = System.getSystemStats();
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
            dc.drawText(locX, locY, Gfx.FONT_TINY, batteryPercentageStr, Gfx.TEXT_JUSTIFY_LEFT);
    }
    
    function draw(dc)
    {
    	//drawBatteryBar(dc);
    	drawBatteryPercentage(dc);
    }
}
