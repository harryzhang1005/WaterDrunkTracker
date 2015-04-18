//
//  CounterView.swift
//  DrinkWaterTracker
//
//  Created by Harvey Zhang on 4/17/15.
//  Copyright (c) 2015 HappyGuy. All rights reserved.
//

import UIKit

let NumOfGlasses = 8
let pi: CGFloat = CGFloat(M_PI)     // you can also just use π (Unicode characters), make code more readable, (Alt + p) to type π.

// A unit circle is a circle with a radius of 1.0 .
// Radians are generally used in programming instead of degrees, and it’s useful to be able to think in radians so that you don’t have to convert to degrees every time you want to work with circles.
@IBDesignable class CounterView: UIView
{
    @IBInspectable var counter: Int = 5 {
        didSet {    // Redraw Way-2
            if counter <= NumOfGlasses {
                setNeedsDisplay();  // redraw this view
            }
        }
    }
    @IBInspectable var counterColor: UIColor = UIColor.orangeColor()
    @IBInspectable var outlineColor: UIColor = UIColor.blueColor()
    
    @IBOutlet weak var drunkCups: UILabel!
    @IBOutlet weak var medalView: MedalView!
    
    let arcWidth: CGFloat = 60.0
    let startAngle: CGFloat = 3*pi/4;
    let endAngle: CGFloat = pi/4;
    
    let markerWidth: CGFloat = 5.0, markerSize: CGFloat = 10.0;

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Step-1: Drawing Arcs
        let center: CGPoint = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        let radius: CGFloat = max(bounds.width, bounds.height)
        
        var arcPath = UIBezierPath(arcCenter: center, radius: radius/2 - arcWidth/2,
                                   startAngle: startAngle, endAngle: endAngle, clockwise: true);
        arcPath.lineWidth = arcWidth
        counterColor.setStroke()
        arcPath.stroke()
        
        // Step-2: Outlineing the Arcs, one outer and one inner
        
        //if counter > 0 {
            // then calculate the actual glasses drunk share
            let outlineEndAngle = getArcLengthPerCup() * CGFloat(counter) + startAngle;
            
            // draw the outer arc
            var outlinePath = UIBezierPath(arcCenter: center, radius: bounds.width/2 - 2.5, startAngle: startAngle, endAngle: outlineEndAngle, clockwise: true);
            // draw the inner arc
            outlinePath.addArcWithCenter(center, radius: bounds.width/2 - arcWidth + 2.5, startAngle: outlineEndAngle, endAngle: startAngle, clockwise: false)
            
            // close the path
            outlinePath.closePath();
            
            outlineColor.setStroke();
            outlinePath.lineWidth = 5.0
            outlinePath.stroke()
        //}
        
        self.drawMarker( UIGraphicsGetCurrentContext(), rect: rect)
        
    }//EndFunc

    func drawMarker(context: CGContext, rect: CGRect)
    {
        // 1. save original state, Before manipulating the context’s matrix, you save the original state of the matrix.
        CGContextSaveGState(context)
        outlineColor.setFill()
        
        // 2. the marker rectangle positioned at the top left
        var markerPath = UIBezierPath(rect: CGRect(x: -markerWidth/2, y: 0, width: markerWidth, height: markerSize))
        
        // 3. move top left of context to the previous center position. Move the context so that rotation happens around the context’s original center.
        CGContextTranslateCTM(context, rect.width/2, rect.height/2)
        
        for i in 1...NumOfGlasses
        {
            // 4. save the centred context
            CGContextSaveGState(context)
            
            // 5. calculate the rotation angle. determine the angle for each marker and rotate and translate the context.
            var angle = getArcLengthPerCup() * CGFloat(i) + startAngle - pi/2
            
            // rotate and translate
            CGContextRotateCTM(context, angle)
            CGContextTranslateCTM(context, 0, rect.height/2 - markerSize)
            
            // 6. fill the marker rectangle. Draw the marker rectangle at the top left of the rotated and translated context.
            markerPath.fill()
            
            // 7. restore the centered context for the next rotate
            CGContextRestoreGState(context)
        }
        
        // 8. restore the original state in case of more painting
        CGContextRestoreGState(context)
    }
    
    func getArcLengthPerCup() -> CGFloat
    {
        // First, calculate the difference between the two angles ensuring it is positive
        let angleDiff: CGFloat = 2*pi - startAngle + endAngle;
        
        // then calculate the arc for each glass share
        let arcLengthPerCup: CGFloat = angleDiff / CGFloat(NumOfGlasses)
        
        return arcLengthPerCup;
    }
    
    
}//EndClass
