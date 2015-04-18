//
//  BackgroundView.swift
//  DrinkWaterTracker
//
//  Created by Harvey Zhang on 4/17/15.
//  Copyright (c) 2015 HappyGuy. All rights reserved.
//

import UIKit

@IBDesignable class BackgroundView: UIView
{
    @IBInspectable var lightColor: UIColor = UIColor.orangeColor()
    @IBInspectable var darkColor: UIColor = UIColor.yellowColor()
    @IBInspectable var patternSize: CGFloat = 200     // controls the size of repeating pattern
    

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
        
        // Step-1: draw bg color
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, darkColor.CGColor)
        CGContextFillRect(context, rect)
        
        // Step-2: draw triangles
        self.drawTriangles(context, rect: rect)
    }
    
    /* draw triangles
    
    So far, you’ve drawn directly into the view’s drawing context. To be able to repeat this pattern, you need to create an image outside of the context, and then use that image as a pattern in the context.
    */
    func drawTriangles(context: CGContext, rect: CGRect)
    {
        let drawSize = CGSize(width: patternSize, height: patternSize)
        
        ////// do repeat pattern start //////
        UIGraphicsBeginImageContextWithOptions(drawSize, true, 0.0)  // creates a new context, true is opaque (faster), false is transparency;
        let drawingContext = UIGraphicsGetCurrentContext()
        darkColor.setFill()     // set the fill color for the new context
        CGContextFillRect(drawingContext, CGRectMake(0, 0, drawSize.width, drawSize.height))
        ////// do repeat pattern end   //////
        
        // Notice how you use one path to draw three triangles. moveToPoint(_:) is just like lifting your pen from the paper when you’re drawing and moving it to a new spot.
        let trianglePath = UIBezierPath()
        
        // point 1
        trianglePath.moveToPoint(CGPoint(x: drawSize.width/2, y: 0))
        // point 2
        trianglePath.addLineToPoint(CGPoint(x: 0, y: drawSize.height/2))
        // point 3
        trianglePath.addLineToPoint(CGPoint(x:drawSize.width, y:drawSize.height/2))
        
        // point 4
        trianglePath.moveToPoint(CGPoint(x: 0, y: drawSize.height/2))
        // point 5
        trianglePath.addLineToPoint(CGPoint(x: drawSize.width/2, y: drawSize.height))
        // point 6
        trianglePath.addLineToPoint(CGPoint(x: 0, y: drawSize.height))
        
        // point 7
        trianglePath.moveToPoint(CGPoint(x: drawSize.width, y: drawSize.height/2))
        // point 8
        trianglePath.addLineToPoint(CGPoint(x:drawSize.width/2, y:drawSize.height))
        // point 9
        trianglePath.addLineToPoint(CGPoint(x: drawSize.width, y: drawSize.height))
        
        lightColor.setFill()
        trianglePath.fill()
        
        ////// do repeat pattern start //////
        let image = UIGraphicsGetImageFromCurrentImageContext()    // extracts a UIImage from the current context
        UIGraphicsEndImageContext() // end the current context, the drawing context reverts to the view's context, so any further drawing in drawRect(_:) happens in the view
        
        // draw the image as a repeated pattern
        UIColor(patternImage: image).setFill()
        CGContextFillRect(context, rect)
        ////// do repeat pattern end   //////
    }
    
    

}//EndClass
