using Toybox.System as Sys;
using Toybox.WatchUi as Ui;

class AlarmView extends Ui.Drawable
{
	var image = null;
	function initialize(params)
	{
		Drawable.initialize(params);
		locX = params.get(:x);
		locY = params.get(:y);
		
		image = Ui.loadResource( Rez.Drawables.alarm_icon );
	}

	function draw(dc)
	{
		var devSettings = Sys.getDeviceSettings();
		var alarmCount = devSettings.alarmCount;
		
		if (alarmCount > 0)
		{
			dc.drawBitmap(locX, locY, image);
		}
	
	}
}
