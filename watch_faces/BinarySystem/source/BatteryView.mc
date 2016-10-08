using Toybox.System as System;
using Toybox.Application as App;
using Toybox.Graphics as Gfx;

class BatteryView 
{
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
        var batteryBarWidth = width/2-fontHeight;
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
}