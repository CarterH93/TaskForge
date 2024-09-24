//
//  More.swift
//  Reminder
//
//  Created by Carter Hawkins on 8/12/24.
//

import SwiftUI
import SwiftData

struct More: View {
    
    @Query(
        sort: \Settings1.Date1
    ) var settings: [Settings1]
    
    var body: some View {
        
        NavigationStack {
            List {
                EnableNotifications()
                Section("Syncing") {
                    NavigationLink("Add Canvas or Calendar Connection") {
                        syncing()
                    }
                }
                .headerProminence(.increased)
                
                Section("Default Reminder creation") {
                    stepperDefaultReminder(settings: settings.first ?? Settings1())
                }
                .headerProminence(.increased)
                
            }
            .navigationTitle("More")
        }
    }
}

struct stepperDefaultReminder: View {
    
    @State var settings: Settings1
    
    var body: some View {
        Stepper("Remind \(settings.defaultReminder) \(settings.defaultReminder == 1 ? "day" : "days") before task due", value: $settings.defaultReminder, in: 0...30)
        
    }
}
