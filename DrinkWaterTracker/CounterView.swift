//
//  CounterView.swift
//  DrinkWaterTracker
//
//  Created by Harvey Zhang on 4/17/15.
//  Copyright (c) 2015 HappyGuy. All rights reserved.
//

import UIKit

let NumOfGlasses = 8	// The target number of glasses to drink per day. When this figure is reached, the counter will be at its maximum
let pi: CGFloat = CGFloat(Double.pi)     // you can also just use π (Unicode characters), make code more readable, (Alt + p) to type π.

// A unit circle is a circle with a radius of 1.0
// Radians are generally used in programming instead of degrees, so you don’t have to convert to degrees
@IBDesignable class CounterView: UIView
{
    @IBInspectable var counter: Int = 5 { // keeps track of the number of glasses consumed
        didSet {    // Redraw the CounterView Way-2
            if counter <= NumOfGlasses {
                setNeedsDisplay()
            }
        }
    }
    @IBInspectable var counterColor: UIColor = UIColor.orange
    @IBInspectable var outlineColor: UIColor = UIColor.blue
    
    @IBOutlet weak var drunkCups: UILabel!
    @IBOutlet weak var medalView: MedalView!
    
    let arcWidth: CGFloat = 60.0, startAngle: CGFloat = 3*pi/4, endAngle: CGFloat = pi/4; // in a clockwise direction 0 - 2pi
    let markerWidth: CGFloat = 5.0, markerHeight: CGFloat = 10.0;

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect)
    {
        // Step-1: Drawing Arcs. The arc is just a fat stroked path.
        let center: CGPoint = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        let radius: CGFloat = max(bounds.width, bounds.height)
        
        let arcPath = UIBezierPath(arcCenter: center, radius: radius/2 - arcWidth/2,
                                   startAngle: startAngle, endAngle: endAngle, clockwise: true);
        arcPath.lineWidth = arcWidth
        counterColor.setStroke()
        arcPath.stroke()
        
        // Step-2: draw markers on the arc
        self.drawMarker( UIGraphicsGetCurrentContext()!, rect: rect)
        
        // Step-3: Outlining the Arcs, one outer and one inner outline paths.
		// The outlines are another stroked path consisting of two arcs, and two line segments connecting them.
        if counter > 0 {
            let outlineEndAngle = getArcLengthPerCup() * CGFloat(counter) + startAngle; // calculate the actual glasses drunk share
			
            let outlinePath = UIBezierPath(arcCenter: center, radius: bounds.width/2 - 5/2,
                                           startAngle: startAngle, endAngle: outlineEndAngle, clockwise: true); // draw the outer arc
			
			// Adds an inner arc to the first/outer arc. Also this draws a line segment between the inner and outer arc automatically.
            outlinePath.addArc(withCenter: center, radius: bounds.width/2 - arcWidth + 5/2,
                                         startAngle: outlineEndAngle, endAngle: startAngle, clockwise: false); // draw the inner arc
			
            outlinePath.close(); // closing the path automatically draws a line segment at the other end of the arc.
            
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
    func drawMarker(_ context: CGContext, rect: CGRect)
    {
        // 1. Before manipulating the context’s matrix, you save the original state of the matrix.
        context.saveGState()
		
        outlineColor.setFill()
        
        // 2. Firstly, the marker rectangle positioned at the top left (0, 0)
		// Define the position and shape of the path -- but you're not drawing it yet.
        let markerPath = UIBezierPath(rect: CGRect(x: -markerWidth/2, y: 0, width: markerWidth, height: markerHeight))
        
        // 3. move the context so that rotation happens around the context’s original center.
        context.translateBy(x: rect.width/2, y: rect.height/2)     // translate transform
		
		// you'll save and restore the state with the transformation matrix each time you draw a marker.
        for i in 0...NumOfGlasses
        {
            context.saveGState()    // 4. for each marker, you first save the centered context state
            
            // 5. calculate the rotation angle. determine the angle for each marker and rotate and translate the context.
            let angle = getArcLengthPerCup() * CGFloat(i) + startAngle - pi/2;  // minus pi/2 because already in center
			
			// As well as drawing into a context, you have the option to manipulate the context by rotating, scaling and translating the context’s transformation matrix. !!!: the order is key point. x: 0 based on previous rotated status
            context.rotate(by: angle)									// rotate    transform
            context.translateBy(x: 0, y: rect.height/2 - markerHeight)	// translate transform again
			
			// Draw the marker rectangle at the top of the rotated and translated context.
            markerPath.fill()   // 6. finally, fill the marker rectangle at translate-rotate-translate new position
			
			// !!!: After the context is rotated and translated to draw the a marker, it needs to be reset to the center so that the context can be rotated and translated again to draw another marker.
            context.restoreGState()     // 7. restore the centered context for the next rotate and translate
        }
        
        // 8. restore the original state in case of more painting
        context.restoreGState()
    }
    
    func getArcLengthPerCup() -> CGFloat
    {
        let angleDiff: CGFloat = 2*pi - startAngle + endAngle; // calculate the total diff between the two angles ensuring it is positive
        let arcLengthPerCup: CGFloat = angleDiff / CGFloat(NumOfGlasses)    // then calculate the arc for each glass share
        return arcLengthPerCup;
    }
    
    
}//EndClass
