# WaterDrunkTracker

Core Graphics: drawing paths, creating patterns and gradients, and transforming the context.

Q: Drawing Into the Context?

Core Graphics uses a "painter's model".

When you draw into a context, it's exactly like making a painting. You lay down a path and fill it, and then lay down another path on top and fill it. You can't change the pixels that have been laid down, but you can "paint" over them.

The order in which you draw is critical.

Q: What's UIBezierPath ?

A UIBezierPath is a wrapper for a CGMutablePath, which is the lower-level Core Graphics API. 
Core Graphics is Apple's vector drawing framework.

To draw a shape in Core Graphics, you define a path that tells Core Graphics the line to trace or the line to fill.
There are three fundamentals to know about the paths:

-1. A path can be stroked and filled

-2. A stroke outlines the path in the current stroke color

-3. A fill will fill up a closed path with the current fill color

Note: Never call drawRect(_:) directly. If your view is not being updated, then call setNeedsDisplay() on the view.

Q: How setNeedsDisplay works ?

setNeedsDisplay() does not itself call drawRect(_:), but it flags the view as ‘dirty’, triggering a redraw using drawRect(_:) on the next screen update cycle. Even if you call setNeedsDisplay() five times in the same method you’ll only ever actually call drawRect(_:) once.

Note: Any drawing done in drawRect(_:) goes into the view’s graphics context.
Be aware that if you start drawing outside of drawRect(_:), you’ll have to create your own graphics context.

Note: For pixel perfect lines, you can draw and fill a UIBezierPath(rect:) instead of a line, and use the view’s contentScaleFactor to calculate the width and height of the rectangle.

```swift
override func draw(_ rect: CGRect)
{
	// Step-1: Draw a circle with fill color.
	// Paths themselves don't draw anything. To draw a path, you gave the current graphic context a fill color, and then fill the path.
	let aCirclePath = UIBezierPath(ovalIn: rect)
	fillColor.setFill()
	aCirclePath.fill()

	// Step-2: Create a path for + or - sign
	let plusOrMinusPath = UIBezierPath();

	let plusOrMinusLength: CGFloat = min(self.bounds.width, self.bounds.height) * 0.6;  // define stroke length

	// horizontal storke, if 3.0, iPad2 and iPhone 6 Plus need + 0.5 anti-aliases
	plusOrMinusPath.move(to: CGPoint(x: self.bounds.width/2 - plusOrMinusLength/2, y: self.bounds.height/2))
	plusOrMinusPath.addLine(to: CGPoint(x: self.bounds.width/2 + plusOrMinusLength/2, y: self.bounds.height/2))

	if isAddButton      // vertical stroke
	{
		plusOrMinusPath.move(to: CGPoint(x: bounds.width/2, y: bounds.height/2 - plusOrMinusLength/2))
		plusOrMinusPath.addLine(to: CGPoint(x: bounds.width/2, y: bounds.height/2 + plusOrMinusLength/2))
	}

	lineColor.setStroke();              // set the stroke color

	plusOrMinusPath.lineWidth = 4.0;    // if 3.0, need +/- 0.5 to avoid anti-aliases, line thickness
	plusOrMinusPath.stroke()            // draw the stroke
}
```
## A Screenshot

<p align="center">
	<img src="https://github.com/harveyzhang1028/WaterDrunkTracker/blob/master/screenshots/screenshot-2.png" width=320 height=568></img>
</p>

Happy coding! :+1:  :sparkles:
