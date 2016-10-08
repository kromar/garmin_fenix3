using Toybox.Lang as Lang;
using Toybox.Graphics as Gfx;
using Toybox.Application as App;

class TimeView
{
	function drawTime(dc, time)
	{
		var bg_color = Gfx.COLOR_BLACK;
        var fg_color = Gfx.COLOR_WHITE;
        var bg_transp = Gfx.COLOR_TRANSPARENT;
	    var dot_color = App.getApp().getProperty("ForegroundColor");
	    
	    
		var timeStr = Lang.format("$1$:$2$", [time.hour, time.min.format("%02d")]);
        dc.setColor(fg_color, bg_transp);
        dc.drawText(94, 90, Gfx.FONT_LARGE, timeStr, Gfx.TEXT_JUSTIFY_RIGHT);
        //===============================
        //!draw date
        //===============================
        var dateStr = Lang.format("$1$ $2$", [time.day_of_week, time.day]);
        dc.setColor(dot_color, bg_transp);
        dc.drawText(94, 120, Gfx.FONT_TINY, dateStr, Gfx.TEXT_JUSTIFY_RIGHT);
	}
}