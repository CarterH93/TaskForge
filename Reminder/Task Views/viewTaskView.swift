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
    @State private var newReminderDue: Date
    @State private var newReminderName: String
    private var task: TaskObject
    init(task: TaskObject, settings: Settings1) {
        self.task = task
        _newReminderName = State(initialValue: "Work on \(task.name)")
        newReminderDue = task.due.addingTimeInterval(-settings.defaultReminderWrapper)
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
        
        var timePeriod = generateSpacedRemindersObject.timePeriod
        
        if timePeriod > 14 {
            timePeriod = 14
        }
        _numberOfReminders = State(initialValue: generateSpacedRemindersObject.defaultSessions(timePeriod))
        _timeSpan = State(initialValue: timePeriod)
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
            if task.reminders?.count ?? 1 < 2 {
                showingExplanationForNotBeingAbleToDelete = true
                return
            }
            
            
            let reminder = task.reminders![index]
            reminder.toggleCompleted(true)
            lnManager.removeRequest(withIdentifier: reminder.id)
            modelContext.delete(reminder)
        }
    }
    
    @State private var showingNewReminderSheet = false
    @State private var showingAutoGenerateSheet = false
    
    @State private var showingExplanationForDisabledSpacedReminders = false
    @State private var showingExplanationForNotBeingAbleToDelete = false
    
    @Environment(LocalNotificationManager.self) var lnManager
    
    @Query(
        sort: \Settings1.Date1
    ) var settings: [Settings1]
    
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
                
                if Date.now.addingTimeInterval(86400) > task.due {
                    Button("✨ Auto Generate Spaced Reminders ✨") {  }
                    .disabled(Date.now.addingTimeInterval(86400) > task.due)
                    .onTapGesture {
                        showingExplanationForDisabledSpacedReminders = true
                    }
                } else {
                    Button("✨ Auto Generate Spaced Reminders ✨") {
                        showingAutoGenerateSheet = true
                    }
                }
                
                
                Section {
                    Button(task.isCompleted ? "Mark as uncomplete" : "Mark as complete") {
                        task.toggleCompleted()
                        
                        if task.isCompleted {
                            for reminder in task.reminders! {
                                lnManager.removeRequest(withIdentifier: reminder.id)
                            }
                        } else {
                            
                            Task {
                                
                                for reminder in task.reminders! {
                                    if !reminder.isCompleted {
                                    lnManager.removeRequest(withIdentifier: reminder.id)
                                    
                                    let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminder.due)
                                    
                                    
                                    
                                    let localNotification = LocalNotification(identifier: reminder.id, categoryIdentifier: "reminderNotification", title: reminder.name, userInfo: ["nextView" : reminder.id], body: todayReminderBody(reminder), dateComponents: dateComponents, repeats: false)
                                    
                                    await lnManager.schedule(localNotification: localNotification)
                                }
                            }
                        }
                        }
                        
                    }
                }
                
                Section {
                  
                        Button("Delete Task", role: .destructive) {
                            showingDeleteAlert = true
                            
                            
                        }
                    
                }
                
                
            }
            .sheet(isPresented: $showingNewReminderSheet) {
                newReminderSubView(task: task, settings: settings.first ?? Settings1())
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
                        lnManager.removeRequest(withIdentifier: reminder.id)
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
            .alert("Your task's date needs to be at least one day in the future to use this feature.", isPresented: $showingExplanationForDisabledSpacedReminders) {
                    }
            .alert("Your task must have at least one reminder associated with it.", isPresented: $showingExplanationForNotBeingAbleToDelete) {
                    }
        }
    }
}
/*
#Preview {
    viewTaskView()
}
*/
