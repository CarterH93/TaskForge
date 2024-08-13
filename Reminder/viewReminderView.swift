//
//  viewReminderView.swift
//  Reminder
//
//  Created by Carter Hawkins on 8/10/24.
//

import SwiftUI
import SwiftData


struct simpleListOfTasks: View {
    @Query var tasks: [Task]
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    var reminder: Reminder
    @Binding var viewUpdater: String
    
    var body: some View {
        NavigationStack {
            List(tasks) { task in
                Button {
                    task.reminders.append(reminder)
                    viewUpdater += "123"
                    dismiss()
                    
                } label: {
                    HStack {
                        Text(task.name)
                        Text(task.due.formatted())
                    }
                }
                .buttonStyle(.plain)
            }
            .navigationTitle("Select Task")
        }
    }
}

struct viewReminderView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var showingReminderAlert = false
    
    @State private var showingSheetForTaskLinking = false
    
    @Environment(\.modelContext) var modelContext

   @State var reminder: Reminder
    
    
    func deleteTaskLink(_ indexSet: IndexSet) {
        reminder.task = nil
    }

   @State private var viewUpdater = "anyTextWorksHere"
    
  
    var body: some View {
        NavigationStack {
            Form {
                
                Section("notes") {
                    TextField("type here...", text: $reminder.notes)
                }
                
                Section("due") {
                    DatePicker("Due:", selection: $reminder.due)
                }
                
                Section("Task") {
                    if !viewUpdater.isEmpty {
                        if let task = reminder.task {
                            List {
                                ForEach([task]) { task in
                                    NavigationLink {
                                        viewTaskView(task: task)
                                    } label: {
                                        HStack {
                                            Text(task.name)
                                            Text(task.due.formatted())
                                        }
                                    }
                                    .buttonStyle(.plain)
                                
                                    
                            }
                            .onDelete(perform: deleteTaskLink)
                        }
                        } else {
                            Button("Link to task") {
                                //Add linking feature here
                                showingSheetForTaskLinking = true
                            }
                        }
                    }
                }
                
                if reminder.canChangeCompleted  {
                    Section {
                        Button(reminder.completed ? "Mark as uncomplete" : "Mark as complete") {
                            reminder.completed.toggle()
                            
                        }
                    }
                }
                
                Section {
                  
                        Button("Delete Reminder", role: .destructive) {
                            showingReminderAlert = true
                            
                            
                        }
                    
                }
                
                
            }
            .sheet(isPresented: $showingSheetForTaskLinking) {
                        simpleListOfTasks(reminder: reminder, viewUpdater: $viewUpdater)
                    .presentationDragIndicator(.visible)
                    }
            .navigationTitle(reminder.name)
            .alert("Are you sure you want to permanently delete this reminder?", isPresented: $showingReminderAlert) {
                Button("Delete", role: .destructive) {
                    dismiss()
                    modelContext.delete(reminder)
                            }
                    }
        }
    }
}
