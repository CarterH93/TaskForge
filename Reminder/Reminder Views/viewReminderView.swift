//
//  viewReminderView.swift
//  Reminder
//
//  Created by Carter Hawkins on 8/10/24.
//

import SwiftUI
import SwiftData


struct simpleListOfTasks: View {
    @Query(filter: #Predicate<TaskObject> { task in
        task.deleted1 == false
        
    }, sort: \TaskObject.due) var tasks: [TaskObject]
    
    @Query(
        sort: \Settings1.Date1
    ) var settings: [Settings1]
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    var reminder: Reminder
    @Binding var viewUpdater: String
    
    var body: some View {
            List(tasks) { task in
                Button {
                    task.reminders!.append(reminder)
                    viewUpdater += "123"
                    dismiss()
                    
                } label: {
                    TaskObjectView(task: task, showCompletedButton: false, showDue: true, showNotes: false)
                }
                .buttonStyle(.plain)
            }
            .navigationTitle("Select Task")
        }
}

struct viewReminderView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(LocalNotificationManager.self) var lnManager
    
    
    func makeReminderNotification() {
        
    }
    
    @State private var showingReminderAlert = false
    
    @State private var showingSheetForTaskLinking = false
    
    @State private var showingCannotDeleteAlert = false
    
    @Environment(\.modelContext) var modelContext

   @State var reminder: Reminder
    
    
    func deleteTaskLink(_ indexSet: IndexSet) {
        if reminder.task?.reminders?.count ?? 1 < 2 {
            showingCannotDeleteAlert = true
            return
        }
        
        reminder.task = nil
    }

   @State private var viewUpdater = "anyTextWorksHere"
    @Environment(ViewModel.self) private var viewModel
  
    var body: some View {
        @Bindable var lnManager: LocalNotificationManager = lnManager
     
            Form {
              
                Section {
                    HStack {
                        Image(systemName: reminder.isCompleted ? "checkmark.circle.fill" : "circle")
                            .onTapGesture {
                                withAnimation {
                                    reminder.toggleCompleted()
                                }
                                if reminder.isCompleted {
                                    viewModel.toggleConfetti.toggle()
                                    viewModel.playCompletionSound()
                                    print("toggle")
                                } else {
                                    print("not complete")
                                }
                            }
                            .accessibilityAddTraits(.isButton)
                        TextField("reminder name", text: $reminder.name, axis: .vertical)
                            .font(.title2)
                    }
                } header: {
                    HStack {
                        Text("Reminder")
                        Image(systemName: "bell.fill")
                    }
                }
                
                
                Section("due") {
                    DatePicker("Due:", selection: $reminder.due)
                }
                
                Section("notes") {
                    ImprovedTextEditor(text: $reminder.notes)
                }
                
                Section {
                    if !viewUpdater.isEmpty {
                        if let task = reminder.task {
                            List {
                                ForEach([task]) { task in
                                    NavigationLink {
                                        viewTaskView(task: task)
                                    } label: {
                                        TaskObjectView(task: task, showCompletedButton: true, showDue: true, showNotes: true)
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
                } header: {
                    HStack {
                        Text("Linked Task")
                        Spacer()
                        EditButton()
                            .font(.footnote)
                    }
                }
                
                
                Section {
                  
                        Button("Delete Reminder", role: .destructive) {
                            if let task = reminder.task {
                                if task.reminders?.count ?? 1 < 2 {
                                    showingCannotDeleteAlert = true
                                    return
                                }
                            }
                            
                            
                            showingReminderAlert = true
                            
                        }
                    
                }
                
                
            }
            //.navigationTitle("Reminder")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingSheetForTaskLinking) {
                        simpleListOfTasks(reminder: reminder, viewUpdater: $viewUpdater)
                    .presentationDragIndicator(.visible)
                    }
            .alert("Are you sure you want to permanently delete this reminder?", isPresented: $showingReminderAlert) {
                Button("Delete", role: .destructive) {
                    
                    Task {
                        
                        lnManager.removeRequest(withIdentifier: reminder.id)
                    }
                    reminder.toggleCompleted(true)
                    dismiss()
                    modelContext.delete(reminder)
                            }
                    }
            .alert("Cannot complete action because associated task needs at least one reminder.", isPresented: $showingCannotDeleteAlert) { }
        }
    
}
