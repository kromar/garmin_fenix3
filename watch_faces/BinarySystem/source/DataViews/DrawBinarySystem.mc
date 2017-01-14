



    //===============================
    //! draw binary layout
    //===============================
    function drawBinaryLayout(dc,h,w,hours,minutes,seconds) {
        //Sys.println("drawing binary");
        var r = 9; //keep this a uneven number for better circle
        var r1 = 1;
        var r2 = 2;
        var lines = 3;
        var rows = 6;
        var b = 47;
        var x = w/2+r+r2;
        var o = 8;
        var y = (h-2*b)/(rows-1)+1;
        var ox = o + 2*(r+r2);

        var color_rgb = App.getApp().getProperty("ForegroundColor");
        var color_bg = Gfx.COLOR_BLACK;
        var color_fg = Gfx.COLOR_WHITE;
        var color_a = Gfx.COLOR_TRANSPARENT;

        var activeSeconds = feedingTime(seconds, true);
        var activeMinutes = feedingTime(minutes, true);
        var activeHours = feedingTime(hours, false);

        for (var iL=0; iL<lines; iL++) {
            for (var iR=0; iR<rows; iR++) {
                //draw circles
                dc.setColor(color_fg, color_bg);
                    dc.fillCircle(x+iL*ox, h-iR*y-b, r+r2);
                dc.setColor(color_bg, color_bg);
                    dc.fillCircle(x+iL*ox, h-iR*y-b, r+r1);
                //seconds
                if (activeSeconds[rows-iR-1] == true and iL == 2) {
                    dc.setColor(color_rgb, color_bg);
                        dc.fillCircle(x+iL*ox, h-iR*y-b, r);
                }
                //minutes
                else if (activeMinutes[rows-iR-1] == true and iL == 1) {
                    dc.setColor(color_rgb, color_bg);
                        dc.fillCircle(x+iL*ox, h-iR*y-b, r);
                }
                //hours
                else if (activeHours[rows-iR-1] == true and iL == 0) {
                    dc.setColor(color_rgb, color_bg);
                        dc.fillCircle(x+iL*ox, h-iR*y-b, r);
                }
                else {
                    dc.setColor(color_bg, color_bg);
                        dc.fillCircle(x+iL*ox, h-iR*y-b, r);
                }
            }
        }
    }


    //===============================
    //!feed time to binary processing
    //===============================
    function feedingTime(time, maxConvertion) {
        var input = [32,16,8,4,2,1];
        var output = {};
        var size = input.size();
        //Sys.println("start time: " + time);

        //convert time to 60 if 0
        if (maxConvertion and time == 0){
            time = 60;
        }

        for (var i=0; i<size; i++) {
            if (time/input[i] >= 1) {
                output[i]= true;
                time -= input[i];
            } else {
                output[i] = false;
            }
        }
        //Sys.println(output);
        //Sys.println("-----------------------------");
        return output;
    }