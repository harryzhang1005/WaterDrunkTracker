//
//  BackgroundView.swift
//  DrinkWaterTracker
//
//  Created by Harvey Zhang on 4/17/15.
//  Copyright (c) 2015 HappyGuy. All rights reserved.
//

import UIKit

// Create a repeating pattern for the background
@IBDesignable class BackgroundView: UIView
{
    @IBInspectable var lightColor: UIColor = UIColor.orange
    @IBInspectable var darkColor: UIColor = UIColor.yellow
    @IBInspectable var patternSize: CGFloat = 200     // controls the size of repeating pattern

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect)
    {
        // Step-1: draw bg color
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(darkColor.cgColor)  // reset fill color in current view's context
        context?.fill(rect)
        
        // Step-2: draw triangles
        self.drawTriangles(context!, rect: rect)
    }
    
    /* draw triangles
    
    So far, you’ve drawn directly into the view’s drawing context. To be able to repeat this pattern, you need to create an image outside of the context, and then use that image as a pattern in the context.
    */
    func drawTriangles(_ context: CGContext, rect: CGRect)
    {
        let drawSize = CGSize(width: patternSize, height: patternSize)
        
        ////// Create an off-screen image start //////
        UIGraphicsBeginImageContextWithOptions(drawSize, true, 0.0)  // creates a new image's context and sets it as the current drawing context; true is opaque (faster), false is transparency; 0.0 ensures the correct scale of the context for the device is automatically applied.
        let drawingContext = UIGraphicsGetCurrentContext()	// get the new image's context
        
        // 1) Draw the rect as the backgroud
        darkColor.setFill()     // set the fill color for the new image context
        drawingContext?.fill(CGRect(x: 0, y: 0, width: drawSize.width, height: drawSize.height))
 
        // 2) Draw triangles as a pattern
        // moveToPoint(_:) is just like lifting your pen from the paper when you’re drawing and moving it to a new spot.
        let trianglePath = UIBezierPath()   // Notice how you use one path to draw three triangles.
        
        // triange-1
        trianglePath.move(to: CGPoint(x: drawSize.width/2, y: 0))                // point 1
        trianglePath.addLine(to: CGPoint(x: 0, y: drawSize.height/2))            // point 2
        trianglePath.addLine(to: CGPoint(x:drawSize.width, y:drawSize.height/2)) // point 3
        
        // triangle-2
        trianglePath.move(to: CGPoint(x: 0, y: drawSize.height/2))                   // point 4
        trianglePath.addLine(to: CGPoint(x: drawSize.width/2, y: drawSize.height))   // point 5
        trianglePath.addLine(to: CGPoint(x: 0, y: drawSize.height))                  // point 6
        
        // triangle-3
        trianglePath.move(to: CGPoint(x: drawSize.width, y: drawSize.height/2))  // point 7
        trianglePath.addLine(to: CGPoint(x:drawSize.width/2, y:drawSize.height)) // point 8
        trianglePath.addLine(to: CGPoint(x: drawSize.width, y: drawSize.height)) // point 9
        
        lightColor.setFill()
        trianglePath.fill()
        
        // 3) combine 1) and 2) create an off-screen image
        let image = UIGraphicsGetImageFromCurrentImageContext()    // extracts a UIImage from the new image's context
        
        // Here end the image's context, the drawing context reverts to the view's context,so any further drawing in drawRect(_:) happens in the view
        UIGraphicsEndImageContext()
        ////// Create an off-screen image end //////
        
        UIColor(patternImage: image!).setFill()  // do repeate pattern using the off-screen image in view's context
        context.fill(rect)
    }
    
}//EndClass
