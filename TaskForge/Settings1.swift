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
        defaultSpacedRemindersEnabled = false //Not using automatic spaced reminders because not that useful.
        defaultSpacedRemindersTimeSpan = 14
        defaultSpacedRemindersSessions = 2
        defaultReminderTime = Calendar.current.date(from: {
            var comps = Calendar.current.dateComponents([.year, .month, .day], from: Date())
            comps.hour = 15 // 3pm
            comps.minute = 0
            return comps
        }())!
    }
    
    var showCompleted = false
    
    var showOnlyToday = false
    
    var defaultReminder: Int = 2
    var defaultReminderEnabled = true
    var Date1: Date = Date.now
    var defaultReminderTime: Date = Calendar.current.date(from: {
        var comps = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        comps.hour = 15 // 3pm
        comps.minute = 0
        return comps
    }())!
    
    var defaultReminderTimeHour: Int {
        return Calendar.current.component(.hour, from: defaultReminderTime)
    }
    
    var defaultReminderTimeMinute: Int {
        return Calendar.current.component(.minute, from: defaultReminderTime)
    }
    
    
    var defaultSpacedRemindersEnabled = false //Not using automatic spaced reminders because not that useful.
    var defaultSpacedRemindersTimeSpan = 14
    var defaultSpacedRemindersSessions = 2
    
    func calcNewDefaultReminderDateTime(taskDue: Date) -> Date {
        // Subtract days from the due date
            guard let reminderDay = Calendar.current.date(byAdding: .day, value: -defaultReminder, to: taskDue) else {
                return taskDue // fallback if subtraction fails
            }

            // Extract year, month, day from the reminderDay
            var components = Calendar.current.dateComponents([.year, .month, .day], from: reminderDay)
            components.hour = defaultReminderTimeHour
            components.minute = defaultReminderTimeMinute

            // Create the final reminder date
            return Calendar.current.date(from: components) ?? reminderDay
    }
    
    var icsSources: [URL] = [URL(string: "google.com")!]
    
    var remindersThatNeedUIUpdate = Set<String>()
    //Inorder to change default reminder time you need to delete icloud data
    init(defaultReminder: Int = 2 , icsSources: [URL] = []) {
        self.defaultReminder = defaultReminder
        self.icsSources = icsSources
     
    }
}
