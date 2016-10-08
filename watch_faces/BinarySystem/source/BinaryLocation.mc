using Toybox.Math as Math;
using Toybox.System as System;

class BinaryLocation
{
	function linearLocation(dc, column, item)
	{
		var width = dc.getWidth();
		var height = dc.getHeight();
		var location = new [2];
		location[0] = width / 2+ column * 20;
		location[1] = height / 2 + 15 - item * 20;
		return location;
	}
	
	function leftBorderLocation(dc, column, item)
	{
		var width = dc.getWidth();
		var height = dc.getHeight();
		
		var circleLocation = (item - 3) / 6.0 * Math.PI / 2.0;
		
		var location = new [2];
		location[0] = width / 2.0 - width / 2.0 * Math.cos(circleLocation);
		location[1] = height / 2.0 + height / 2.0 * Math.sin(circleLocation);
		//System.println(location[0] + " " + location[1] + " " + circleLocation + " " + item);
		return location;
	}
	
	function rightBorderLocation(dc, column, item)
	{
		var width = dc.getWidth();
		var height = dc.getHeight();
		
		var circleLocation = (item - 3) / 6.0 * Math.PI / 2.0;
		
		var location = new [2];
		location[0] = width / 2.0 + width / 2.0 * Math.cos(circleLocation);
		location[1] = height / 2.0 + height / 2.0 * Math.sin(circleLocation);
		//System.println(location[0] + " " + location[1] + " " + circleLocation + " " + item);
		return location;
	}

}