using Toybox.System as Sys;


//get screen type so we can scale thee ui depending on screen type, and proportions
// we want to d here is work with one layout type andd convert it to different screen proportions,
// so if our screen is not square circle we reduce the height values for a target display by the calculated percentage
// to fit the screen height of the new device
// we do the same for screen formats, we switch from circular to linear layout for the binary draw

class LayoutCorrection
{
	var deviceSettings = Sys.getDeviceSettings();
	var screenShape = deviceSettings.screenShape;
	var width = deviceSettings.screenWidth;
	var height = deviceSettings.screenHeight;
	var correctionFactor = 1;
	var value = null;


 function getCorrection(value) {

   //shapes: https://developer.garmin.com/connect-iq/user-experience-guide/appendices/
   //   1 = circle           //   2 = semi circle           //   3= rect / tall / square

    //TODO: specify scaling factors for each screenShape
    if (screenShape == 1) //circle screen
	   {
	        correctionFactor = (1.0 / width * height);
            Sys.println("screen correction1:" + correctionFactor);
	   }
	   else if (screenShape == 2) // semi circle screen
	   {
            correctionFactor = (1.0 / width * height);
	        Sys.println("screen correction2:" + correctionFactor);
	   }
	   else if (screenShape == 3) // rectangular screens
	   {
	       if (height > width) // tall rectangular
	   {
            correctionFactor = (1.0 / width * height);
	        Sys.println("screen correction3:" + correctionFactor);
	    }
	    else if (height < width) // wide rectangular
	    {
            correctionFactor = (1.0 / width * height);
	        Sys.println("screen correction4:" + correctionFactor);
	    }
	    else if (height == width)   //  square
	    {
            correctionFactor = (1.0 / width * height);
	        Sys.println("screen correction5:" + correctionFactor);
	     }
     }

     Sys.println("Layout Correction: " + correctionFactor + " " + value +
                        "->> " + Math.round(value * correctionFactor).format("%d"));

	value = (Math.round(value * correctionFactor).format("%d")).toNumber();
	Sys.println("screenShape: " + screenShape + " width: " +  width + " height: " + height);
	return value ;
	}
}