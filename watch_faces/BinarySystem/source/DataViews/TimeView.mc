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

        // font heights
        //0 (18); 1 (22) ; 2 (26); 3 (29); 4 (38); 5 (32);  6 (60); 7 (83); 8 (116);
        var fontSize =4;
         System.println("ascent: " + Gfx.getFontAscent(fontSize));
         System.println("descent: " + Gfx.getFontDescent(fontSize));
         System.println("fontheight: " +Gfx.getFontHeight(fontSize));

         //correct position based on font size
          System.println("locY: " + locY);
          System.println("screen w/h " + dc.getWidth() + " / " + dc.getHeight());

           //calculate offset
           var font_offset =  Gfx.getFontDescent(fontSize);
           System.println("font_offset: " + font_offset);

        if (showTime)
        {
            var timeStr = Lang.format("$1$:$2$", [time.hour, time.min.format("%02d")]);
            dc.setColor(fg_color, bg_transp);

            dc.drawText(locX, locY, fontSize , timeStr, Gfx.TEXT_JUSTIFY_CENTER);
            //dc.drawText(locX, locY-font_offset, fontSize , timeStr, Gfx.TEXT_JUSTIFY_CENTER);

            //debug grid
            dc.setColor(fg_color, bg_transp);
            //horizontal
            dc.drawLine(0, dc.getHeight()/2, dc.getWidth() , dc.getHeight()/2);
            //vertical
            dc.drawLine(dc.getWidth()/2, 0, dc.getWidth()/2 , dc.getHeight() );

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
