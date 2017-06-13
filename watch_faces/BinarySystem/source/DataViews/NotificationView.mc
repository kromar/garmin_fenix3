using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Application as App;
using Toybox.WatchUi as Ui;

class NotificationView extends Ui.Drawable
{
	function initialize(params)
	{
		Drawable.initialize(params);
		locX = params.get(:x);
		locY = params.get(:y);

	}

	function draw(dc)
	{
		var dot_color = App.getApp().getProperty("ForegroundColor");
        var bg_transp = Gfx.COLOR_TRANSPARENT;
        var color_bg = Gfx.COLOR_BLACK;
	    var fg_color = Gfx.COLOR_WHITE;


	    var deviceSettings = Sys.getDeviceSettings();
        var notificationCount = deviceSettings.notificationCount;

		if (notificationCount > 0)
		{
            dc.setColor(fg_color, bg_transp);
            dc.drawRoundedRectangle(locX, locY, 40, 18, 4);
            dc.drawRectangle(locX+2, locY+4, 10, 1);
            dc.drawRectangle(locX+2, locY+8, 16, 1);
            dc.drawRectangle(locX+2, locY+12, 10, 1);

            //draw notification count
            var notificationCountStr = notificationCount.toString();
            dc.setColor(dot_color, bg_transp);
            dc.drawText(locX+36, locY-3, Gfx.FONT_TINY, notificationCountStr, Gfx.TEXT_JUSTIFY_RIGHT);
		}
	}
}