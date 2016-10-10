using Toybox.System as Sys;
using Toybox.WatchUi as Ui;

class BluetoothView extends Ui.Drawable
{
	var image = null;
	function initialize(params)
	{
		Drawable.initialize(params);
		locX = params.get(:x);
		locY = params.get(:y);
		
		image = Ui.loadResource( Rez.Drawables.bluetooth_icon );
	}

	function draw(dc)
	{
		var devSettings = Sys.getDeviceSettings();
		var phoneConnected = devSettings.phoneConnected;
		
		if (phoneConnected)
		{
			dc.drawBitmap(locX, locY, image);
		}
	
	}
}
