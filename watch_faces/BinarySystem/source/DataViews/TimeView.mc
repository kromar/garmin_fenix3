using Toybox.Lang as Lang;
using Toybox.Graphics as Gfx;
using Toybox.Application as App;
using Toybox.Time.Gregorian as Gregorian;
using Toybox.Time as Time;
using Toybox.WatchUi as Ui;


class TimeView extends Ui.Drawable
{
    var showTime = true;
    var showDate = true;
    var timeFontSize = 4;
    var dateFontSize = 1;

    function initialize(params)
    {
        Ui.Drawable.initialize(params);

        var x = params.get(:x);
        var y = params.get(:y);

        showTime = params.get(:showTime);
        showDate = params.get(:showDate);

        timeFontSize = params.get(:timeFontSize);
        dateFontSize = params.get(:dateFontSize);

        Ui.Drawable.setLocation(x, y);

    }

    function draw(dc)
    {
        //var showTime= App.getApp().getProperty("showTime");
        //var showDate= App.getApp().getProperty("showDate");
        var now = Time.now();
        var time = Gregorian.info(now, Time.FORMAT_LONG);

        var bg_color = Gfx.COLOR_BLACK;
        var fg_color = Gfx.COLOR_WHITE;
        var bg_transp = Gfx.COLOR_TRANSPARENT;
        var dot_color = App.getApp().getProperty("ForegroundColor");

		//calculate offset
		var timeFontOffset =  (Gfx.getFontDescent(timeFontSize) + Gfx.getFontAscent(timeFontSize)/2);
        //System.println("timeFontOffset" + timeFontOffset);

        if (showTime)
        {
            var timeStr = Lang.format("$1$:$2$", [time.hour, time.min.format("%02d")]);
            dc.setColor(fg_color, bg_transp);
            dc.drawText(locX, locY-timeFontOffset, timeFontSize , timeStr, Gfx.TEXT_JUSTIFY_CENTER);

        }


        //===============================
        //!draw date
        //===============================
        if (showDate)
        {
            var dateStr = Lang.format("$1$ $2$ $3$", [time.day_of_week, time.month, time.day]);
            dc.setColor(dot_color, bg_transp);
            dc.drawText(locX, locY + (showTime ? timeFontOffset/2 : 0), dateFontSize, dateStr, Gfx.TEXT_JUSTIFY_CENTER);
        }
    }
}
