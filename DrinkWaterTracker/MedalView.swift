//
//  MedalView.swift
//  DrinkWaterTracker
//
//  Created by Harvey Zhang on 4/18/15.
//  Copyright (c) 2015 HappyGuy. All rights reserved.
//

import UIKit

class MedalView: UIImageView
{
    lazy var medalImage: UIImage = self.createMedalImage()
    
    func showMedal(show: Bool)
    {
        if show {
            image = medalImage
        }
        else {
            image = nil
        }
    }
    
    // create an off-screen image
    private func createMedalImage() -> UIImage
    {
        let size = CGSize(width: 120, height: 200)  // define the medal size
        
        // if you start drawing outside of drawRect(_:), you’ll have to create your own graphics context.
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0) // creates a new context, true is opaque (faster), false is transparency
        let context = UIGraphicsGetCurrentContext() // the image context
        
        let darkGoldColor = UIColor(red: 0.6, green: 0.5, blue: 0.15, alpha: 1.0)   // gold colors
        let midGoldColor = UIColor(red: 0.86, green: 0.73, blue: 0.3, alpha: 1.0)
        let lightGoldColor = UIColor(red: 1.0, green: 0.98, blue: 0.9, alpha: 1.0)
        
        // add shadow to context, When you draw an object into the context, this code creates a shadow for each object.
        // Simply group drawing objects (1-5) with a transparency layer, and you’ll only draw one shadow for the whole group.
        // The shadow is a gstate parameter. After a shadow is specified, all objects drawn subsequently will be shadowed. To turn off shadowing, set the shadow color to a fully transparent color (or pass NULL as the color), or use the standard gsave/grestore mechanism.
        let shadowColor: UIColor = UIColor.blackColor().colorWithAlphaComponent(0.80)
        let shadowOffset = CGSizeMake(2.0, 2.0)
        let shadowBlurRadius: CGFloat = 5
        CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadowColor.CGColor)  // CGx is C func, so no explicit param names
        //func CGContextSetShadowWithColor(context: CGContext!, offset: CGSize, blur: CGFloat, color: CGColor!)
        
        CGContextBeginTransparencyLayer(context, nil)   /// start a transparency layer for group drawing objects
        
        // Object 1. Lower ribbon 斜四边形
        var lowerRibbonPath = UIBezierPath()    // clock wise draw the back ribbon
        lowerRibbonPath.moveToPoint(CGPointMake(0, 0))          // (0, 0)
        lowerRibbonPath.addLineToPoint(CGPointMake(40, 0))      // (40, 0)
        lowerRibbonPath.addLineToPoint(CGPointMake(78, 70))     // (78, 70)
        lowerRibbonPath.addLineToPoint(CGPointMake(38, 70))     // (38, 70)
        lowerRibbonPath.closePath()
        UIColor.redColor().setFill()
        lowerRibbonPath.fill()
        
        // Object 2. Clasp 扣环
        var claspPath = UIBezierPath(roundedRect: CGRectMake(36, 62, 43, 20), cornerRadius: 5)
        claspPath.lineWidth = 5
        darkGoldColor.setStroke()
        claspPath.stroke()
        
        // Object 3. Medallion 徽章
        var medallionPath = UIBezierPath(ovalInRect: CGRect(origin: CGPointMake(8, 72), size: CGSizeMake(100, 100)))
        
        CGContextSaveGState(context)    // save the context’s drawing state before adding the clipping path
        
        medallionPath.addClip()         // create a clipping path to constrain the gradient within the medallion's circle
        
        let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(),
            [darkGoldColor.CGColor, midGoldColor.CGColor, lightGoldColor.CGColor], [0, 0.51, 1])
        
        // Fill the current clipping region of `context' with a linear gradient from `startPoint' to `endPoint'.
        CGContextDrawLinearGradient(context, gradient, CGPointMake(40, 40), CGPointMake(100, 160), 0)
        
        // To draw the solid internal line of the medal, use the medallion’s circle path, but scale it before drawing. Instead of transforming the whole context, you’ll just apply the transform to one path.
        var transform = CGAffineTransformMakeScale(0.8, 0.8)        // scale     transform, scales down 80%
        transform = CGAffineTransformTranslate(transform, 15, 30)   // translate transform
        medallionPath.lineWidth = 2.0
        medallionPath.applyTransform(transform)     // apply the transform to the path
        medallionPath.stroke()
        
        CGContextRestoreGState(context)  // restore it after the gradient is drawn so that the context is no longer clipped
        
        // Object 4. Upper ribbon
        var upperRibbonPath = UIBezierPath()
        upperRibbonPath.moveToPoint(CGPointMake(68, 0))
        upperRibbonPath.addLineToPoint(CGPointMake(108, 0))
        upperRibbonPath.addLineToPoint(CGPointMake(78, 70))
        upperRibbonPath.addLineToPoint(CGPointMake(38, 70))
        upperRibbonPath.closePath()
        UIColor.blueColor().setFill()
        upperRibbonPath.fill()
        
        // Object 5. Number one
        let numberOne = "1" as NSString     // must be NSString to be able to use drawInRect()
        let numberOneRect = CGRectMake(47, 100, 50, 50)
        let font = UIFont(name: "Academy Engraved LET", size: 60)
        let textStyle = NSMutableParagraphStyle.defaultParagraphStyle()     // optional
        let numberOneAttributes = [NSFontAttributeName: font!, NSParagraphStyleAttributeName: textStyle,
                                   NSForegroundColorAttributeName: darkGoldColor]
        numberOne.drawInRect(numberOneRect, withAttributes: numberOneAttributes)
        
        CGContextEndTransparencyLayer(context)      /// end the transparency layer for group drawing objects
        
        let image = UIGraphicsGetImageFromCurrentImageContext()     // end always
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
   
}//EndClass
