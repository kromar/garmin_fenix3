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
    var activityBarThickness = 4;

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
        var showDistance = AppStorage.getProperty("showDistance");
        var deviceSettings = Sys.getDeviceSettings();
        // check Activity Tracking active
        var activity = deviceSettings.activityTrackingOn;
        if (activity == true)
        {
            //System.println("activityTrackingOn: " + activity);
            var dot_color = AppStorage.getProperty("ForegroundColor");
            var bg_transp = Gfx.COLOR_TRANSPARENT;
            var fg_color = Gfx.COLOR_WHITE;
            var activityInfo = ActMon.getInfo();
            var stepGoal = activityInfo.stepGoal;
            var steps = activityInfo.steps;
            var distance = activityInfo.distance;
            // the units are either UNIT_METRIC or UNIT_STATUTE
            var distUnits = Sys.getDeviceSettings().distanceUnits;

           
            //draw step goal bar
            var activityBarWidth = self.screenWidth * 0.6;
            var activityBarLocX = self.screenWidth / 2; // center the activity bar   
            var activityBarLocY = self.screenHeight * 0.2;    
            System.println("activityBarWidth: " + activityBarWidth);
            System.println("activityBarLocX: " + activityBarLocX);
            System.println("activityBarLocY: " + activityBarLocY);

            var stepGoalPercentage = steps.toFloat() / stepGoal.toFloat();
            if (steps > stepGoal)
            {
                stepGoalPercentage = 1.0;
            }

            // draw the step goal bar background
            dc.setColor(fg_color, bg_transp);
            dc.fillRectangle(activityBarLocX - activityBarWidth / 2, self.screenHeight - activityBarLocY, activityBarWidth, activityBarThickness);
            
            // draw the step goal bar
            dc.setColor(dot_color, bg_transp);
            dc.fillRectangle(activityBarLocX , self.screenHeight - activityBarLocY , 2, activityBarThickness);

            if (stepGoalPercentage <= activityBarWidth and stepGoalPercentage >=0)
            {
                dc.fillRectangle((activityBarLocX - activityBarWidth / 2), self.screenHeight - activityBarLocY , activityBarWidth * stepGoalPercentage, activityBarThickness);
            }
            else
            {
                dc.fillRectangle((activityBarLocX - activityBarWidth / 2), self.screenHeight - activityBarLocY, activityBarWidth, activityBarThickness);
            }

            
            //===============================
            //!steps
            //===============================
            var stepsStr = steps.toString();
            System.println("stepsStr: " + stepsStr);
            // draw the steps text
            dc.setColor(dot_color, bg_transp);
            dc.drawText(activityBarLocX - activityBarWidth / 2, (self.screenHeight - activityBarLocY + stepsYOffset), Gfx.FONT_TINY, stepsStr, Gfx.TEXT_JUSTIFY_LEFT);


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
                System.println("distanceStr: " + distanceStr);
                // draw the distance text
                dc.drawText((activityBarLocX + activityBarWidth / 2), (self.screenHeight - activityBarLocY + distanceYOffset), Gfx.FONT_TINY, distanceStr, Gfx.TEXT_JUSTIFY_RIGHT);
            }
        }
    }
}

