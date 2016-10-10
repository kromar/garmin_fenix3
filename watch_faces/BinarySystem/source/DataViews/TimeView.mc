using Toybox.Lang as Lang;
using Toybox.Graphics as Gfx;
using Toybox.Application as App;
using Toybox.Time.Gregorian as Gregorian;
using Toybox.Time as Time;
using Toybox.WatchUi as Ui;

class TimeView extends Ui.Drawable
{
	function initialize(params)
	{
		Ui.Drawable.initialize(params);
		
		var x = params.get(:x);
        var y = params.get(:y);
		Ui.Drawable.setLocation(x, y);
	}

	function draw(dc)
	{
		var now = Time.now();
        var time = Gregorian.info(now, Time.FORMAT_LONG);
        
		var bg_color = Gfx.COLOR_BLACK;
        var fg_color = Gfx.COLOR_WHITE;
        var bg_transp = Gfx.COLOR_TRANSPARENT;
	    var dot_color = App.getApp().getProperty("ForegroundColor");
	    
	    
		var timeStr = Lang.format("$1$:$2$", [time.hour, time.min.format("%02d")]);
        dc.setColor(fg_color, bg_transp);
        dc.drawText(locX, locY, Gfx.FONT_LARGE, timeStr, Gfx.TEXT_JUSTIFY_CENTER);
        //===============================
        //!draw date
        //===============================
        var dateStr = Lang.format("$1$ $2$ $3$", [time.day_of_week, time.month, time.day]);
        dc.setColor(dot_color, bg_transp);
        dc.drawText(locX, locY+30, Gfx.FONT_TINY, dateStr, Gfx.TEXT_JUSTIFY_CENTER);
	}
}