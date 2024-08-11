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

    func deleteReminder(_ indexSet: IndexSet) {
        for index in indexSet {
            let reminder = task.reminders[index]
            modelContext.delete(reminder)
        }
    }
    
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
                    
                    List {
                        
                        ForEach(task.reminders) { reminder in
                            HStack {
                                Text(reminder.name)
                                Text(reminder.due.formatted())
                            }
                            
                        }
                        .onDelete(perform: deleteReminder)
                       
                        
                    }
                    
                    Button("Create New Reminder") {
                        showingNewReminderSheet = true
                    }
                }
                
                Section {
                    Button(task.completed ? "Mark as uncomplete" : "Mark as complete") {
                        task.completed.toggle()
                        
                    }
                }
                
                Section {
                    if task.inAppGenerated == true {
                        Button("Delete Task", role: .destructive) {
                            dismiss()
                            modelContext.delete(task)
                            
                        }
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
