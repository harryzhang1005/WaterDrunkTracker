//
//  GraphView.swift
//  DrinkWaterTracker
//
//  Created by Harvey Zhang on 4/17/15.
//  Copyright (c) 2015 HappyGuy. All rights reserved.
//

import UIKit

@IBDesignable class GraphView: UIView
{
    // for gradient
    @IBInspectable var startColor: UIColor = UIColor.redColor()
    @IBInspectable var endColor: UIColor = UIColor.greenColor()

    let margin: CGFloat = 20.0
    let topBorder: CGFloat = 60, bottomBorder: CGFloat = 50;
    var graphPoints: [Int] = [5, 4, 2, 6, 5, 8, 3]; // sample data for a week
    
    @IBOutlet weak var avgCupDrunkLabel: UILabel!
    @IBOutlet weak var maxCupDrunkLabel: UILabel!
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing Code
        let context = UIGraphicsGetCurrentContext()
        
        // Step-2) Clipped gradient under the graph
        self.drawClippingAreas(context, rect: rect);
        
        // Step-1) Gradient background view
        self.drawGradientBgView(context);
        
        // Step-3) The graph line
        self.drawGraphLines(context, rect: rect)
        
        // Step-4) The circles for the graph points
        self.drawCircleForPoint(context, rect: rect)
        
        // Step-5) Horizontal graph lines
        self.drawHorizontialLines(context, rect: rect)
        
