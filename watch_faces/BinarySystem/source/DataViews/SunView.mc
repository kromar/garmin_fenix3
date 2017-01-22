using Toybox.Graphics as Gfx;
using Toybox.Application as App;
using Toybox.Time as Time;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Activity as Activity;


class SunView extends Ui.Drawable
{
    function initialize(params)
        {
            Drawable.initialize(params);
            var x = params.get(:x);
            var y = params.get(:y);
            Ui.Drawable.setLocation(x, y);

            // https://github.com/haraldh/SunCalc
            var sc = new SunCalc();
        }

    function draw(dc)
    {
        var curLoc = Activity.getActivityInfo().currentLocation;
        var dot_color = App.getApp().getProperty("ForegroundColor");
        var bg_transp = Gfx.COLOR_TRANSPARENT;
        dc.setColor(dot_color, bg_transp);

        if (curLoc != null) {
            Sys.println(curLoc);
            var latlon = loc.toRadians();
            var now = new Time.Moment(Time.now().value());

            var sunrise_moment = sc.calculate(now, latlon[0], latlon[1], SUNRISE);
            var sunset_moment = sc.calculate(now, latlon[0], latlon[1], SUNSET);

            var timeInfoSunrise = Greg.info(sunrise_moment, Time.FORMAT_SHORT);
            var timeInfoSunset = Greg.info(sunset_moment, Time.FORMAT_SHORT);

            sunInfoString = timeInfoSunrise.hour.format("%01d") + ":" + timeInfoSunrise.min.format("%02d") + " - " + timeInfoSunset.hour.format("%01d") + ":" + timeInfoSunset.min.format("%02d");
            Sys.println("sunInfoString: " + sunInfoString);

        } else {
            var sunInfoString = "no gps fix!";
            dc.drawText(locX, locY, Gfx.FONT_TINY, sunInfoString, Gfx.TEXT_JUSTIFY_CENTER);
            Sys.println("sunInfoString: " + sunInfoString);
        }
    }
}