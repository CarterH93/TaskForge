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
        newReminderDue = settings.calcNewDefaultReminderDateTime(taskDue: task.due)
    }
    @State private var buttonPressHaptic = false
    var body: some View {
        @Bindable var lnManager: LocalNotificationManager = lnManager
        VStack {
            TextField("type here...", text: $newReminderName)
                .padding(.top)
            DatePicker("Remind:", selection: $newReminderDue)
                .padding()
            Button("Add New Reminder") {
                let newReminder = Reminder(id: UUID().uuidString, name: newReminderName, due: newReminderDue)
                task.reminders!.append(newReminder)
                buttonPressHaptic.toggle()
                try? modelContext.save()
                dismiss()
            }
            .sensoryFeedback(ViewModel.buttonPressHapticImpact, trigger: buttonPressHaptic)
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
    @State private var buttonPressHaptic = false
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
                buttonPressHaptic.toggle()
                try? modelContext.save()
                dismiss()
            }
            .sensoryFeedback(ViewModel.buttonPressHapticImpact, trigger: buttonPressHaptic)
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
    @State private var deleteHaptic = false
    
    @State private var newChecklistItem = ""

    func deleteReminder(_ indexSet: IndexSet) {
        let reminders = task.reminders!.sorted(by: { $0.due < $1.due })
        for index in indexSet {
            if reminders.count < 2 {
                showingExplanationForNotBeingAbleToDelete = true
                return
            }
            
            deleteHaptic.toggle()
            
            let reminder = reminders[index]
            reminder.toggleCompleted(true)
            lnManager.removeRequest(withIdentifier: reminder.id)
            modelContext.delete(reminder)
            try? modelContext.save()
        }
    }
    
    func deleteChecklistItem(_ indexSet: IndexSet) {
        let checklistItems = task.checklist!.sorted(by: { $0.order < $1.order })
        for index in indexSet {
            let item = checklistItems[index]
            modelContext.delete(item)
            try? modelContext.save()
        }
    }
    
    func moveChecklistItem(from source: IndexSet, to destination: Int) {
        guard var checklist = task.checklist?.sorted(by: { $0.order < $1.order }) else { return }
        // Move the item in the array
        checklist.move(fromOffsets: source, toOffset: destination)
        // Update the order property for each item
        for (index, item) in checklist.enumerated() {
            item.order = index
        }
        try? modelContext.save()
    }
    
    @State private var showingNewReminderSheet = false
    @State private var showingAutoGenerateSheet = false
    
    @State private var showingExplanationForDisabledSpacedReminders = false
    @State private var showingExplanationForNotBeingAbleToDelete = false
    
    @Environment(LocalNotificationManager.self) var lnManager
    @Environment(ViewModel.self) private var viewModel
    
    @Query(
        sort: \Settings1.Date1
    ) var settings: [Settings1]
    
    var body: some View {
            Form {
                
                Section {
                    HStack {
                        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                            .onTapGesture {
                                withAnimation {
                                    task.toggleCompleted()
                                }
                                if task.isCompleted {
                                    viewModel.completionActions()
                                }
                                try? modelContext.save()
                            }
                            .accessibilityAddTraits(.isButton)
                        
                        if task.inAppGenerated {
                            TextField("task name", text: $task.name, axis: .vertical)
                                .font(.title2)
                        } else {
                            Text(task.name)
                                .font(.title2)
                        }
                    }
                } header: {
                    HStack {
                        Text("Task")
                        Image(systemName: "list.bullet.clipboard.fill")
                    }
                }
                
                Section("due") {
                    if task.inAppGenerated == true {
                        DatePicker("Due:", selection: $task.due)
                    } else {
                        Text(fullDateText(task))
                    }
                }
                
                
                Section("notes") {
                    ImprovedTextEditor(text: $task.notes)
                }
                
                if (settings.first ?? Settings1()).checklistsEnabled {
                    Section {
                        
                        if let checklist = task.checklist {
                            
                            if !(checklist.isEmpty)  {
                                
                                
                                List {
                                    
                                    ForEach(task.checklist!.sorted(by: { $0.order < $1.order })) { item in
                                        
                                        HStack {
                                            
                                            Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                                                .onTapGesture {
                                                    withAnimation {
                                                        item.isChecked.toggle()
                                                    }
                                                    try? modelContext.save()
                                                }
                                                .accessibilityAddTraits(.isButton)
                                            
                                            
                                            HStack {
                                                TextField("Checklist Item", text: Binding(
                                                    get: { item.text },
                                                    set: { item.text = $0 }
                                                ), axis: .vertical)
                                                    .font(.callout)
                                            }
                                            .strikethrough(item.isChecked)
                                        }
                                        .padding(5)
                                       
                                        
                                    }
                                    .onDelete(perform: deleteChecklistItem)
                                    .onMove(perform: moveChecklistItem)
                                   
                                    
                                }
                                
                                
                                
                            }
                        }
                            
                            HStack {
                                TextField("Add New Item...", text: $newChecklistItem)
                                Button("Add Item") {
                                    let newItem = ChecklistItemTask(text: newChecklistItem, order: (task.checklist!.count))
                                        task.checklist!.append(newItem)
                                        newChecklistItem = ""
                                        try? modelContext.save()
                                }
                                .disabled(newChecklistItem.isEmpty)
                            }
                        } header: {
                            HStack {
                                Text("Checklist")
                                Spacer()
                                EditButton()
                                    .font(.footnote)
                            }
                        }
                    
                }
                
        
                
                Section {
                    
                    List {
                        
                        ForEach(task.reminders!.sorted(by: { $0.due < $1.due })) { reminder in
                            NavigationLink {
                                viewReminderView(reminder: reminder)
                            } label: {
                                
                                ReminderObjectView(reminder: reminder, settings: settings.first ?? Settings1(), showCompletedButton: true, showDue: true, showAssociatedTask: false, showNotes: true)
                                
                            }
                           
                            
                        }
                        .onDelete(perform: deleteReminder)
                       
                        
                    }
                    
                    Button("Create New Reminder") {
                        showingNewReminderSheet = true
                    }
                } header: {
                    HStack {
                        Text("Linked Reminders")
                        Spacer()
                        EditButton()
                            .font(.footnote)
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
                  
                        Button("Delete Task", role: .destructive) {
                            showingDeleteAlert = true
                            
                            
                        }
                    
                }
                
                
            }
            .sensoryFeedback(.warning, trigger: deleteHaptic)
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
                    deleteHaptic.toggle()
                    for reminder in task.reminders! {
                        lnManager.removeRequest(withIdentifier: reminder.id)
                        modelContext.delete(reminder)
                        try? modelContext.save()
                        
                    }
                    if task.inAppGenerated == true {
                        modelContext.delete(task)
                        try? modelContext.save()
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

/*
#Preview {
    viewTaskView()
}
*/
