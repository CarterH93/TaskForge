//
//  createNewTaskView.swift
//  Reminder
//
//  Created by Carter Hawkins on 8/8/24.
//

import SwiftUI


struct createNewTaskView: View {
    @Environment(\.dismiss) var dismiss
    
    var isValidTask: Bool {
        !name.isEmpty && due > Date.now ? true : false
    }
    
    @Environment(\.modelContext) var modelContext
    @Environment(Settings.self) var settings
    @State private var name = ""
    @State private var description = ""
    @State private var due = Date.now.addingTimeInterval(3600)
    
    var body: some View {
        NavigationStack {
            Form {
                Section("name") {
                    TextField("type here...", text: $name)
                }
                
                Section("description") {
                    TextField("type here...", text: $description)
                }
                
                Section("due") {
                    DatePicker("Select Due Date", selection: $due, in: Date.now.addingTimeInterval(60)...)
                }
                
                
                
                
                Button("Add New Task") {
                    if isValidTask {
                        let newTask = TaskObject(oldid: UUID().uuidString, name: name, info: description, due: due, inAppGenerated: true)
                        newTask.reminders.append(Reminder(id: UUID().uuidString, name: "Work on \(newTask.name)", due: due.addingTimeInterval(-settings.defaultReminder)))
                        modelContext.insert(newTask)
                        
                        dismiss()
                    }
                }
                .disabled(isValidTask ? false : true)
                
            }
            .navigationTitle("New Task")
            
        }
    }
}

#Preview {
    NavigationStack {
        createNewTaskView()
    }
    
}
