using Toybox.System as Sys;
using Toybox.WatchUi as Ui;

class BluetoothView extends BinaryWatchDrawable
{
	var image = null;
	function initialize(params)
	{
		BinaryWatchDrawable.initialize(params);
		locX = params.get(:x) * scaleFactorX;
		locY = params.get(:y) * scaleFactorY;
		
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
