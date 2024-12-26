//
//  ReminderFilter.swift
//  Task Forge
//
//  Created by Carter Hawkins on 12/26/24.
//

import Foundation

struct ReminderFilter {
    
    static func filterReminders(_ reminders: [Reminder]) -> [Reminder] {
        reminders.filter { $0.due > Date.now && $0.isCompleted == false && $0.task?.deleted1 ?? false == false }
    }
}
