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

// A unit circle is a circle with a radius of 1.0
// Radians are generally used in programming instead of degrees, so you don’t have to convert to degrees
@IBDesignable class CounterView: UIView
{
    @IBInspectable var counter: Int = 5 {
        didSet {    // Redraw the CounterView Way-2
            if counter <= NumOfGlasses {
                setNeedsDisplay();  // redraw this view
            }
        }
    }
    @IBInspectable var counterColor: UIColor = UIColor.orangeColor()
    @IBInspectable var outlineColor: UIColor = UIColor.blueColor()
    
    @IBOutlet weak var drunkCups: UILabel!
    @IBOutlet weak var medalView: MedalView!
    
    let arcWidth: CGFloat = 60.0, startAngle: CGFloat = 3*pi/4, endAngle: CGFloat = pi/4; // clock-wise 0 - 2pi
    let markerWidth: CGFloat = 5.0, markerHeight: CGFloat = 10.0;

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
        
        // Step-2: draw markers on the arc
        self.drawMarker( UIGraphicsGetCurrentContext(), rect: rect)
        
        // Step-3: Outlineing the Arcs, one outer and one inner outline paths
        if counter > 0 {
            let outlineEndAngle = getArcLengthPerCup() * CGFloat(counter) + startAngle; // calculate the actual glasses drunk share
            var outlinePath = UIBezierPath(arcCenter: center, radius: bounds.width/2 - 2.5,
                                           startAngle: startAngle, endAngle: outlineEndAngle, clockwise: true); // draw the outer arc
            outlinePath.addArcWithCenter(center, radius: bounds.width/2 - arcWidth + 2.5,
                                         startAngle: outlineEndAngle, endAngle: startAngle, clockwise: false); // draw the inner arc
            outlinePath.closePath(); // close the outline path
            
            outlineColor.setStroke();   // outline using same color with marker
            outlinePath.lineWidth = 5.0
            outlinePath.stroke()
        }
        
    }//EndFunc

    /* Key point
    When you’re drawing the counter view’s markers, you’ll translate the context first, then you’ll rotate it.
    
    In this diagram, the rectangle marker is at the very top left of the context. The blue lines outline the translated context, then the context rotates (red dashed line) and is translated again.
    When the red rectangle marker is finally drawn into the context, it’ll appear in the view at an angle.
    After the context is rotated and translated to draw the red marker, it needs to be reset to the center so that the context can be rotated and translated again to draw the green marker.
    */
    func drawMarker(context: CGContext, rect: CGRect)
    {
        // 1. save original state, Before manipulating the context’s matrix, you save the original state of the matrix.
        CGContextSaveGState(context)
        outlineColor.setFill()
        
        // 2. Firstly, the marker rectangle positioned at the top left (0, 0)
        var markerPath = UIBezierPath(rect: CGRect(x: -markerWidth/2, y: 0, width: markerWidth, height: markerHeight))
        
        // 3. move top left of context to the previous center position. So that rotation happens around the context’s original center.
        CGContextTranslateCTM(context, rect.width/2, rect.height/2)     // translate transform
        
        for i in 0...NumOfGlasses
        {
            CGContextSaveGState(context)    // 4. save the centred context
            
            // 5. calculate the rotation angle. determine the angle for each marker and rotate and translate the context.
            var angle = getArcLengthPerCup() * CGFloat(i) + startAngle - pi/2;  // minus pi/2 because already in center
            
            CGContextRotateCTM(context, angle)                              // rotate    transform
            CGContextTranslateCTM(context, 0, rect.height/2 - markerHeight) // translate transform again
            
            markerPath.fill()   // 6. finally, fill the marker rectangle at translate-rotate-translate new position
            
            CGContextRestoreGState(context)     // 7. restore the centered context for the next rotate and translate
        }
        
        // 8. restore the original state in case of more painting
        CGContextRestoreGState(context)
    }
    
    func getArcLengthPerCup() -> CGFloat
    {
        let angleDiff: CGFloat = 2*pi - startAngle + endAngle; // calculate the total diff between the two angles ensuring it is positive
        let arcLengthPerCup: CGFloat = angleDiff / CGFloat(NumOfGlasses)    // then calculate the arc for each glass share
        return arcLengthPerCup;
    }
    
    
}//EndClass
