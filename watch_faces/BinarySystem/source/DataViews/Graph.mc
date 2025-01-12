//!
//! Copyright 2015 by Garmin Ltd. or its subsidiaries.
//! Subject to Garmin SDK License Agreement and Wearables
//! Application Developer Agreement.
//!

using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;


//! A simple line graph drawing class
class LineGraph
{
    hidden var graphArray as Lang.Array;
    hidden var graphIndex;
    hidden var graphRangeStart;
    hidden var graphRangeEnd;
    hidden var graphMinRange;
    hidden var graphColor;

    //! Constructor
    function initialize( size, minRange, color )
    {
        graphIndex = 0;
        graphRangeStart = null;
        graphRangeEnd = null; 

        if( size < 2 )
        {
            Sys.error( "graph size less than 2 is not allowed" );
        }
        graphArray = new [size];
        graphMinRange = minRange;
        graphColor = color;
    }

    //! Set graph line color
    function setColor( color )
    {
        graphColor = color;
    }

    //! Set graph line color
    function setMinRange( minRange )
    {
        graphMinRange = minRange;
    }

    function addItem(value)
    {
        var updateMin = false;
        var updateMax = false;

        if( value instanceof Number || value instanceof Float )
        {
            if(graphRangeStart  == null )
            {
                // This is our first value, save as min and max
                graphRangeStart = value;
                graphRangeEnd = value;
            }

            // Save value if it is a new minimum
            if( value < graphRangeStart )
            {
                graphRangeStart = value;
            }
            else if( graphArray[graphIndex] == graphRangeStart )
            {
                updateMin = true;
            }
            // Save value if it is a new maximum
            if( value > graphRangeEnd )
            {
                graphRangeEnd = value;
            }
            else if( graphArray[graphIndex] == graphRangeEnd )
            {
                updateMax = true;
            }

            //Fill in new Graph value
            graphArray[graphIndex] = value;
            //Increment and wrap graph index
            graphIndex += 1;
            if( graphIndex == graphArray.size() )
            {
                graphIndex = 0;
            }

            if( updateMin )
            {
                var i;
                var min = graphArray[0];
                for( i = 1 ; i < graphArray.size() ; i += 1 )
                {
                    if( graphArray[i] < min )
                    {
                        min = graphArray[i];
                    }
                }
               graphRangeStart = min;
           }

            if( updateMax )
            {
                var i;
                var max = graphArray[0];
                for( i = 1 ; i < graphArray.size() ; i += 1 )
                {
                    if( graphArray[i] > max )
                    {
                        max = graphArray[i];
                    }
                }
                graphRangeEnd = max;
            }
        }
        else
        {
            //! This isn't allowed
        }

        }

    //! Handle the update event
    function draw(dc, topLeft, bottomRight)
    {
        var min;
        var range;
        var y;
        var x;
        var prev_y;
        var prev_x;
        var drawExtentsX = bottomRight.x - topLeft.x + 1;
        var drawExtentsY = bottomRight.y - topLeft.y + 1;
        var i;
        var draw_idx = 1;

        // If the graph range is null, no values have been added yet
        if( graphRangeStart != null )
        {
            //Set Graph color       !!!no way to preserve color setting right now?
            dc.setColor(graphColor, graphColor);

            //Determine Graph minimum and range
            min = graphRangeStart;
            range = graphRangeEnd - graphRangeStart;
            range = range.toFloat();

            if( range < graphMinRange )
            {
                min -= (graphMinRange - range) / 2;
                range = graphMinRange;
            }

            prev_x = topLeft.x;
            x = topLeft.x + drawExtentsX * draw_idx / (graphArray.size() -  1);
            y = null;
            for( i = graphIndex ; i < graphArray.size() ; i += 1 )
            {
                if( graphArray[i] != null )
                {
                    prev_y = y;
                    y = bottomRight.y - ((graphArray[i] - min) * drawExtentsY / range);
                    y = y.toNumber();

                    if( prev_y != null )
                    {
                        dc.drawLine(prev_x, prev_y, x, y);
                        prev_x = x;
                        draw_idx += 1;
                        x = topLeft.x + drawExtentsX * draw_idx / (graphArray.size() - 1);
                    }
                }
            }
            for( i = 0 ; i < graphIndex ; i += 1 )
            {
                if( graphArray[i] != null )
                {
                    prev_y = y;
                    y = bottomRight.y - ((graphArray[i] - min) * drawExtentsY / range);
                    y = y.toNumber();

                    if( prev_y != null )
                    {
                        dc.drawLine(prev_x, prev_y, x, y);
                        prev_x = x;
                        draw_idx += 1;
                        x = topLeft.x + drawExtentsX * draw_idx / (graphArray.size() - 1);
                    }
                }
            }
        }
    }
}
