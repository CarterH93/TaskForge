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
    var defaultReminder: Double = 0
    var Date1: Date = Date.now
    
    var icsSources: [URL] = [URL(string: "google.com")!]
    
    var remindersThatNeedUIUpdate = Set<String>()
    
    init(defaultReminder: Double = 118800, icsSources: [URL] = []) {
        self.defaultReminder = defaultReminder
        self.icsSources = icsSources
     
    }
}
