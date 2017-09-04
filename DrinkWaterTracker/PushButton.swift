//
//  PushButton.swift
//  DrinkWaterTracker
//
//  Created by Harvey Zhang on 4/16/15.
//  Copyright (c) 2015 HappyGuy. All rights reserved.
//

import UIKit

/* What's UIBezierPath ?

A UIBezierPath is a wrapper for a CGMutablePath, which is the lower-level Core Graphics API. 
Core Graphics is Apple's vector drawing framework.

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
    @IBInspectable var fillColor: UIColor = UIColor.green    // @IBInspectable property will be added to storybord
    @IBInspectable var lineColor: UIColor = UIColor.white
    @IBInspectable var isAddButton: Bool = true
    
    /* Override drawRect(_:) and add some Core Graphics drawing code. */
    override func draw(_ rect: CGRect)
    {
        // Step-1: Draw a circle with fill color
        let path = UIBezierPath(ovalIn: rect)
        fillColor.setFill()
        path.fill()
        
        // Step-2: Create a path for + or - sign
        let plusOrMinusPath = UIBezierPath();
        
        let plusOrMinusLength: CGFloat = min(self.bounds.width, self.bounds.height) * 0.6;  // define stroke length
        
        // horizontal storke, if 3.0, need + 0.5 anti-alias
        plusOrMinusPath.move(to: CGPoint(x: self.bounds.width/2 - plusOrMinusLength/2, y: self.bounds.height/2))
        plusOrMinusPath.addLine(to: CGPoint(x: self.bounds.width/2 + plusOrMinusLength/2, y: self.bounds.height/2))
        
        if isAddButton      // vertical stroke
        {
            plusOrMinusPath.move(to: CGPoint(x: bounds.width/2, y: bounds.height/2 - plusOrMinusLength/2))
            plusOrMinusPath.addLine(to: CGPoint(x: bounds.width/2, y: bounds.height/2 + plusOrMinusLength/2))
        }
        
        lineColor.setStroke();              // set the stroke color
        
        plusOrMinusPath.lineWidth = 4.0;    // if 3.0, need anti-alias, line thickness
        plusOrMinusPath.stroke()            // draw the stroke 描边
    }
   
}//EndOfClass
