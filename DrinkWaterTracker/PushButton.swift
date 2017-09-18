//
//  PushButton.swift
//  DrinkWaterTracker
//
//  Created by Harvey Zhang on 4/16/15.
//  Copyright (c) 2015 HappyGuy. All rights reserved.
//

import UIKit

/* 
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

Q: What's stroke ?
A stroke that draw outwards from the center of the path.

Q: What's fill ?
A fill only draw inside the path.

Key Point: Paths themselves don’t draw anything. You can define paths without an available drawing context. To draw the path, you gave the current context a fill color, and then fill the path.

Note: A context has a single path in use at any time: a path is not part of the graphics state. Begin a new path. The old path is discarded.

Q: How to draw a +/- sign?
You could draw two rectangles for the + sign, but it’s easier to draw a path and then stroke it with the desired thickness.

UIButton -> UIControl -> UIView -> UIResponder -> NSObject
*/
@IBDesignable class PushButton: UIButton    // @IBDesignable, opens up Live Rendering to you.
{
	// @IBInspectable is an attribute you can add a property that makes it readable by the Interface Builder.
	// This means that you will be able to configure the color for the button in your storyboard instead of in code.
    @IBInspectable var fillColor: UIColor = UIColor.green
    @IBInspectable var lineColor: UIColor = UIColor.white
    @IBInspectable var isAddButton: Bool = true
    
    /* Override drawRect(_:) and add some Core Graphics drawing code. 
	
	!!!: Each UIView has a graphics context, any drawing done in draw(_:) goes into the view's gc; and all drawing for the view renders into this context before being transferred to the device's hardware. 
	iOS updates the gc by calling draw(_:) whenever the view needs to be updated. This happens when:
	-1. The view is new to the screen.
	-2. Other views on top of it are moved.
	-3. The view's hidden property is changed.
	-4. Your app explicitly calls the setNeedsDisplay() or setNeedsDisplayInRect() methods on the view.
	*/
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
   
}//EndOfClass
