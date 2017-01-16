using Toybox.Graphics as Gfx;
using Toybox.ActivityMonitor as ActMon;
using Toybox.Application as App;
using Toybox.WatchUi as Ui;

class DistanceView extends Ui.Drawable
{
    var showDistance = true;
    var metricUnits = true;   //switch between metric and imperial true=metric / false=imperial

    function initialize(params)
         {
            Ui.Drawable.initialize(params);

            locX = params.get(:x);
            locY = params.get(:y);
            showDistance = params.get(:showDistance);
            metricUnits =  params.get(:metricUnits);

        }

    function draw(dc)
    {
        if (showDistance)
        {
            var dot_color = App.getApp().getProperty("ForegroundColor");
            var bg_transp = Gfx.COLOR_TRANSPARENT;
            var fg_color = Gfx.COLOR_WHITE;
            var fontHeight = 12;
            var activityInfo = ActMon.getInfo();
            var distance = activityInfo.distance;

            dc.setColor(dot_color, bg_transp);
            if (distance < 100000) {
                if (metricUnits == true)
                {
                     var distanceStr = (distance*0.01).toLong() + "m";
                    dc.drawText(locX, locY, Gfx.FONT_TINY, distanceStr, Gfx.TEXT_JUSTIFY_RIGHT);
                } else {
                     var distanceStr = (distance*0.0328).toLong() + "ft";
                    dc.drawText(locX, locY, Gfx.FONT_TINY, distanceStr, Gfx.TEXT_JUSTIFY_RIGHT);
                }
            } else {
                if (metricUnits == true)
                {
                    var distanceStr = (distance*0.01*0.001).format("%.2f") + "km";
                    dc.drawText(locX, locY, Gfx.FONT_TINY, distanceStr, Gfx.TEXT_JUSTIFY_RIGHT);
                } else {
                    var distanceStr = (distance*0.01*0.001*0.621).format("%.2f") + "mi";
                    dc.drawText(locX, locY, Gfx.FONT_TINY, distanceStr, Gfx.TEXT_JUSTIFY_RIGHT);
                }
            }

                //System.println(distanceKM);
            }
        }
}
