//
//  viewTaskView.swift
//  Reminder
//
//  Created by Carter Hawkins on 8/8/24.
//

import SwiftUI
import SwiftData

struct newReminderSubView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var newReminderDue = Date.now
    @State private var newReminderName: String
    private var task: Task
    init(task: Task) {
        self.task = task
        _newReminderName = State(initialValue: "Work on \(task.name)")
    }
    var body: some View {
        VStack {
            TextField("type here...", text: $newReminderName)
                .padding(.top)
            DatePicker("Remind", selection: $newReminderDue)
                .padding()
            Button("Add New Reminder") {
                task.reminders.append(Reminder(id: UUID().uuidString, name: newReminderName, due: newReminderDue))
                do {
                    try modelContext.save()
                } catch {
                    
                }
                dismiss()
            }
        }
        .padding()
    }
}

struct viewTaskView: View {
    @Environment(\.dismiss) var dismiss
    
   
    
    @Environment(\.modelContext) var modelContext

    var task: Task

    
    @State private var showingNewReminderSheet = false
    var body: some View {
        NavigationStack {
            Form {
                
                Section("description") {
                    Text(task.info)
                }
                
                Section("due") {
                    Text(task.due.formatted())
                }
                
                Section("Reminders") {
                    
                    List(task.reminders) { reminder in
                        HStack {
                            Text(reminder.name)
                            Text(reminder.due.formatted())
                        }
                    }
                    Button("Create New Reminder") {
                        showingNewReminderSheet = true
                    }
                }
                
                
                
                
            }
            .navigationTitle(task.name)
            .sheet(isPresented: $showingNewReminderSheet) {
                newReminderSubView(task: task)
                    .presentationDetents([.fraction(1/5)])
                    .presentationDragIndicator(.visible)
                    }
        }
    }
}
/*
#Preview {
    viewTaskView()
}
*/
