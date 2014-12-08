//
//  AlarmSettingView.swift
//  BeyondStress
//
//  Created by Shine Wang on 2014-12-08.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit

class AlarmSettingView: UITableViewCell {
    
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    private let TAG = "AlarmSettingView"
    
    private let keys = ["Repeat", "Label"]
    private var key = ""
    private var date: AlarmDate!
    private var descriptionText: String!
    private let prefix = "Every "
    private let suffixes = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    private let short = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    func setKeyDateLabel(key: String, defaultDate: AlarmDate?, defaultLabel: String?) {
        self.key = key
        self.date = defaultDate
        self.descriptionText = defaultLabel
        self.updateView()
    }
    
    func setDate(date: AlarmDate) {
        self.date = date
        self.updateView()
    }
    
    func updateView() {
        if self.key == self.keys[0] {
            let dateText = self.dateAsText()
            dispatch_async(dispatch_get_main_queue(), {
                self.keyLabel.text = self.key
                self.valueLabel.text = dateText
            })
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                self.keyLabel.text = self.key
                self.valueLabel.text = self.descriptionText
            })
        }
    }
    
    func dateAsText() -> String {
        if !self.date.hasAny() {
            return "Never"
        }
        if self.date.count() == 7 {
            return "Every day"
        }
        
        if self.date.count() == 1 {
            for i in 0 ..< DayOfWeek.allValues.count {
                if self.date.contains(DayOfWeek.allValues[i]) {
                    return self.prefix + self.suffixes[i]
                }
            }
        }
        var total = ""
        for i in 0 ..< DayOfWeek.allValues.count {
            if self.date.contains(DayOfWeek.allValues[i]) {
                if total != "" {
                    total += " "
                }
                total += self.short[i]
            }
        }
        return total
    }
}