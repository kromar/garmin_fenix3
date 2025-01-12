using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.ActivityMonitor as ActMon;
using Toybox.Application as App;

class ActivityView extends BinaryWatchDrawable
{
    var stepsXOffset = 0;
    var stepsYOffset = 0;
    var showDistance = true;
    var distanceStr = 0;
    var distanceXOffset = 0;
    var distanceYOffset = 0;

    function initialize(params)
    {
        BinaryWatchDrawable.initialize(params);
        locX = params.get(:x);
        locY = params.get(:y);
        stepsXOffset = params.get(:stepsXOffset);
        stepsYOffset = params.get(:stepsYOffset);

        distanceXOffset = params.get(:distanceXOffset);
        distanceYOffset = params.get(:distanceYOffset);
    }


    function draw(dc)
    {
        var showDistance = Application.Properties.getValue("showDistance");
        var deviceSettings = Sys.getDeviceSettings();
        // check Activity Tracking active
        var activity = deviceSettings.activityTrackingOn;
        if (activity == true)
        {
            //System.println("activityTrackingOn: " + activity);
            var dot_color = Application.Properties.getValue("ForegroundColor");
            var bg_transp = Gfx.COLOR_TRANSPARENT;
            var fg_color = Gfx.COLOR_WHITE;
            var activityInfo = ActMon.getInfo();
            var stepGoal = activityInfo.stepGoal;
            var steps = activityInfo.steps;
            var distance = activityInfo.distance;
            // the units are either UNIT_METRIC or UNIT_STATUTE
            var distUnits = Sys.getDeviceSettings().distanceUnits;

            //===============================
            //!steps
            //===============================
            var stepsStr = steps.toString();
            dc.setColor(dot_color, bg_transp);
            dc.drawText((locX + stepsXOffset) * scaleFactorX, (locY + stepsYOffset) * scaleFactorY, Gfx.FONT_TINY, stepsStr, Gfx.TEXT_JUSTIFY_RIGHT);

            //draw step goal bar
            var stepBarWidth = self.screenWidth / 2;
            var stepGoalPercentage = steps.toFloat() / stepGoal.toFloat();
            if (steps > stepGoal)
            {
                stepGoalPercentage = 1.0;
            }
            var borderOffset_Goal = 30;

            dc.setColor(fg_color, bg_transp);
            dc.drawLine((locX - stepBarWidth / 2)* scaleFactorX, (locY-5) * scaleFactorY, (locX + stepBarWidth / 2) * scaleFactorX, (locY -5) * scaleFactorY);

            dc.setColor(dot_color, bg_transp);
            dc.fillRectangle(locX , locY - 10, 2, 5);

            if (stepGoalPercentage <= stepBarWidth and stepGoalPercentage >=0)
            {
                dc.drawLine((locX - stepBarWidth / 2) * scaleFactorX, (locY-5) * scaleFactorY, (locX - (stepBarWidth ) / 2 + stepBarWidth * stepGoalPercentage) * scaleFactorX , (locY-5) * scaleFactorY);
            }
            else
            {
                dc.drawLine(borderOffset_Goal * scaleFactorX, (locY-5) * scaleFactorX, (stepBarWidth) * scaleFactorX, (locY-5) * scaleFactorY);
            }

            //===============================
            //!distance
            //===============================

            if (showDistance)
            {
                dc.setColor(dot_color, bg_transp);
                var distanceStr = "";
                if (distUnits == Sys.UNIT_METRIC)
                {
                    if (distance >= 100000) {
                       distanceStr = (distance * 0.01 * 0.001).format("%.2f") + "km";
                    }
                    else
                    {
                        distanceStr = (distance * 0.01).toLong() + "m" ;
                    }
                }
                else
                {
                    var feetDistance = distance * 0.0328084;
                    if (feetDistance >= 5280)
                    {
                        distanceStr = (feetDistance / 5280.0).format("%.2f") + "mi";
                    }
                    else
                    {
                        distanceStr = (feetDistance).toLong() + "ft";
                    }
                }
                dc.drawText((locX+distanceXOffset) * scaleFactorX, (locY+distanceYOffset) * scaleFactorY, Gfx.FONT_TINY, distanceStr, Gfx.TEXT_JUSTIFY_RIGHT);
            }
        }
    }
}

