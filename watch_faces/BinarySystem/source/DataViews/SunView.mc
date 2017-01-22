using Toybox.Lang as Lang;
using Toybox.Graphics as Gfx;
using Toybox.Application as App;
using Toybox.Time.Gregorian as Gregorian;
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

            Sys.println("sunview loaded");
        }

    function draw(dc)
    {
        var lat = 0;
        var long = 0;
        var curLoc = Activity.getActivityInfo().currentLocation;
        var dot_color = App.getApp().getProperty("ForegroundColor");
        var bg_transp = Gfx.COLOR_TRANSPARENT;
        dc.setColor(dot_color, bg_transp);

        if (curLoc != null) {
            var sc = new SunCalc();
            lat= curLoc.toRadians()[0].toFloat();
            long = curLoc.toRadians()[1].toFloat();
            Sys.println("lat/long: " + lat + " / " + long);

            var latlon = new [2];
            latlon[0] = lat;
            latlon[1] = long;

            now = new Time.Moment(Time.now().value());

            var sunrise_moment = sc.calculate(now, latlon[0], latlon[1], SUNRISE);
            var sunset_moment = sc.calculate(now, latlon[0], latlon[1], SUNSET);

            var timeInfoSunrise = Calendar.info(sunrise_moment, Time.FORMAT_SHORT);
            var timeInfoSunset = Calendar.info(sunset_moment, Time.FORMAT_SHORT);

            sunInfoString = timeInfoSunrise.hour.format("%01d") + ":" + timeInfoSunrise.min.format("%02d") + " - " + timeInfoSunset.hour.format("%01d") + ":" + timeInfoSunset.min.format("%02d");
            dc.drawText(locX, locY, Gfx.FONT_TINY, sunInfoString, Gfx.TEXT_JUSTIFY_RIGHT);
            Sys.println("sunInfoString: " + sunInfoString);

        } else {
            var sunInfoString = "no gps fix!";
            dc.drawText(locX, locY, Gfx.FONT_TINY, sunInfoString, Gfx.TEXT_JUSTIFY_CENTER);
            Sys.println("sunInfoString: " + sunInfoString);
        }
    }
}