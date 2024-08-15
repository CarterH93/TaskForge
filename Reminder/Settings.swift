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
    var defaultReminder: Double
    
    var icsSources: [URL]
    
    var remindersThatNeedUIUpdate = Set<String>()
    
    init(defaultReminder: Double = 118800, icsSources: [URL] = []) {
        self.defaultReminder = defaultReminder
        self.icsSources = icsSources
    }
}
