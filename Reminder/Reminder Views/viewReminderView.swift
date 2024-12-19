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
        NavigationStack {
            List(tasks) { task in
                Button {
                    task.reminders!.append(reminder)
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
    
  
    var body: some View {
        @Bindable var lnManager: LocalNotificationManager = lnManager
        NavigationStack {
            Form {
                Section("name") {
                    TextField("reminder name", text: $reminder.name)
                        .font(.title)
                }
                
                Section("notes") {
                    TextEditor(text: $reminder.notes)
                }
                
                Section("due") {
                    DatePicker("Due:", selection: $reminder.due)
                }
                
                Section("Linked Task") {
                    if !viewUpdater.isEmpty {
                        if let task = reminder.task {
                            List {
                                ForEach([task]) { task in
                                    NavigationLink {
                                        viewTaskView(task: task)
                                    } label: {
                                        HStack {
                                            Text(task.name)
                                            Text(taskBody(task))
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
                
                    Section {
                        Button(reminder.isCompleted ? "Mark as uncomplete" : "Mark as complete") {
                            reminder.toggleCompleted()
                            
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
            .onChange(of: reminder.due) {
                if reminder.isCompleted == false {
                    Task {
                        
                        lnManager.removeRequest(withIdentifier: reminder.id)
                        
                        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminder.due)
                        
                        
                        
                        let localNotification = LocalNotification(identifier: reminder.id, categoryIdentifier: "reminderNotification", title: reminder.name, userInfo: ["nextView" : reminder.id], body: todayReminderBody(reminder), dateComponents: dateComponents, repeats: false)
                        
                        await lnManager.schedule(localNotification: localNotification)
                    }
                }
            }
            .onChange(of: reminder.name) {
                if reminder.isCompleted == false {
                    Task {
                        
                        lnManager.removeRequest(withIdentifier: reminder.id)
                        
                        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminder.due)
                        
                        
                        
                        let localNotification = LocalNotification(identifier: reminder.id, categoryIdentifier: "reminderNotification", title: reminder.name, userInfo: ["nextView" : reminder.id], body: todayReminderBody(reminder), dateComponents: dateComponents, repeats: false)
                        
                        await lnManager.schedule(localNotification: localNotification)
                    }
                }
            }
            .onChange(of: reminder.isCompleted) {
                
                if reminder.isCompleted == false {
                    
                    Task {
                        
                        lnManager.removeRequest(withIdentifier: reminder.id)
                        
                        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminder.due)
                        
                        
                        
                        let localNotification = LocalNotification(identifier: reminder.id, categoryIdentifier: "reminderNotification", title: reminder.name, userInfo: ["nextView" : reminder.id], body: todayReminderBody(reminder), dateComponents: dateComponents, repeats: false)
                        
                        await lnManager.schedule(localNotification: localNotification)
                    }
                } else {
                    lnManager.removeRequest(withIdentifier: reminder.id)
                }
            }
        }
    }
}
