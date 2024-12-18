//
//  generateSpacedReminders.swift
//  Task Forge
//
//  Created by Carter Hawkins on 8/29/24.
//

import Foundation

struct generateSpacedReminders {
    var task: TaskObject
    var timePeriod: Int
    func generate(number: Int, timePeriod: Int) -> [Reminder] {
        var days: [Date] = []
        
        let daysBetween = Double(timePeriod) / Double(number)
        
        let dayOfDue = Calendar.current.startOfDay(for: task.due)
        
        let dayBefore = dayOfDue.addingTimeInterval(-32400)
        days.append(dayBefore)
        
        if number > 1 {
            for num in 1...(number - 1) {
                let daysBetweenLocal = Double(num) * daysBetween
                
                let newDate = dayBefore.addingTimeInterval(-daysBetweenLocal.rounded(.down) * 86400)
                days.append(newDate)
            }
        }
        
        var remindersStore: [Reminder] = []
        
        for ReminderDate in days {
            let newReminder = Reminder(id: UUID().uuidString, name: "Work on \(task.name)", due: ReminderDate)
            remindersStore.append(newReminder)
        }
        
        
        return remindersStore
    }
    
    init(task: TaskObject) {
        self.task = task
        self.timePeriod = Calendar.current.dateComponents([.day], from: Date.now, to: task.due).day ?? 0
    }
    
    func defaultSessions() -> Int {
        switch timePeriod {
        case ...4:
            return 1
        case 5...8:
            return 2
        case 9...12:
            return 3
        case 13...:
            return 4
        default:
            return 0
        }
    }
    
}


