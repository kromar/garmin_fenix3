using Toybox.System as Sys;
using Toybox.WatchUi as Ui;


class BinaryWatchDrawable extends Ui.Drawable
{
    var screenHeight;
    var screenWidth;
    var scaleFactorX;
    var scaleFactorY;
    function initialize(params)
    {
        self.screenHeight = Sys.getDeviceSettings().screenHeight;
        self.screenWidth = Sys.getDeviceSettings().screenWidth;
		self.scaleFactorX = screenHeight / 260.0;
		self.scaleFactorY = screenWidth / 260.0;

        Ui.Drawable.initialize(params);
    }
}