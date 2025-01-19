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
    func resetToDefaultSettings() {
        defaultReminder = 2
        defaultReminderEnabled = true
        defaultSpacedRemindersEnabled = true
        defaultSpacedRemindersTimeSpan = 14
        defaultSpacedRemindersSessions = 2
    }
    
    var showCompleted = false
    
    var showOnlyToday = false
    
    var defaultReminder: Int = 2
    var defaultReminderEnabled = true
    var Date1: Date = Date.now
    
    var defaultSpacedRemindersEnabled = true
    var defaultSpacedRemindersTimeSpan = 14
    var defaultSpacedRemindersSessions = 2
    
    var defaultReminderWrapper: Double {
        (Double(self.defaultReminder) * 86400) + 32340
    }
    
    var icsSources: [URL] = [URL(string: "google.com")!]
    
    var remindersThatNeedUIUpdate = Set<String>()
    //Inorder to change default reminder time you need to delete icloud data
    init(defaultReminder: Int = 2 , icsSources: [URL] = []) {
        self.defaultReminder = defaultReminder
        self.icsSources = icsSources
     
    }
}
