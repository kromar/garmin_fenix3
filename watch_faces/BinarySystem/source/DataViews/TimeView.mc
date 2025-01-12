using Toybox.Lang as Lang;
using Toybox.Graphics as Gfx;
using Toybox.Application as App;
using Toybox.Time.Gregorian as Gregorian;
using Toybox.Time as Time;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;


class TimeView extends BinaryWatchDrawable
{
    var showTime = true;
    var showDate = true;

    function initialize(params)
    {
        BinaryWatchDrawable.initialize(params);

        var x = params.get(:x) * scaleFactorX;
        var y = params.get(:y) * scaleFactorY;
        showTime = params.get(:showTime);
        showDate = params.get(:showDate);
        Ui.Drawable.setLocation(x, y);
    }

    function draw(dc)
    {
        //var showTime= AppStorage.getProperty("showTime");
        //var showDate= AppStorage.getProperty("showDate");
        var now = Time.now();
        var time = Gregorian.info(now, Time.FORMAT_LONG);

        var fg_color = Gfx.COLOR_WHITE;
        var bg_transp = Gfx.COLOR_TRANSPARENT;
        var dot_color = AppStorage.getProperty("ForegroundColor");


        if (showTime)
        {
            var timeStr = Lang.format("$1$:$2$", [time.hour, time.min.format("%02d")]);
            dc.setColor(fg_color, bg_transp);
            dc.drawText(locX, locY, Gfx.FONT_LARGE, timeStr, Gfx.TEXT_JUSTIFY_CENTER);
        }
        //===============================
        //!draw date
        //===============================
        if (showDate)
        {
            var dateStr = Lang.format("$1$ $2$ $3$", [time.day_of_week, time.month, time.day]);
            dc.setColor(dot_color, bg_transp);
            dc.drawText(locX, locY + (showTime ? 30 * scaleFactorY : 0), Gfx.FONT_TINY, dateStr, Gfx.TEXT_JUSTIFY_CENTER);
        }
    }
}
