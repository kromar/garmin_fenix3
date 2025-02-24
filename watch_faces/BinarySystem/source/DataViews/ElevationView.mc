using Toybox.System as Sys;
using Toybox.WatchUi as Ui;
using Toybox.SensorHistory as SensorHistory;
using Toybox.Sensor as Sensor;
using Toybox.Graphics as Gfx;

class ElevationView extends Ui.Drawable
{
	
	function initialize(params)
	{
		Drawable.initialize(params);
		locX = params.get(:x);
		locY = params.get(:y);
		
	}

	function draw(dc)
	{
		var elevIt = SensorHistory.getElevationHistory({ :order=>SensorHistory.ORDER_NEWEST_FIRST, :period=>1 });
		var hrIt = SensorHistory.getHeartRateHistory({ :order=>SensorHistory.ORDER_NEWEST_FIRST, :period=>1 });
		var pressureIt = SensorHistory.getPressureHistory({ :order=>SensorHistory.ORDER_NEWEST_FIRST, :period=>1});
		var tempIt = SensorHistory.getTemperatureHistory({ :order=>SensorHistory.ORDER_NEWEST_FIRST, :period=>1 });


		//var dot_color = Application.Properties.getValue("ForegroundColor");
        var bg_transp = Gfx.COLOR_TRANSPARENT;
        var color_bg = Gfx.COLOR_BLACK;
	    var fg_color = Gfx.COLOR_WHITE;
	
		dc.setColor(fg_color, bg_transp);
		dc.drawText(locX, locY, Gfx.FONT_TINY, elevIt.next().data.format("%d") + "m", Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(locX, locY+18, Gfx.FONT_TINY, hrIt.next().data.format("%d") + "bpm", Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(locX, locY+36, Gfx.FONT_TINY, pressureIt.next().data.format("%d") + "mmHg", Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(locX, locY+54, Gfx.FONT_TINY, tempIt.next().data.format("%d") + "C", Gfx.TEXT_JUSTIFY_CENTER);
	
	}
}