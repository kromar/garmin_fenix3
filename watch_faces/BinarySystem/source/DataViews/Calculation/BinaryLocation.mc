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
	
	function circularLocation(dc, column, item)
	{
		var width = dc.getWidth();
		var height = dc.getHeight();
		
		var circleLocation = (item - 2.5) / 6.0 * Math.PI / 2.5;
		
		var location = new [2];

		if (column == 0)
		{
			location[0] = width / 2.0 + width / 2.0 * Math.sin(circleLocation);
			location[1] = height / 2.0 + height / 2.0 * Math.cos(circleLocation);
		}
		if (column == 1)
		{
			location[0] = width / 2.0 - width / 2.0 * Math.cos(circleLocation);
			location[1] = height / 2.0 + height / 2.0 * Math.sin(circleLocation);
		}
		else if (column == 2)
		{
			location[0] = width / 2.0 + width / 2.0 * Math.cos(circleLocation);		
			location[1] = height / 2.0 + height / 2.0 * Math.sin(circleLocation);
		}
		else if (column == 4)
		{
			location[0] = width / 2.0 + width / 2.0 * Math.sin(circleLocation);
			location[1] = height / 2.0 + height / 2.0 * Math.cos(circleLocation);
		}
		
		//System.println(location[0] + " " + location[1] + " " + circleLocation + " " + item);
		return location;
	}
	
}