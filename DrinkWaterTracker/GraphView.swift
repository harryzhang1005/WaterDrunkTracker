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
    // for gradient color
    @IBInspectable var startColor: UIColor = UIColor.red
    @IBInspectable var endColor: UIColor = UIColor.green

    let margin: CGFloat = 20.0
    let topBorder: CGFloat = 60, bottomBorder: CGFloat = 50;
    var graphPoints: [Int] = [5, 4, 2, 6, 5, 8, 3]; // initial sample data for a week, current day's number will be alter by counter view
    
    @IBOutlet weak var avgCupDrunkLabel: UILabel!
    @IBOutlet weak var maxCupDrunkLabel: UILabel!
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect)
    {
        // Drawing Code
        let context = UIGraphicsGetCurrentContext()
        
        // Step-1) Create paths to use as clipping areas instead of whole area
        self.drawClippingAreas(context!, rect: rect);
        
        // Step-2) Gradient background view
        self.drawGradientBgView(context!);
        
        // Step-3) The graph line
        self.drawGraphLines(context!, rect: rect)
        
        // Step-4) The circles for the graph points
        self.drawCircleForPoint(context!, rect: rect)
        
        // Step-5) Horizontal graph lines
        self.drawHorizontialLines(context!, rect: rect)
        
        // Step-6) The graph labels
        self.drawLabels(context!, rect: rect)
    }
    
    // MARK: Helpers
    func getGradient() -> CGGradient
    {
        let colors = [startColor.cgColor, endColor.cgColor]
        let colorSpace = CGColorSpaceCreateDeviceRGB()  // all contexts have a color space
        let colorLocations: [CGFloat] = [0.0, 1.0]
        
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: colorLocations);
        return gradient!;
    }
    
    func getXpoint(_ rect: CGRect) -> (Int) -> CGFloat
    {
        // The x-axis points consist of 7 equally spaced points. This is a closure expression. It could have been added as a function, but for small calculations like this, it's logical to keep them inline. columnXPoint is Function Type of (Int) -> CGFloat
        let columnXpoint = { (column: Int) -> CGFloat in
            // calculate gap between points
            let gap = (rect.width - self.margin*2 - 4) / CGFloat(self.graphPoints.count - 1)
            var x: CGFloat = CGFloat(column) * gap
            x += self.margin + 2;
            return x;
        };
        
        return columnXpoint;
    }
    
    func getYpoint(_ rect: CGRect) -> (Int) -> CGFloat
    {
        // y-axis point, Because the origin is in the top-left corner and you draw a graph from an origin point in the bottom-left corner, columnYPoint adjusts its return value so that the graph is oriented as you would expect.
        let graphHeight = rect.height - topBorder - bottomBorder
        let maxValue = graphPoints.max()!
        
        let columnYpoint = { (graphPoint: Int) -> CGFloat in
            var y: CGFloat = CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight;
            y = graphHeight + self.topBorder - y     // Key point: Flip y-axis, magic
            return y
        };
        
        return columnYpoint;
    }
    
    /* Step-1) Create paths to use as clipping areas instead of whole area
    
    Speed Note: Drawing static views Core Graphics is generally quick enough, but if your views move around or need frequent redrawing, you should use Core Animation layers. It’s optimized so that the GPU, handles most of the processing.
    In contrast, the CPU processes view drawing performed by drawRect(_:).
    
    Instead of using a clipping path, you can create rounded corners using the cornerRadius property of a CALayer, but you should optimize for your situation.
    */
    func drawClippingAreas(_ context: CGContext, rect: CGRect)
    {
        //let width = rect.width, height = rect.height;
        
        // set up bg clipping area that constrains the gradient, and graph view have a nice, rounded corners
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: UIRectCorner.allCorners,
            cornerRadii: CGSize(width: 8.0, height: 8.0));
        path.addClip()
    }
    
    // Step-2) Gradient background view, only fill the Step-1 clipping area
    func drawGradientBgView(_ context: CGContext)
    {
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: 0, y: self.bounds.height);
		context.drawLinearGradient(self.getGradient(), start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: 0))
    }
    
    // Step-3) The graph line
    // Plot 7 points, the x-axis will be the "Day of Week" and the y-axis will be "Number of Glasses Drunk"
    func drawGraphLines(_ context: CGContext, rect: CGRect)
    {
        let columnXpoint = self.getXpoint(rect)
        let columnYpoint = self.getYpoint(rect)
        let maxValue = graphPoints.max()!
        
        // Find the graph points and draw graph lines
        UIColor.white.setFill()
        UIColor.white.setStroke()
        
        let graphPath = UIBezierPath()
        graphPath.move( to: CGPoint(x: columnXpoint(0), y: columnYpoint(graphPoints[0])) );
        
        for i in 1..<graphPoints.count {    // a week (1-7)
            graphPath.addLine( to: CGPoint(x: columnXpoint(i), y: columnYpoint(graphPoints[i]) ) );
        }
        
        //Opt start: Create a gradient underneath this path by using the path as a clipping path
        context.saveGState()    // key point, Push the original graphics state onto the stack with CGContextSaveGState()
        
        let clippingPath = graphPath.copy() as! UIBezierPath
        clippingPath.addLine( to: CGPoint(x: columnXpoint(graphPoints.count - 1), y: rect.height) ); // bottom-right point
        clippingPath.addLine( to: CGPoint(x: columnXpoint(0), y: rect.height) );                     // bottom-left  point
        clippingPath.close(); // Key point: add lines to the copied path to complete the clip area
        
        // add the clipping path to the context. When the context is filled, only the clipped path is actually filled.
        clippingPath.addClip()      // add the clipping path to a new graphics state
        
        // fill the clipping path with gradient color
        let highestYpoint = columnYpoint(maxValue)
        let startPoint: CGPoint = CGPoint(x: margin, y: highestYpoint)
        let endPoint: CGPoint = CGPoint(x: margin, y: self.bounds.height)
        context.drawLinearGradient(self.getGradient(), start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: 0));  // draw the gradient within the clipping path
        
        context.restoreGState() // Restore the original graphics state — this was the state before you added the clipping path
        //Opt end
        
        graphPath.lineWidth = 2.0; graphPath.stroke(); // finally draw graph lines
        
    }//EndFunc
    
    // Step-4) The circles for the graph points
    func drawCircleForPoint(_ context: CGContext, rect: CGRect)
    {
        let columnXpoint = self.getXpoint(rect)
        let columnYpoint = self.getYpoint(rect)
        
        // Draw the circles on top of graph stroke, plot points
        for i in 0..<graphPoints.count
        {
            var point: CGPoint = CGPoint(x: columnXpoint(i), y: columnYpoint(graphPoints[i]));
            point.x -= (5.0/2); point.y -= (5.0/2);
            
            // fills a circle path for each of the elements in the array at the calculated x and y points
            let circle = UIBezierPath(ovalIn: CGRect(origin: point, size: CGSize(width: 5.0, height: 5.0)))
            circle.fill()
        }
    }
    
    // Step-5) Horizontal graph lines
    func drawHorizontialLines(_ context: CGContext, rect: CGRect)
    {
        let graphHeight = rect.height - topBorder - bottomBorder
        
        let hLinePath = UIBezierPath();
        
        // top line
        hLinePath.move(to: CGPoint(x: self.margin, y: self.topBorder))
        hLinePath.addLine(to: CGPoint(x: rect.width - margin, y: self.topBorder))
        
        // center line
        hLinePath.move(to: CGPoint(x: self.margin, y: graphHeight/2 + topBorder))
        hLinePath.addLine(to: CGPoint(x: rect.width - margin, y: graphHeight/2 + topBorder))
        
        // bottom line
        hLinePath.move(to: CGPoint(x: self.margin, y: rect.height - bottomBorder))
        hLinePath.addLine(to: CGPoint(x: rect.width - margin, y: rect.height - bottomBorder))
        
        let lineColor = UIColor(white: 1.0, alpha: 0.3)
        lineColor.setStroke()
        
        hLinePath.lineWidth = 1.0
        hLinePath.stroke()
    }
    
    // Step-6) The graph labels
    func drawLabels(_ context: CGContext, rect: CGRect)
    {
        // 1. update max and avg water drunk label
        self.maxCupDrunkLabel.text = "\((self.graphPoints).max() ?? 8)"
        self.avgCupDrunkLabel.text = "\(self.graphPoints.reduce(0, +) / self.graphPoints.count)"
        
        // 2. set up lay of week labels with tags, today is the last day of the array need to go backwards
        // put the current day's number from the iOS calendar into the property weekday
        //let dateFormatter = NSDateFormatter()
        let componentOptions: NSCalendar.Unit = NSCalendar.Unit.weekday
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components(componentOptions, from: Date())
        var weekday = components.weekday    // current day of the week
        
        let days = ["S", "S", "M", "T", "W", "T", "F"]
        
        // 3. set up the day name labels with corrent day
        for i in (1...days.count).reversed()    // from 7 to 1
        {
            if let aLabel = self.viewWithTag(i) as? UILabel
            {
                if weekday == 7 { weekday = 0; }
				
                aLabel.text = days[(weekday)!]
				weekday = weekday! - 1
                
                if weekday! < 0 { weekday = days.count - 1; }
            }
        }//EndFor
    }

}//EndClass
