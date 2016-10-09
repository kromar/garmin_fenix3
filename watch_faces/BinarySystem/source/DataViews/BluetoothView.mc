using Toybox.System as Sys;
using Toybox.WatchUi as Ui;

class BluetoothView extends DataView
{
	var image = null;
	function initialize()
	{
		image = Ui.loadResource( Rez.Drawables.bluetooth_icon );
	}

	function drawItem(dc)
	{
		var devSettings = Sys.getDeviceSettings();
		var phoneConnected = devSettings.phoneConnected;
		
		if (phoneConnected)
		{
			dc.drawBitmap(50, 30, image);
		}
	
	}
}