        // Step-6) The graph labels
        self.drawLabels(context, rect: rect)
    }
    
    // MARK: Helpers
    func getGradient() -> CGGradient
    {
        let colors = [startColor.CGColor, endColor.CGColor]
        let colorSpace = CGColorSpaceCreateDeviceRGB()  // all contexts have a color space
        let colorLocations: [CGFloat] = [0.0, 1.0]
        let gradient = CGGradientCreateWithColors(colorSpace, colors, colorLocations);
        
        return gradient;
    }
    
    // fill the whole of the view's context area
    func drawGradientBgView(context: CGContext)
    {
        // draw the gradient
        var startPoint = CGPoint.zeroPoint
        var endPoint = CGPoint(x: 0, y: self.bounds.height);
        CGContextDrawLinearGradient(context, self.getGradient(), startPoint, endPoint, 0);
    }
    
    /* Create paths to use as clipping areas instead of whole area
    
    Speed Note: Drawing static views Core Graphics is generally quick enough, but if your views move around or need frequent redrawing, you should use Core Animation layers. It’s optimized so that the GPU, handles most of the processing. In contrast, the CPU processes view drawing performed by drawRect(_:).
    
    Instead of using a clipping path, you can create rounded corners using the cornerRadius property of a CALayer, but you should optimize for your situation.
    */
    func drawClippingAreas(context: CGContext, rect: CGRect)
    {
        let width = rect.width, height = rect.height;
        
        // set up bg clipping area that constrains the gradient, and graph view have a nice, rounded corners
        var path = UIBezierPath(roundedRect: rect, byRoundingCorners: UIRectCorner.AllCorners,
                                cornerRadii: CGSize(width: 8.0, height: 8.0));
        path.addClip()
    }
    
    // Plot 7 points, the x-axis will be the "Day of Week" and the y-axis will be "Number of Glasses Drunk"
    func drawGraphLines(context: CGContext, rect: CGRect)
    {
        // The x-axis points consist of 7 equally spaced points. This is a closure expression. It could have been added as a function, but for small calculations like this, it's logical to keep them inline.
        var columnXpoint = { (column: Int) -> CGFloat in
            // calculate gap between points
            let gap = (rect.width - self.margin*2 - 4) / CGFloat(self.graphPoints.count - 1)
            var x: CGFloat = CGFloat(column) * gap
            x += self.margin + 2;
            return x;
        };
        
        // y-axis point, Because the origin is in the top-left corner and you draw a graph from an origin point in the bottom-left corner, columnYPoint adjusts its return value so that the graph is oriented as you would expect.
        let graphHeight = rect.height - topBorder - bottomBorder
        let maxValue = maxElement(graphPoints)
        var columnYpoint = { (graphPoint: Int) -> CGFloat in
            var y: CGFloat = CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight;
            y = graphHeight + self.topBorder - y     // Flip the graph
            return y
        };
        
        // draw the line path
        UIColor.whiteColor().setFill()
        UIColor.whiteColor().setStroke()
        
        var graphPath = UIBezierPath()
        graphPath.moveToPoint( CGPoint(x: columnXpoint(0),
                                       y: columnYpoint(graphPoints[0])) );
        // iterate
        for i in 1..<graphPoints.count {
            graphPath.addLineToPoint( CGPoint(x: columnXpoint(i),
                                              y: columnYpoint(graphPoints[i])) );
        }
        
        // graphPath.stroke()   // for check only
        
        // A Gradient Graph, create a gradient underneath this path by using the path as a clipping path.
        CGContextSaveGState(context)    // key point, Push the original graphics state onto the stack with CGContextSaveGState()
        
        var clippingPath = graphPath.copy() as! UIBezierPath
        
        // add lines to the copied path to complete the clip area
        clippingPath.addLineToPoint( CGPoint(x: columnXpoint(graphPoints.count - 1), y: rect.height) ); // bottom-right point
        clippingPath.addLineToPoint( CGPoint(x: columnXpoint(0), y: rect.height) );                     // bottom-left  point
        clippingPath.closePath();
        
        // add the clipping path to the context. When the context is filled, only the clipped path is actually filled.
        clippingPath.addClip()      // add the clipping path to a new graphics state
        
        /*/ check the clipping path - tmp code start
        UIColor.greenColor().setFill()
        let rectPath = UIBezierPath(rect: self.bounds)
        rectPath.fill()
        // end tmp code */
        
        // fill the clipping path with gradient color
        let highestYpoint = columnYpoint(maxValue)
        var startPoint: CGPoint = CGPoint(x: margin, y: highestYpoint)
        var endPoint: CGPoint = CGPoint(x: margin, y: self.bounds.height)
        CGContextDrawLinearGradient(context, self.getGradient(), startPoint, endPoint, 0);  // draw the gradient within the clipping path
        
        CGContextRestoreGState(context)     // key point, Restore the original graphics state with CGContextRestoreGState() — this was the state before you added the clipping path.
        
        graphPath.lineWidth = 2.0
        graphPath.stroke()
        
        //// Draw the circles on top of graph stroke, plot points
        for i in 0..<graphPoints.count
        {
            var point: CGPoint = CGPoint(x: columnXpoint(i), y: columnYpoint(graphPoints[i]));
            point.x -= (5.0/2)
            point.y -= (5.0/2)
            
            // fills a circle path for each of the elements in the array at the calculated x and y points
            let circle = UIBezierPath(ovalInRect: CGRect(origin: point, size: CGSize(width: 5.0, height: 5.0)))
            circle.fill()
        }
        
    }//EndFunc
    
    //
    func drawCircleForPoint(context: CGContext, rect: CGRect)
    {
        
        
    }
    
    func drawHorizontialLines(context: CGContext, rect: CGRect)
    {
        let graphHeight = rect.height - topBorder - bottomBorder
        
        var linePath = UIBezierPath();
        
        // top line
        linePath.moveToPoint(CGPoint(x: self.margin, y: self.topBorder))
        linePath.addLineToPoint(CGPoint(x: rect.width - margin, y: self.topBorder))
        
        // center line
        linePath.moveToPoint(CGPoint(x: self.margin, y: graphHeight/2 + topBorder))
        linePath.addLineToPoint(CGPoint(x: rect.width - margin, y: graphHeight/2 + topBorder))
        
        // bottom line
        linePath.moveToPoint(CGPoint(x: self.margin, y: rect.height - bottomBorder))
        linePath.addLineToPoint(CGPoint(x: rect.width - margin, y: rect.height - bottomBorder))
        
        let lineColor = UIColor(white: 1.0, alpha: 0.3)
        lineColor.setStroke()
        
        linePath.lineWidth = 1.0
        linePath.stroke()
    }
    
    func drawLabels(context: CGContext, rect: CGRect)
    {
        
        
        
        
    }

}//EndClass
