//
//  createNewTaskView.swift
//  Reminder
//
//  Created by Carter Hawkins on 8/8/24.
//

import SwiftUI

struct newReminderSubView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var reminders: [Reminder]
    @State private var newReminderDue = Date.now
    @State private var newReminderName: String
    init(reminders: Binding<[Reminder]>, taskName: String) {
        self._reminders = reminders
        self.taskName = taskName
        _newReminderName = State(initialValue: "Work on \(taskName)")
    }
    
    var taskName: String
    var body: some View {
        VStack {
            TextField("type here...", text: $newReminderName)
            DatePicker("Remind", selection: $newReminderDue)
                .padding()
            Button("Add New Reminder") {
                reminders.append(Reminder(id: UUID().uuidString, name: newReminderName, due: newReminderDue))
                dismiss()
            }
        }
        .padding()
    }
}

struct createNewTaskView: View {
    @Environment(\.dismiss) var dismiss
    
    var isValidTask: Bool {
        !name.isEmpty && due > Date.now ? true : false
    }
    
    @Environment(\.modelContext) var modelContext
    @State private var name = ""
    @State private var description = ""
    @State private var due = Date.now.addingTimeInterval(3600)
    
    @State private var reminders: [Reminder] = []
    
    @State private var showingNewReminderSheet = false
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
                
                Section("Reminders") {
                    
                    List(reminders) { reminder in
                        HStack {
                            Text(reminder.name)
                            Text(reminder.due.formatted())
                        }
                    }
                    Button("Create New Reminder") {
                        showingNewReminderSheet = true
                    }
                    .disabled(name.isEmpty ? true : false)
                }
                
                
                Button("Add New Task") {
                    if isValidTask {
                        let newTask = Task(oldid: UUID().uuidString, name: name, info: description, due: due, inAppGenerated: true)
                        modelContext.insert(newTask)
                        do {
                            try modelContext.save()
                        } catch {
                            
                        }
                        dismiss()
                    }
                }
                .disabled(isValidTask ? false : true)
                
            }
            .navigationTitle("New Task")
            .sheet(isPresented: $showingNewReminderSheet) {
                newReminderSubView(reminders: $reminders, taskName: name)
                    .presentationDetents([.fraction(1/5)])
                    }
        }
    }
}

#Preview {
    NavigationStack {
        createNewTaskView()
    }
    
}
