//
//  createNewTaskView.swift
//  Reminder
//
//  Created by Carter Hawkins on 8/8/24.
//

import SwiftUI
import SwiftData


struct createNewTaskView: View {
    @Environment(\.dismiss) var dismiss
    
    var isValidTask: Bool {
        !name.isEmpty && due > Date.now ? true : false
    }
    
    @Environment(\.modelContext) var modelContext
    
    @Query(
        sort: \Settings1.Date1
    ) var settings: [Settings1]
    
    @State private var name = ""
    @State private var notes = ""
    @State private var due = Date.now.addingTimeInterval(3600)
    
    var body: some View {
            Form {
                Section("name") {
                    TextField("type here...", text: $name)
                }
                
                Section("due") {
                    DatePicker("Select Due Date", selection: $due, in: Date.now.addingTimeInterval(60)...)
                }
                
                Section("notes") {
                    TextField("type here...", text: $notes)
                }
                
                
                
                
                
                
                Button("Add New Task") {
                    if isValidTask {
                        let newTask = TaskObject(oldid: UUID().uuidString, name: name, due: due, inAppGenerated: true, notes: notes)
                        newTask.reminders = [Reminder(id: UUID().uuidString, name: "Work on \(newTask.name)", due: due.addingTimeInterval(-settings.first!.defaultReminderWrapper))]
                        modelContext.insert(newTask)
                        
                        dismiss()
                    }
                }
                .disabled(isValidTask ? false : true)
                
            }
            .navigationTitle("New Task")
            
        }
    }

#Preview {
    NavigationStack {
        createNewTaskView()
    }
    
}
