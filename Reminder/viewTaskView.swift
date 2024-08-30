//
//  viewTaskView.swift
//  Reminder
//
//  Created by Carter Hawkins on 8/8/24.
//

import SwiftUI
import SwiftData

struct newReminderSubView: View {
    @Environment(LocalNotificationManager.self) var lnManager
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var newReminderDue = Date.now
    @State private var newReminderName: String
    private var task: TaskObject
    init(task: TaskObject) {
        self.task = task
        _newReminderName = State(initialValue: "Work on \(task.name)")
    }
    var body: some View {
        @Bindable var lnManager: LocalNotificationManager = lnManager
        VStack {
            TextField("type here...", text: $newReminderName)
                .padding(.top)
            DatePicker("Remind", selection: $newReminderDue)
                .padding()
            Button("Add New Reminder") {
                let newReminder = Reminder(id: UUID().uuidString, name: newReminderName, due: newReminderDue)
                task.reminders!.append(newReminder)
                
                Task {
                    
                    let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: newReminder.due)
                    
                   
                    
                    
                    let localNotification = LocalNotification(identifier: newReminder.id, categoryIdentifier: "reminderNotification", title: newReminder.name, userInfo: ["nextView" : newReminder.id], body: todayReminderBody(newReminder), dateComponents: dateComponents, repeats: false)
                    
                    await lnManager.schedule(localNotification: localNotification)
                    
                }
                
                dismiss()
            }
        }
        .padding()
    }
}

struct autoGenerateRemindersSubView: View {
    @Environment(LocalNotificationManager.self) var lnManager
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    var generateSpacedRemindersObject: generateSpacedReminders
    @State private var numberOfReminders: Int
    @State private var timeSpan: Int
    var task: TaskObject
    init(task: TaskObject) {
        self.task = task
        let generateSpacedRemindersObject = generateSpacedReminders(task: task)
        self.generateSpacedRemindersObject = generateSpacedRemindersObject
        _numberOfReminders = State(initialValue: generateSpacedRemindersObject.defaultSessions())
        _timeSpan = State(initialValue: generateSpacedRemindersObject.timePeriod)
    }
    var body: some View {
        @Bindable var lnManager: LocalNotificationManager = lnManager
        VStack {
            HStack {
                Text("Number of Reminders")
                Picker("Number of Reminders", selection: $numberOfReminders) {
                    ForEach(1...10, id: \.self) {
                        Text(String($0))
                    }
                }
                
            }
            HStack {
                Text("Time Span")
                Picker("Time Span", selection: $timeSpan) {
                    ForEach(1...generateSpacedRemindersObject.timePeriod, id: \.self) {
                        if $0 == 1 {
                            Text("1 day")
                        } else {
                            Text("\($0) days")
                        }
                    }
                }
            }
            Button("✨ Auto Generate Reminders ✨") {
                
                for reminder in task.reminders! {
                    modelContext.delete(reminder)
                }
                let newReminders = generateSpacedRemindersObject.generate(number: numberOfReminders, timePeriod: timeSpan)
                task.reminders?.append(contentsOf: newReminders)
                
                for newReminder in newReminders {
                    
                    
                    Task {
                        
                        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: newReminder.due)
                        
                       
                        
                        
                        let localNotification = LocalNotification(identifier: newReminder.id, categoryIdentifier: "reminderNotification", title: newReminder.name, userInfo: ["nextView" : newReminder.id], body: todayReminderBody(newReminder), dateComponents: dateComponents, repeats: false)
                        
                        await lnManager.schedule(localNotification: localNotification)
                        
                    }
                    
                   
                    
                }
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .padding()
            }
        }
    }




struct viewTaskView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var showingDeleteAlert = false
    
    @Environment(\.modelContext) var modelContext

    @State var task: TaskObject

    func deleteReminder(_ indexSet: IndexSet) {
        for index in indexSet {
            let reminder = task.reminders![index]
            modelContext.delete(reminder)
        }
    }
    
    @State private var showingNewReminderSheet = false
    @State private var showingAutoGenerateSheet = false
    var body: some View {
        NavigationStack {
            Form {
                
                Section("name") {
                    if task.inAppGenerated {
                        TextField("task name", text: $task.name)
                            .font(.title)
                    } else {
                        Text(task.name)
                            .font(.title)
                    }
                }
                
                if task.inAppGenerated == false {
                    Section("description") {
                        Text(task.info)
                    }
                }
                
                Section("notes") {
                    TextEditor(text: $task.notes)
                }
                
                Section("due") {
                    if task.inAppGenerated == true {
                        DatePicker("Due:", selection: $task.due)
                    } else {
                        Text(taskBody(task))
                    }
                }
                
                
                
                Section("Reminders") {
                    
                    List {
                        
                        ForEach(task.reminders!.sorted(by: { $0.due < $1.due })) { reminder in
                            NavigationLink {
                                viewReminderView(reminder: reminder)
                            } label: {
                                HStack {
                                    Text(reminder.name)
                                    Text(reminderBody(reminder))
                                }
                            }
                           
                            
                        }
                        .onDelete(perform: deleteReminder)
                       
                        
                    }
                    
                    Button("Create New Reminder") {
                        showingNewReminderSheet = true
                    }
                }
                if Date.now.addingTimeInterval(86400) < task.due {
                    Button("✨ Auto Generate Spaced Reminders ✨") {
                        //Need to add reminders to task and create notifications for them
                        showingAutoGenerateSheet = true
                        
                        
                    }
                }
                
                Section {
                    Button(task.completed ? "Mark as uncomplete" : "Mark as complete") {
                        task.completed.toggle()
                        
                    }
                }
                
                Section {
                  
                        Button("Delete Task", role: .destructive) {
                            showingDeleteAlert = true
                            
                            
                        }
                    
                }
                
                
            }
            .sheet(isPresented: $showingNewReminderSheet) {
                newReminderSubView(task: task)
                    .presentationDetents([.fraction(1/5)])
                    .presentationDragIndicator(.visible)
                    }
            .sheet(isPresented: $showingAutoGenerateSheet) {
                autoGenerateRemindersSubView(task: task)
                    .presentationDetents([.fraction(1/3)])
                    .presentationDragIndicator(.visible)
                    }
            .alert("Are you sure you want to permanently delete this task and it's associated reminders?", isPresented: $showingDeleteAlert) {
                Button("Delete", role: .destructive) {
                    for reminder in task.reminders! {
                        modelContext.delete(reminder)
                    }
                    if task.inAppGenerated == true {
                        modelContext.delete(task)
                    } else {
                        task.deleted1 = true
                    }
                    dismiss()
                    
                            }
                    }
        }
    }
}
/*
#Preview {
    viewTaskView()
}
*/
