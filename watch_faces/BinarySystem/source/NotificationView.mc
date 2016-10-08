using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

class NotificationView
{
	function drawNotifications(dc)
	{
	    var deviceSettings = Sys.getDeviceSettings();
        var notificationCount = deviceSettings.notificationCount;
        
		var width = dc.getWidth();
        var height = dc.getHeight();
		if (notificationCount > 0) 
		{
        	//draw notification box
            var w = width/2-56;
            var h = height/2-70;
            dc.setColor(fg_color, bg_transp);
            dc.drawRoundedRectangle(w, h, 40, 18, 4);
            dc.drawRectangle(w+2, h+4, 10, 1, 1);
            dc.drawRectangle(w+2, h+8, 16, 1, 1);
            dc.drawRectangle(w+2, h+12, 10, 1, 1);

            //draw notification count
            var notificationCountStr = notificationCount.toString();
            dc.setColor(dot_color, bg_transp);
            dc.drawText(w+36, h-3, Gfx.FONT_TINY, notificationCountStr, Gfx.TEXT_JUSTIFY_RIGHT);
		}
	}
}