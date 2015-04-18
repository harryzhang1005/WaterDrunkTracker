//
//  ViewController.swift
//  DrinkWaterTracker
//
//  Created by Harvey Zhang on 4/16/15.
//  Copyright (c) 2015 HappyGuy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // A container view to make an animated transition between the Conter view and Graph view
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var counterView: CounterView!
    @IBOutlet weak var graphView: GraphView!
    
    var isGraphViewShowing: Bool = false
    let kNumOfDays: Int = 7
    
    @IBOutlet weak var addOneCupBtn: PushButton!
    @IBOutlet weak var minOneCupBtn: PushButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.updateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateUI()
    {
        counterView.drunkCups.text = String(counterView.counter);
        //counterView.setNeedsDisplay() // // Redraw Way-1
        
        if counterView.counter >= NumOfGlasses {
            counterView.medalView.showMedal(true)
        } else {
            counterView.medalView.showMedal(false)
        }
    }
    
    @IBAction func pushBtnTapped(sender: PushButton)
    {
        if sender.isAddButton   // plus button
        {
            if counterView.counter < NumOfGlasses {
                counterView.counter++;
            }
        }
        else { // minus button
            if counterView.counter > 0 {
                counterView.counter--;
            }
        }
        
        self.updateUI();
        
        // make sure on Counter view
        if isGraphViewShowing {
            counterViewTapped(nil)
        }
    }
    
    // Toggle to Graph view
    @IBAction func counterViewTapped(gesture: UITapGestureRecognizer?)
    {
        if isGraphViewShowing {
            // switch to Counter view
            UIView.transitionFromView(graphView, toView: counterView, duration: 1.0,
                options: UIViewAnimationOptions.TransitionFlipFromLeft | UIViewAnimationOptions.ShowHideTransitionViews,
                completion: nil)
        }
        else { // switch to Graph view
            UIView.transitionFromView(counterView, toView: graphView, duration: 1.0,
                options: UIViewAnimationOptions.TransitionFlipFromRight | UIViewAnimationOptions.ShowHideTransitionViews,
                completion: nil)
            
            self.setupGraphDisplay()
        }
        
        isGraphViewShowing = !isGraphViewShowing
    }
    
    // set up Graph view labels
    func setupGraphDisplay()
    {
        // 1. replace last day with today's actual data
        graphView.graphPoints[graphView.graphPoints.count - 1] = counterView.counter;
        
        // 2. notify graph redrawn
        graphView.setNeedsDisplay()
        
        // 3. update max and avg water drunk label
        graphView.maxCupDrunkLabel.text = "\(maxElement(graphView.graphPoints))"
        graphView.avgCupDrunkLabel.text = "\(graphView.graphPoints.reduce(0, combine: +) / graphView.graphPoints.count)"
        
        // 4. set up lay of week labels with tags, today is the last day of the array need to go backwards
        // put the current day's number from the iOS calendar into the property weekday
        //let dateFormatter = NSDateFormatter()
        let componentOptions: NSCalendarUnit = .CalendarUnitWeekday
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(componentOptions, fromDate: NSDate())
        var weekday = components.weekday    // current day of the week
        
        let days = ["S", "S", "M", "T", "W", "T", "F"]
        
        // 5. set up the day name labels with corrent day
        for i in reverse(1...days.count)    // from 7 to 1
        {
            if let aLabel = graphView.viewWithTag(i) as? UILabel
            {
                if weekday == 7 { weekday = 0; }
                
                aLabel.text = days[weekday--]
                
                if weekday < 0 { weekday = days.count - 1; }
            }
        }//EndFor
        
    }//EndFunc
    
    
    
    
    
    
    
}//EndClass

