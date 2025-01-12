using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Application as App;
using Toybox.WatchUi as Ui;

class NotificationView extends BinaryWatchDrawable
{
	var fontSize = Gfx.FONT_TINY;
	function initialize(params)
	{
		BinaryWatchDrawable.initialize(params);
		locX = params.get(:x) * scaleFactorX;
		locY = params.get(:y) * scaleFactorY;
		fontSize = params.get(:fontSize);

	}

	function draw(dc)
	{
		var dot_color = AppStorage.getProperty("ForegroundColor");
        var bg_transp = Gfx.COLOR_TRANSPARENT;
	    var fg_color = Gfx.COLOR_WHITE;


	    var deviceSettings = Sys.getDeviceSettings();
        var notificationCount = deviceSettings.notificationCount;

		if (notificationCount > 0)
		{
            dc.setColor(fg_color, bg_transp);
            dc.drawRoundedRectangle(locX, locY, 40 * scaleFactorX, 18 * scaleFactorY, 4);
            dc.drawRectangle(locX+2, locY+4, 10, 1);
            dc.drawRectangle(locX+2, locY+8, 16, 1);
            dc.drawRectangle(locX+2, locY+12, 10, 1);

            //draw notification count
            var notificationCountStr = notificationCount.toString();
            dc.setColor(dot_color, bg_transp);
            dc.drawText(locX+36 * scaleFactorX, locY-1, fontSize, notificationCountStr, Gfx.TEXT_JUSTIFY_RIGHT);
		}
	}
}