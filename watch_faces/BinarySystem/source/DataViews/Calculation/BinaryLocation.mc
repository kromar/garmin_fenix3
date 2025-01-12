using Toybox.Math as Math;
using Toybox.System as System;
using Toybox.Graphics as Graphics;

enum
{
	Circular,
	Vertical,
	Horizontal
}

class Point {
    var x;
    var y;

    function initialize(x, y) {
        self.x = x;
        self.y = y;
    }
}

class BinaryLocation
{
	var locX = 0;
	var locY = 0;
	var borderDistance = 0;
	

	function verticalLocation(dc, column, item)
	{
		var location = new Point(
		locX + column * 20,
		locY + (6 - item) * 20);
		return location;
	}
	function horizontalLocation(dc, column, item)
	{
		var location = new Point(locX + item * 20,  locY + column * 20);
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
			location = new Point( width / 2.0 + (width - borderDistance) / 2.0 * Math.sin(circleLocation),
			 height / 2.0 + (height - borderDistance) / 2.0 * Math.cos(circleLocation));
		}
		if (column == 1)
		{
			location = new Point (
			width / 2.0 + (width - borderDistance) / 2.0 * Math.cos(circleLocation),
			height / 2.0 - (height - borderDistance) / 2.0 * Math.sin(circleLocation));
		}
		else if (column == 2)
		{
			location = new Point (
			width / 2.0 - (width - borderDistance) / 2.0 * Math.cos(circleLocation),		
			height / 2.0 - (height - borderDistance) / 2.0 * Math.sin(circleLocation));
		}
		else if (column == 3)
		{
			location = new Point (
			width / 2.0 - (width - borderDistance) / 2.0 * Math.sin(circleLocation),
			height / 2.0 + (height - borderDistance) / 2.0 * Math.cos(circleLocation));
		}
		
		//System.println(location[0] + " " + location[1] + " " + circleLocation + " " + item);
		return location;
	}
}