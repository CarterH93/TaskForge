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
    
    @State private var showingAlert = false
    
    var body: some View {
        
            List {
                
                    SuggestedActions(settings: settings.first ?? Settings1())
                
                Section("Resources") {
                    Link(destination: URL(string: "http://feedback.taskforgeapp.com/")!) {
                        HStack {
                            Image(systemName: "bubble.left.and.text.bubble.right")
                            Text("Feedback")
                        }
                    }
                    
                    Link(destination: URL(string: "https://guide.taskforgeapp.com/")!) {
                        HStack {
                            Image(systemName: "book.pages")
                            Text("Guide")
                        }
                        
                    }
                    
                    Link(destination: URL(string: "https://guide.taskforgeapp.com/privacy-policy")!) {
                        HStack {
                            Image(systemName: "lock")
                            Text("Privacy Policy")
                        }
                    }
                    
                    Link(destination: URL(string: "https://taskforgeapp.com/")!) {
                        HStack {
                            Image(systemName: "globe")
                            Text("Website")
                        }
                        
                    }
                }
                .headerProminence(.increased)
                
                Section("Syncing") {
                    NavigationLink("Add Canvas or Calendar Connection") {
                        syncing()
                    }
                }
                .headerProminence(.increased)
                
                Section("Default Reminder Creation") {
                    stepperDefaultReminder(settings: settings.first ?? Settings1())
                }
                .headerProminence(.increased)
                
                Section("Spaced Reminders") {
                        SpacedReminderSettings(settings: settings.first ?? Settings1())
                }
                .headerProminence(.increased)
                
                Section("Default Settings") {
                    Button("Reset to Default Settings", role: .destructive) {
                        showingAlert = true
                    }
                }
                .headerProminence(.increased)
                
            }
            .navigationTitle("More")
            .alert("Are you sure you want to reset back to default settings?", isPresented: $showingAlert) {
                resetToDefaultSettings(settings: settings.first ?? Settings1())
                    }
        }
    }

struct resetToDefaultSettings: View {
    @State var settings: Settings1
    
    var body: some View {
        Button("Reset", role: .destructive) {
            settings.resetToDefaultSettings()
        }
        
        
    }
}

struct stepperDefaultReminder: View {
    
    @State var settings: Settings1
    
    var body: some View {
        Stepper("Remind \(settings.defaultReminder) \(settings.defaultReminder == 1 ? "Day" : "Days") Before Task Due", value: $settings.defaultReminder, in: 0...28)
        
    }
}


struct SpacedReminderSettings: View {
    
    @State var settings: Settings1
    
    
    
    var body: some View {
        
        Toggle("Automatic Default Spaced Reminders Creation", isOn: $settings.defaultSpacedRemindersEnabled)

            Picker("Max Default Time Span", selection: $settings.defaultSpacedRemindersTimeSpan) {
                ForEach(1...28, id: \.self) {
                    if $0 == 1 {
                        Text("1 day")
                    } else {
                        Text("\($0) days")
                    }
                }
            }
        
        
        
            Picker("Max Default Number of Reminders", selection: $settings.defaultSpacedRemindersSessions) {
                ForEach(1...10, id: \.self) {
                    Text(String($0))
                }
            }
            
        
    }
}
