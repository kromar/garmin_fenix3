using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.ActivityMonitor as ActMon;
using Toybox.Application as App;

class StepsView extends DataView
{
	function drawItem(dc)
	{
	   	var dot_color = App.getApp().getProperty("ForegroundColor");
        var bg_transp = Gfx.COLOR_TRANSPARENT;
        var fg_color = Gfx.COLOR_WHITE;
        
	    var fontHeight = 12;
	    var width = dc.getWidth();
        var height = dc.getHeight();
	
		var activityInfo = ActMon.getInfo();
		var stepGoal = activityInfo.stepGoal;
		var steps = activityInfo.steps;
        var distance = activityInfo.distance;
        var calories = activityInfo.calories;
		
        //===============================
        //!steps
        //===============================
        var stepsStr = steps.toString();
        dc.setColor(dot_color, bg_transp);
        dc.drawText(dc.getWidth() / 2.0, height-35, Gfx.FONT_TINY, stepsStr, Gfx.TEXT_JUSTIFY_CENTER);
		
		//draw step goal bar
        var stepBarWidth = dc.getWidth()/2-fontHeight;
        var stepGoalPercentage = stepBarWidth.toFloat()/stepGoal*steps;

        var borderOffset_Goal = 30;

        dc.setColor(fg_color, bg_transp);
        dc.drawLine((width - stepBarWidth) / 2, height-40, (width + stepBarWidth) / 2, height-40);

        dc.setColor(dot_color, bg_transp);
        dc.fillRectangle(width / 2, height-45, 1, 5);

        if (stepGoalPercentage <= stepBarWidth and stepGoalPercentage >=0) 
        {
            dc.drawLine((width - stepBarWidth) / 2, height-40, (width - stepBarWidth + stepGoalPercentage) / 2, height-40);
        }
        else 
        {
        	dc.drawLine(borderOffset_Goal, height-40, stepBarWidth, height-40);
        }
        //System.println("steps percentage: " + stepGoalPercentage.toString());
        
        /////////////
        /// STEPS ///
            //dc.setColor(dot_color, bg_transp);
            //if (distance < 100000) {
            //    var distanceStr = (distance*0.01).toLong() + "m";
            //    dc.drawText(96, 156, Gfx.FONT_TINY, distanceStr, Gfx.TEXT_JUSTIFY_RIGHT);
            //} else {
            //    var distanceStr = (distance*0.01*0.001).format("%.2f") + "km";
            //    dc.drawText(96, 156, Gfx.FONT_TINY, distanceStr, Gfx.TEXT_JUSTIFY_RIGHT);
            //}
	}
}