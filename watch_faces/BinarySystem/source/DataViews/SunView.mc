using Toybox.Graphics as Gfx;
using Toybox.Application as App;
using Toybox.Time as Time;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Activity as Activity;

// references
//https://forums.garmin.com/showthread.php?351367-Sun-rise-sunset/page2
// https://github.com/haraldh/SunCalc
//http://lexikon.astronomie.info/zeitgleichung/

class SunView extends Ui.Drawable
{
    var showSun = false;
    var gpsImage = null;
    var latitude = null;
    var longitude = null;
    var curLoc = null;
    var hasStoredLocationData = false;
    var iconX = 0;
    var iconY = 0;
    var textX = 0;
    var textY = 0;

    function initialize(params)
        {
            Ui.Drawable.initialize(params);
            iconX = params.get(:iconX);
            iconY = params.get(:iconY);
            textX = params.get(:textX);
            textY = params.get(:textY);
            //Drawable.setLocation(iconX, iconY);

            showSun = params.get(:showSun);
            gpsImage = Ui.loadResource(Rez.Drawables.nogps_icon);
            var curLoc = Activity.getActivityInfo().currentLocation;
            var hasStoredLocationData = false;

             //when the location  is defined we can write the location to the app properties
              if (curLoc != null)
				{
				    var latlon = curLoc.toRadians();
				    hasStoredLocationData = true;
				    latitude = latlon[0];
				    longitude = latlon[1];
				    Application.Properties.setValue("lastStoredLatitude", latitude);
				    Application.Properties.setValue("lastStoredLongitude", longitude);
				    Application.Properties.setValue("hasStoredLocationData", hasStoredLocationData);

				}
				else //when no location is present
				{
				    //check if there is stored location data and load it if available
				    hasStoredLocationData = Application.Properties.getValue("hasStoredLocationData");
				    if (hasStoredLocationData==true)
				    {   // then get the stored location
				        latitude = Application.Properties.getValue("lastStoredLatitude");
				        longitude = Application.Properties.getValue("lastStoredLongitude");
				    }
				}
            }

    //TODO: i think we miss the case where the user gets a location for the first time and the init is not triggered (when is init triggered?)
    function draw(dc)
    {
        var showSun = Application.Properties.getValue("ShowSun");

        if (showSun==true)
        {
            var dot_color = Application.Properties.getValue("ForegroundColor");
            var bg_transp = Gfx.COLOR_TRANSPARENT;
            dc.setColor(dot_color, bg_transp);
            var sc = new SunCalc();

            // get stored data
            var hasStoredLocationData = Application.Properties.getValue("hasStoredLocationData");
            if (hasStoredLocationData==true) {
                var now = new Time.Moment(Time.now().value());

                var sunrise_moment = sc.calculate(now, latitude, longitude, SUNRISE);
                var sunset_moment = sc.calculate(now, latitude, longitude, SUNSET);

                var timeInfoSunrise = Time.Gregorian.info(sunrise_moment, Time.FORMAT_SHORT);
                var timeInfoSunset = Time.Gregorian.info(sunset_moment, Time.FORMAT_SHORT);

                var sunInfoString = timeInfoSunrise.hour.format("%01d") + ":" + timeInfoSunrise.min.format("%02d") + " - " + timeInfoSunset.hour.format("%01d") + ":" + timeInfoSunset.min.format("%02d");
                dc.drawText(textX, textY, Gfx.FONT_TINY, sunInfoString, Gfx.TEXT_JUSTIFY_CENTER);

            } else {
                // if no location found or stored draw icon
                dc.drawBitmap(iconX, iconY, gpsImage);
            }

        }
    }
}
