//
//  ListViewDateFormatter.swift
//  Task Forge
//
//  Created by Carter Hawkins on 12/26/24.
//

import Foundation

struct ListViewDateFormatter {
    
    //Change this to change max day shown in list view
   static let maxDayValue = 8
    
    static func maxDayRange(_ settings: Settings1) -> Int {
        if settings.showOnlyToday {
            return 0
        } else {
            return maxDayValue
        }
    }
    
   static func dateBasedOnNum(_ num: Int) -> Date {
        if num < 0 {
            return Calendar.current.startOfDay(for: Date.now)
        }
        return Calendar.current.startOfDay(for: Date.now.addingTimeInterval(Double(num * 86400)))
    }
    
    
    static func formatDateBasedOnNum(num: Int, maxDayRange: Int) -> String {
        
        let date = dateBasedOnNum(num)
        
        if num < 0 {
            return "Over Due"
        }
        
        if Calendar.current.isDate(date, inSameDayAs: Date.now) {
            return "Today"
        }
        
        if Calendar.current.isDate(date, inSameDayAs: Date.now.addingTimeInterval(86400)) {
            return "Tomorrow"
        }
        
        if num >= maxDayRange {
            return "Later"
        }
        
        
        return date.formatted(.dateTime.weekday().day().month())
        
    }
}
