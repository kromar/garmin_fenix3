using Toybox.System as Sys;


class BluetoothView extends DataView
{
	function initialize()
	{
	
	}

	function drawItem(dc)
	{
		var devSettings = Sys.getDeviceSettings();
		var phoneConnected = devSettings.phoneConnected();
		
		if (phoneConnected)
		{
		
		}
	
	}
}
