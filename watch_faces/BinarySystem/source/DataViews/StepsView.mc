using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.ActivityMonitor as ActMon;
using Toybox.Application as App;
using Toybox.WatchUi as Ui;

class StepsView extends Ui.Drawable
{
	function initialize(params)
	{
		Drawable.initialize(params);
		locX = params.get(:x);
		locY = params.get(:y);
		
		
	}
	function draw(dc)
	{
	   	var dot_color = App.getApp().getProperty("ForegroundColor");
        var bg_transp = Gfx.COLOR_TRANSPARENT;
        var fg_color = Gfx.COLOR_WHITE;
        
	    var fontHeight = 12;
	
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
        dc.drawText(locX, locY, Gfx.FONT_TINY, stepsStr, Gfx.TEXT_JUSTIFY_CENTER);
		
		//draw step goal bar
        var stepBarWidth = dc.getWidth()/2-fontHeight;
        var stepGoalPercentage = stepBarWidth.toFloat()/stepGoal*steps;

        var borderOffset_Goal = 30;

        dc.setColor(fg_color, bg_transp);
        dc.drawLine(locX - stepBarWidth / 2, locY-5, locX + stepBarWidth / 2, locY -5);

        dc.setColor(dot_color, bg_transp);
        dc.fillRectangle(locX , locY - 10, 1, 5);

        if (stepGoalPercentage <= stepBarWidth and stepGoalPercentage >=0) 
        {
            dc.drawLine((locX - stepBarWidth / 2), locY-5, locX - (stepBarWidth + stepGoalPercentage) / 2 , locY-5);
        }
        else 
        {
        	dc.drawLine(borderOffset_Goal, locY-5, stepBarWidth, locY-5);
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