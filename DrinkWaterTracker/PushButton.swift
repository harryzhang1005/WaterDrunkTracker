//
//  PushButton.swift
//  DrinkWaterTracker
//
//  Created by Harvey Zhang on 4/16/15.
//  Copyright (c) 2015 HappyGuy. All rights reserved.
//

import UIKit

/*
A UIBezierPath, for example, is a wrapper for a CGMutablePath, which is the lower-level Core Graphics API.

Note: Never call drawRect(_:) directly. If your view is not being updated, then call setNeedsDisplay() on the view.

setNeedsDisplay() does not itself call drawRect(_:), but it flags the view as ‘dirty’, triggering a redraw using drawRect(_:) on the next screen update cycle. Even if you call setNeedsDisplay() five times in the same method you’ll only ever actually call drawRect(_:) once.

@IBDesignable, opens up Live Rendering to you.
*/

@IBDesignable class PushButton: UIButton
{
    @IBInspectable var fillColor: UIColor = UIColor.greenColor()
    @IBInspectable var isAddButton: Bool = true
    @IBInspectable var lineColor: UIColor = UIColor.whiteColor()
    
    /* Override drawRect(_:) and add some Core Graphics drawing code.
    
    Note: Any drawing done in drawRect(_:) goes into the view’s graphics context. 
          Be aware that if you start drawing outside of drawRect(_:), you’ll have to create your own graphics context.
    
    Note: For pixel perfect lines, you can draw and fill a UIBezierPath(rect:) instead of a line, and use the view’s contentScaleFactor to calculate the width and height of the rectangle. Unlike strokes that draw outwards from the center of the path, fills only draw inside the path.
    */
    override func drawRect(rect: CGRect)
    {
        // Paths themselves don’t draw anything. You can define paths without an available drawing context. To draw the path, you gave the current context a fill color, and then fill the path.
        
        // Step-1: Draw a circle with fill color
        var path = UIBezierPath(ovalInRect: rect)
        fillColor.setFill()
        path.fill()
        
        // You could draw two rectangles for the plus sign, but it’s easier to draw a path and then stroke it with the desired thickness.
        
        // Step-2: Set up the width and height variables for the horizontal and vertical stroke
        let plusLineWidth: CGFloat = 4.0     // if 3.0, need anti-alias
        let plusLength: CGFloat = min(self.bounds.width, self.bounds.height) * 0.6;
        
        // create the path
        var plusPath = UIBezierPath();
        plusPath.lineWidth = plusLineWidth;
        
        // move the initial point of the path to the start of the horizontal storke, if 3.0, need + 0.5 anti-alias
        plusPath.moveToPoint(CGPoint(x: self.bounds.width/2 - plusLength/2, y: self.bounds.height/2))
        plusPath.addLineToPoint(CGPoint(x: self.bounds.width/2 + plusLength/2, y: self.bounds.height/2))
        
        if isAddButton      // vertical stroke
        {
            plusPath.moveToPoint(CGPoint(x: bounds.width/2, y: bounds.height/2 - plusLength/2))
            plusPath.addLineToPoint(CGPoint(x: bounds.width/2, y: bounds.height/2 + plusLength/2))
        }
        
        // set the stroke color
        lineColor.setStroke();
        
        plusPath.stroke()   // draw the stroke
    }
   
}
