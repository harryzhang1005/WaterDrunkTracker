//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

let size = CGSize(width: 120, height: 200)

UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
let context = UIGraphicsGetCurrentContext() // a new drawing context

// gold colors
let darkGoldColor = UIColor(red: 0.6, green: 0.5, blue: 0.15, alpha: 1.0)
let midGoldColor = UIColor(red: 0.86, green: 0.73, blue: 0.3, alpha: 1.0)
let lightGoldColor = UIColor(red: 1.0, green: 0.98, blue: 0.9, alpha: 1.0)

// add shadow, When you draw an object into the context, this code creates a shadow for each object.
// Fortunately, it’s pretty easy to fix. Simply group drawing objects with a transparency layer, and you’ll only draw one shadow for the whole group.
let shadow: UIColor = UIColor.blackColor().colorWithAlphaComponent(0.80)
let shadowOffset = CGSizeMake(2.0, 2.0)
let shadowBlurRadius: CGFloat = 5
CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor)

CGContextBeginTransparencyLayer(context, nil)   // make the group, begin a group

// 1. Lower ribbon
var lowerRibbonPath = UIBezierPath()
lowerRibbonPath.moveToPoint(CGPointMake(0, 0))
lowerRibbonPath.addLineToPoint(CGPointMake(40, 0))
lowerRibbonPath.addLineToPoint(CGPointMake(78, 70))
lowerRibbonPath.addLineToPoint(CGPointMake(38, 70))
lowerRibbonPath.closePath()
UIColor.redColor().setFill()
lowerRibbonPath.fill()

// 2. Clasp
var claspPath = UIBezierPath(roundedRect: CGRectMake(36, 62, 43, 20), cornerRadius: 5)
claspPath.lineWidth = 5
darkGoldColor.setStroke()
claspPath.stroke()

// 3. Medallion
var medallionPath = UIBezierPath(ovalInRect: CGRect(origin: CGPointMake(8, 72), size: CGSizeMake(100, 100)))

CGContextSaveGState(context)
medallionPath.addClip() // create a clipping path to constrain the gradient within the medallion's circle

let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), [darkGoldColor.CGColor, midGoldColor.CGColor, lightGoldColor.CGColor], [0, 0.51, 1])
CGContextDrawLinearGradient(context, gradient, CGPointMake(40, 40), CGPointMake(100, 160), 0)


// To draw the solid internal line of the medal, use the medallion’s circle path, but scale it before drawing. Instead of transforming the whole context, you’ll just apply the transform to one path.
// create a transform, scale it, and translate it right and down
var transform = CGAffineTransformMakeScale(0.8, 0.8)    // scales down 80%
transform = CGAffineTransformTranslate(transform, 15, 30)
medallionPath.lineWidth = 2.0
medallionPath.applyTransform(transform)     // apply the transform to the path
medallionPath.stroke()


// you save the context’s drawing state before adding the clipping path, and restore it after the gradient is drawn so that the context is no longer clipped.
CGContextRestoreGState(context)

// 4. Upper ribbon
var upperRibbonPath = UIBezierPath()
upperRibbonPath.moveToPoint(CGPointMake(68, 0))
upperRibbonPath.addLineToPoint(CGPointMake(108, 0))
upperRibbonPath.addLineToPoint(CGPointMake(78, 70))
upperRibbonPath.addLineToPoint(CGPointMake(38, 70))
upperRibbonPath.closePath()

UIColor.blueColor().setFill()
upperRibbonPath.fill()

// 5. Number one
let numberOne = "1" as NSString     // must be NSString to be able to use drawInRect()
let numberOneRect = CGRectMake(47, 100, 50, 50)
let font = UIFont(name: "Academy Engraved LET", size: 60)
let textStyle = NSMutableParagraphStyle.defaultParagraphStyle()
let numberOneAttributes = [NSFontAttributeName: font!, NSForegroundColorAttributeName: darkGoldColor]
numberOne.drawInRect(numberOneRect, withAttributes: numberOneAttributes)

// end the group
CGContextEndTransparencyLayer(context)

// end always
let image = UIGraphicsGetImageFromCurrentImageContext()
UIGraphicsEndImageContext()
