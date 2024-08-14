//
//  createNewReminderView.swift
//  Reminder
//
//  Created by Carter Hawkins on 8/8/24.
//

import SwiftUI

struct createNewReminderView: View {
    @Environment(LocalNotificationManager.self) var lnManager
    @Environment(\.dismiss) var dismiss
    
    var isValidReminder: Bool {
        !name.isEmpty && due > Date.now ? true : false
    }
    
   
    
    @Environment(\.modelContext) var modelContext
    @State private var name = ""
    @State private var due = Date.now.addingTimeInterval(3600)
    var body: some View {
        @Bindable var lnManager: LocalNotificationManager = lnManager
        NavigationStack {
            Form {
                Section("name") {
                    TextField("type here...", text: $name)
                }
                
                
                Section("due") {
                    DatePicker("Select Due Date", selection: $due, in: Date.now.addingTimeInterval(60)...)
                }
                
                Button("Add New Reminder") {
                    if isValidReminder {
                        let newReminder = Reminder(id: UUID().uuidString, name: name, due: due)
                        modelContext.insert(newReminder)
                        
                        Task {
                            
                            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: newReminder.due)
                            
                            let localNotification = LocalNotification(identifier: newReminder.id, categoryIdentifier: "reminderNotification", title: newReminder.name, userInfo: ["nextView" : newReminder.id], body: newReminder.notes, dateComponents: dateComponents, repeats: false)
                            
                            await lnManager.schedule(localNotification: localNotification)
                            
                        }
                        dismiss()
                    }
                }
                .disabled(isValidReminder ? false : true)
                
            }
            .navigationTitle("New Reminder")
        }
    }
}

#Preview {
    createNewReminderView()
}
