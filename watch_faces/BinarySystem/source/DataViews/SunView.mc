using Toybox.Graphics as Gfx;
using Toybox.Application as App;
using Toybox.Time as Time;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Activity as Activity;

class SunView extends Ui.Drawable
{
    var showSun = false;
    var image = null;
    function initialize(params)
        {
            Drawable.initialize(params);
            var x = params.get(:x);
            var y = params.get(:y);
            showSun = params.get(:showSun);
            Ui.Drawable.setLocation(x, y);
            image = Ui.loadResource( Rez.Drawables.nogps_icon );
            
            // references
                //https://forums.garmin.com/showthread.php?351367-Sun-rise-sunset/page2
                // https://github.com/haraldh/SunCalc
                //http://lexikon.astronomie.info/zeitgleichung/
        }

    function draw(dc)
    {
        var showSun = App.getApp().getProperty("ShowSun");
        if (showSun)
        {
	        var curLoc = Activity.getActivityInfo().currentLocation;
	        var dot_color = App.getApp().getProperty("ForegroundColor");
	        var bg_transp = Gfx.COLOR_TRANSPARENT;
	        dc.setColor(dot_color, bg_transp);
	        var sc = new SunCalc();
	
	        if (curLoc != null) {
	            //Sys.println("curLoc" + curLoc);
	            
	            var latlon = curLoc.toRadians();
	            //Sys.println("latlon" + latlon);
	            
	            var now = new Time.Moment(Time.now().value());
	            //Sys.println("now: " + now);
	            
	            var sunrise_moment = sc.calculate(now, latlon[0], latlon[1], SUNRISE);
	            var sunset_moment = sc.calculate(now, latlon[0], latlon[1], SUNSET);
	
	            var timeInfoSunrise = Time.Gregorian.info(sunrise_moment, Time.FORMAT_SHORT);
	            var timeInfoSunset = Time.Gregorian.info(sunset_moment, Time.FORMAT_SHORT);
	            
	            var sunInfoString = timeInfoSunrise.hour.format("%01d") + ":" + timeInfoSunrise.min.format("%02d") + " - " + timeInfoSunset.hour.format("%01d") + ":" + timeInfoSunset.min.format("%02d");
	            //Sys.println("sunInfoString: " + sunInfoString);
	            dc.drawText(locX, locY, Gfx.FONT_TINY, sunInfoString, Gfx.TEXT_JUSTIFY_CENTER);
	
	        } else {
                dc.drawBitmap(locX-9, locY, image);
	        }
        }
    }
}
