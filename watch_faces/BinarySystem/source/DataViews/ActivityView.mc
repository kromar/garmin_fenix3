using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.ActivityMonitor as ActMon;
using Toybox.Application as App;
using Toybox.WatchUi as Ui;

class ActivityView extends Ui.Drawable
{
    var stepsXOffset = 0;
    var stepsYOffset = 0;
    var showDistance = true;
    var distanceStr = 0;
    var distanceXOffset = 0;
    var distanceYOffset = 0;

    function initialize(params)
    {
        Drawable.initialize(params);
        locX = params.get(:x);
        locY = params.get(:y);
        stepsXOffset = params.get(:stepsXOffset);
        stepsYOffset = params.get(:stepsYOffset);

        distanceXOffset = params.get(:distanceXOffset);
        distanceYOffset = params.get(:distanceYOffset);
        showDistance = params.get(:showDistance);
    }


    function draw(dc)
    {
        var deviceSettings = Sys.getDeviceSettings();
        // check Activity Tracking active
        var activity = deviceSettings.activityTrackingOn;
        if (activity == true)
        {
            //System.println("activityTrackingOn: " + activity);
            var dot_color = App.getApp().getProperty("ForegroundColor");
            var bg_transp = Gfx.COLOR_TRANSPARENT;
            var fg_color = Gfx.COLOR_WHITE;
            var fontHeight = 12;
            var activityInfo = ActMon.getInfo();
            var stepGoal = activityInfo.stepGoal;
            var steps = activityInfo.steps;
            var calories = activityInfo.calories;
            var distance = activityInfo.distance;
            // the units are either UNIT_METRIC or UNIT_STATUTE
            var distUnits = Sys.getDeviceSettings().distanceUnits;
            Sys.println("Units: " + distUnits);

            //===============================
            //!steps
            //===============================
            var stepsStr = steps.toString();
            dc.setColor(dot_color, bg_transp);
            dc.drawText((locX + stepsXOffset), (locY + stepsYOffset), Gfx.FONT_TINY, stepsStr, Gfx.TEXT_JUSTIFY_RIGHT);

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



            //===============================
            //!distance
            //===============================

            if (showDistance)
            {
                dc.setColor(dot_color, bg_transp);
                if (distance < 100000) {        //TODO: here we switch between meters and kilometers so we need the same for feet and miles
                    if (distUnits == Sys.UNIT_METRIC)
                    {
                         var distanceStr = (distance*0.01).toLong() + "m";
                        dc.drawText(locX+distanceXOffset, locY+distanceYOffset, Gfx.FONT_TINY, distanceStr, Gfx.TEXT_JUSTIFY_RIGHT);
                    } else {
                         var distanceStr = (distance*0.0328).toLong() + "ft";
                        dc.drawText(locX+distanceXOffset, locY+distanceYOffset, Gfx.FONT_TINY, distanceStr, Gfx.TEXT_JUSTIFY_RIGHT);
                    }
                } else {
                    if (distUnits == Sys.UNIT_METRIC)
                    {
                        var distanceStr = (distance*0.01*0.001).format("%.2f") + "km";
                        dc.drawText(locX+distanceXOffset, locY+distanceYOffset, Gfx.FONT_TINY, distanceStr, Gfx.TEXT_JUSTIFY_RIGHT);
                    } else {
                        var distanceStr = (distance*0.01*0.001*0.621).format("%.2f") + "mi";
                        dc.drawText(locX+distanceXOffset, locY+distanceYOffset, Gfx.FONT_TINY, distanceStr, Gfx.TEXT_JUSTIFY_RIGHT);
                    }
                }
                //System.println(distanceKM);
            }
        }
    }
}

