using Toybox.Lang as Lang;
using Toybox.Graphics as Gfx;
using Toybox.Application as App;
using Toybox.Time.Gregorian as Gregorian;
using Toybox.Time as Time;

class TimeView extends DataView
{
	function drawItem(dc)
	{
		var now = Time.now();
        var time = Gregorian.info(now, Time.FORMAT_LONG);
        
		var bg_color = Gfx.COLOR_BLACK;
        var fg_color = Gfx.COLOR_WHITE;
        var bg_transp = Gfx.COLOR_TRANSPARENT;
	    var dot_color = App.getApp().getProperty("ForegroundColor");
	    
	    
		var timeStr = Lang.format("$1$:$2$", [time.hour, time.min.format("%02d")]);
        dc.setColor(fg_color, bg_transp);
        dc.drawText(dc.getWidth()/2.0 + 20.0, 20, Gfx.FONT_LARGE, timeStr, Gfx.TEXT_JUSTIFY_RIGHT);
        //===============================
        //!draw date
        //===============================
        var dateStr = Lang.format("$1$ $2$", [time.day_of_week, time.day]);
        dc.setColor(dot_color, bg_transp);
        dc.drawText(dc.getWidth()/2.0 + 20.0, 50, Gfx.FONT_TINY, dateStr, Gfx.TEXT_JUSTIFY_RIGHT);
	}
}