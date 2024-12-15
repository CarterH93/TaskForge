//
//  Settings.swift
//  Reminder
//
//  Created by Carter Hawkins on 8/11/24.
//

import Foundation
import SwiftData

@Model
class Settings1 {
    var defaultReminder: Int
    var Date1: Date = Date.now
    
    var defaultReminderWrapper: Double {
        (Double(self.defaultReminder) * 86400) + 32340
    }
    
    var icsSources: [URL] = [URL(string: "google.com")!]
    
    var remindersThatNeedUIUpdate = Set<String>()
    //Inorder to change default reminder time you need to delete icloud data
    init(defaultReminder: Int = 3 , icsSources: [URL] = []) {
        self.defaultReminder = defaultReminder
        self.icsSources = icsSources
     
    }
}
