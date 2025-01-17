//
//  DeepBreathsViewController.swift
//  Caramel
//
//  Created by James Sun on 2014-11-02.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit
import AudioToolbox

class DeepBreathsViewController: PortraitViewController {

    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var bubbleLabel: UILabel!
    @IBOutlet weak var breathLabel: UILabel!
    
    var bubbleCounter = 1
    var shrinkingDelay = 0.0
    var breathOutCounter = 0
    var nextVCID = ""
    var startedAnimation = false
    var moved = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bubbleLabel.text = String(bubbleCounter)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if !self.startedAnimation {
            self.startedAnimation = true
            self.bubbleCallback()
        }
    }
    
    @IBAction func skipButtonDidPress(sender: AnyObject) {
        self.moved = true
        self.breathLabel.text = "Great! You are now focused."
        self.moveToNextVC()
    }
    
    func setNext(id: String) {
        self.nextVCID = id
    }
    
    private func bubbleCallback() -> Void {
        UIView.animateWithDuration(
            3,
            delay: self.shrinkingDelay,
            options: nil,
            animations: {
                if self.breathOutCounter % 2 == 0 {
                    self.breathLabel.text = "Breath Out"
                }
                else {
                    self.breathLabel.text = "Breath In"
                }
                self.breathOutCounter += 1
                self.bubbleView.transform = CGAffineTransformMakeScale(0.5, 0.5)
                if !self.moved {
                    self.vibratePhone()
                }
            }, completion: {
                finished in UIView.animateWithDuration(
                    3,
                    delay: 1,
                    options: .AllowUserInteraction,
                    animations: {
                        if self.breathOutCounter % 2 == 0 {
                            self.breathLabel.text = "Breath Out"
                        }
                        else {
                            self.breathLabel.text = "Breath In"
                        }
                        self.breathOutCounter += 1
                        self.bubbleView.transform = CGAffineTransformMakeScale(1.0, 1.0)
                        if !self.moved {
                            self.vibratePhone()
                        }
                    }, completion: {finished in
                        if self.bubbleCounter < 3 {
                            self.shrinkingDelay = 1.0
                            self.bubbleCounter++
                            self.bubbleLabel.text = String(self.bubbleCounter)
                            self.bubbleCallback()
                        }
                        else {
                            UIView.animateWithDuration(3, animations: {
                                self.breathLabel.text = "Great! You are now focused."
                                if !self.moved {
                                    self.moved = true
                                    self.moveToNextVC()
                                }
                            })
                        }
                    }
                )
            }
        )
    }
    
    private func vibratePhone() {
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    private func moveToNextVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let actionsVC = storyboard.instantiateViewControllerWithIdentifier(nextVCID) as UIViewController
        self.navigationController?.pushViewController(actionsVC, animated: true)
    }
}
