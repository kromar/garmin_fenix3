using Toybox.Lang as Lang;
using Toybox.Graphics as Gfx;
using Toybox.Application as App;
using Toybox.Time.Gregorian as Gregorian;
using Toybox.Time as Time;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class TimeView extends Ui.Drawable
{
    var showTime = true;
    var showDate = true;
    var layoutCorrection;

    function initialize(params)
    {
        Ui.Drawable.initialize(params);

        var x = params.get(:x);
        var y = params.get(:y);
        showTime = params.get(:showTime);
        showDate = params.get(:showDate);
        Ui.Drawable.setLocation(x, y);

        layoutCorrection = new LayoutCorrection();
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


        var width = dc.getWidth();
        var height = dc.getHeight();
        //correctionFactor = layoutCorrection.getCorrection(width, height);
        var correctionFactor = (1.0 / width * height); //.format("%.2f");
        Sys.println("correction: " + width + " " + height + " " + correctionFactor + " " +  locY + " " + Math.round(locY * correctionFactor).format("%d"));


        if (showTime)
        {
            var timeStr = Lang.format("$1$:$2$", [time.hour, time.min.format("%02d")]);
            dc.setColor(fg_color, bg_transp);
            locY = (Math.round(locY * correctionFactor).format("%d")).toNumber();
            dc.drawText(locX, locY, Gfx.FONT_LARGE, timeStr, Gfx.TEXT_JUSTIFY_CENTER);
        }
        //===============================
        //!draw date
        //===============================
        if (showDate)
        {
            var dateStr = Lang.format("$1$ $2$ $3$", [time.day_of_week, time.month, time.day]);
            dc.setColor(dot_color, bg_transp);
            dc.drawText(locX, locY+ (showTime ? 30 : 0), Gfx.FONT_TINY, dateStr, Gfx.TEXT_JUSTIFY_CENTER);
        }
    }
}
