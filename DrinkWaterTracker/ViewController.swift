//
//  ViewController.swift
//  DrinkWaterTracker
//
//  Created by Harvey Zhang on 4/16/15.
//  Copyright (c) 2015 HappyGuy. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{    
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
        // 1. replace last day's data with today's actual data
        graphView.graphPoints[graphView.graphPoints.count - 1] = counterView.counter;
        
        // 2. notify graph redrawn
        graphView.setNeedsDisplay()
    }
    
    
}//EndClass

