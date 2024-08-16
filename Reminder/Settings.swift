//
//  Settings.swift
//  Reminder
//
//  Created by Carter Hawkins on 8/11/24.
//

import Foundation
import SwiftData

@Model
class Settings {
    var defaultReminder: Double = 0
    
    var icsSources: [URL] = [URL(string: "google.com")!]
    
    var remindersThatNeedUIUpdate = Set<String>()
    
    init(defaultReminder: Double = 118800, icsSources: [URL] = []) {
        self.defaultReminder = defaultReminder
        self.icsSources = icsSources
    }
}
