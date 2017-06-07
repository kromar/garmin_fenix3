using Toybox.Graphics as Gfx;
using Toybox.Application as App;
using Toybox.Time as Time;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Activity as Activity;

class SunView extends Ui.Drawable
{
    var showSun = false;
    var gpsImage = null;
    var latitude = null;
    var longitude = null;
    //var latitude = 50.283333;
    //var longitude = 2.783333; 
    var curLoc = null;
    var hasStoredLocationData = null;
    
    function initialize(params)
        {
            Drawable.initialize(params);
            var x = params.get(:x);
            var y = params.get(:y);
            showSun = params.get(:showSun);
            Ui.Drawable.setLocation(x, y);
            gpsImage = Ui.loadResource(Rez.Drawables.nogps_icon);
            var curLoc = Activity.getActivityInfo().currentLocation;
            Sys.println("curLoc init: " + curLoc);
            
	      
            
            // references
                //https://forums.garmin.com/showthread.php?351367-Sun-rise-sunset/page2
                // https://github.com/haraldh/SunCalc
                //http://lexikon.astronomie.info/zeitgleichung/
        }

    function draw(dc)
    {
        Sys.println("check location: " + Activity.getActivityInfo().currentLocation);
      if (curLoc) //when loc is defined we can write the location to the app properties
            {               
                Sys.println("curloc: " + curLoc);
                var latlon = curLoc.toRadians();
                latitude = latlon[0];
                longitude = latlon[1];
                Application.getApp().setProperty("lastStoredLatitude", latitude);
                Application.getApp().setProperty("lastStoredLongitude", longitude);
                Application.getApp().setProperty("hasStoredLocationData", hasStoredLocationData);
            }
            else //when no location is present
            {
                //check if there is stored location data and load it if available
                hasStoredLocationData = Application.getApp().getProperty("hasStoredLocationData");
                Sys.println("check for stored location data");
                
                if (hasStoredLocationData)
                {
                    Sys.println("stored location date exists");
                    latitude = Application.getApp().getProperty("lastStoredLatitude");
                    longitude = Application.getApp().getProperty("lastStoredLatitude");
                    Sys.println("stored location date exists: " + latitude + longitude);
                }   
                else
                {
                 Sys.println("no stored data and no location");
                 }
            }
            
            
            //================
            
        var showSun = App.getApp().getProperty("ShowSun");
        if (showSun)
        {
	        	        
	        var dot_color = App.getApp().getProperty("ForegroundColor");
	        var bg_transp = Gfx.COLOR_TRANSPARENT;
	        dc.setColor(dot_color, bg_transp);
	        var sc = new SunCalc();
	
            dc.drawText(109, 60,  Gfx.FONT_TINY, "test", Gfx.TEXT_JUSTIFY_CENTER);            
            Sys.println("stored data 2: " + hasStoredLocationData);
            
	        if (hasStoredLocationData) {
          
                Sys.println("stored data found");
	            var now = new Time.Moment(Time.now().value());
	            //Sys.println("now: " + now);
	            
	            var sunrise_moment = sc.calculate(now, latitude, longitude, SUNRISE);
	            var sunset_moment = sc.calculate(now, latitude, longitude, SUNSET);
	
	            var timeInfoSunrise = Time.Gregorian.info(sunrise_moment, Time.FORMAT_SHORT);
	            var timeInfoSunset = Time.Gregorian.info(sunset_moment, Time.FORMAT_SHORT);
	            
	            var sunInfoString = timeInfoSunrise.hour.format("%01d") + ":" + timeInfoSunrise.min.format("%02d") + " - " + timeInfoSunset.hour.format("%01d") + ":" + timeInfoSunset.min.format("%02d");
	            Sys.println("sunInfoString: " + sunInfoString);
	            dc.drawText(locX, locY, Gfx.FONT_TINY, sunInfoString, Gfx.TEXT_JUSTIFY_CENTER);
                dc.drawText(109, 50, Gfx.FONT_TINY, sunInfoString, Gfx.TEXT_JUSTIFY_CENTER);
	            	
	        } else {
	        
                Sys.println("no stored data for drawing");
                //var sunInfoString = Ui.loadResource(Rez.Strings.NO_GPS_FIX);
	            //dc.drawText(locX, locY, Gfx.FONT_TINY, sunInfoString, Gfx.TEXT_JUSTIFY_CENTER);
	            dc.drawBitmap(locX, locY, gpsImage);
	        }
	        
        }
    }
}
