using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.ActivityMonitor as ActMon;
using Toybox.Application as App;
using Toybox.WatchUi as Ui;

class StepsView extends Ui.Drawable
{
    var stepsX = 0;
    var stepsY = 0;
    function initialize(params)
    {
        Drawable.initialize(params);
        locX = params.get(:x);
        locY = params.get(:y);
        stepsXOffset = params.get(:stepsX);
        stepsYOffset = params.get(:stepsY);


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
        dc.drawText((locX + stepsX), (locY + stepsY), Gfx.FONT_TINY, stepsStr, Gfx.TEXT_JUSTIFY_RIGHT);

        //draw step goal bar
        var stepBarWidth = dc.getWidth()/2;
        var stepGoalPercentage = steps.toFloat() / stepGoal.toFloat();
        if (steps > stepGoal)
        {
            stepGoalPercentage = 1.0;
        }
        var borderOffset_Goal = 30;

        dc.setColor(fg_color, bg_transp);
        dc.drawLine(locX - stepBarWidth / 2, locY-5, locX + stepBarWidth / 2, locY -5);

        dc.setColor(dot_color, bg_transp);
        dc.fillRectangle(locX , locY - 10, 2, 5);

        if (stepGoalPercentage <= stepBarWidth and stepGoalPercentage >=0)
        {
            dc.drawLine((locX - stepBarWidth / 2), locY-5, locX - (stepBarWidth ) / 2 + stepBarWidth * stepGoalPercentage , locY-5);
        }
        else
        {
            dc.drawLine(borderOffset_Goal, locY-5, stepBarWidth, locY-5);
        }

        // var floorsClimbed = activityInfo.floorsClimbed;
        // meters climbed
        //dc.drawText(locX + stepBarWidth / 2.0+1, locY-5, Gfx.FONT_TINY , floorsClimbed, Gfx.TEXT_JUSTIFY_LEFT);
        //dc.drawText(locX - stepBarWidth / 2.0-1, locY-5, Gfx.FONT_SYSTEM_TINY , activityInfo.floorsDescended.format("%d"), Gfx.TEXT_JUSTIFY_RIGHT | Gfx.TEXT_JUSTIFY_VCENTER );


        // Activity History
        //var heartRateHistory = ActMon.getHeartRateHistory(1, true);
        //var heartRate = heartRateHistory.next().heartRate;
        //dc.drawText(locX, locY - 40, Gfx.FONT_TINY, heartRate + "bpm", Gfx.TEXT_JUSTIFY_CENTER);


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