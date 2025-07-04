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
                    try? modelContext.save()
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
    
    @Query(
        sort: \Settings1.Date1
    ) var settings: [Settings1]
    
    
    @State private var newChecklistItem = ""
    
    @State private var showingReminderAlert = false
    
    @State private var showingReminderDeleteWithTaskAlert = false
    
    @State private var showingSheetForTaskLinking = false
    
    @State private var showingCannotDeleteAlert = false
    
    @Environment(\.modelContext) var modelContext

   @State var reminder: Reminder
    @State private var deleteHaptic = false
    
    func deleteTaskLink(_ indexSet: IndexSet) {
        if reminder.task?.reminders?.count ?? 1 < 2 {
            showingCannotDeleteAlert = true
            return
        }
        deleteHaptic.toggle()
        reminder.task = nil
        try? modelContext.save()
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
                                    viewModel.completionActions()
                                }
                                try? modelContext.save()
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
                
                
                Section("Remind") {
                    DatePicker("Remind:", selection: $reminder.due)
                }
                
                Section("notes") {
                    ImprovedTextEditor(text: $reminder.notes)
                }
                
                if (settings.first ?? Settings1()).checklistsEnabled {
                    Section {
                        
                        if !reminder.checklist.isEmpty {
                            List($reminder.checklist, editActions: .all) { $item in
                                    HStack {
                                        
                                        Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                                            .onTapGesture {
                                                withAnimation {
                                                    item.isChecked.toggle()
                                                    try? modelContext.save()
                                                }
                                            }
                                            .accessibilityAddTraits(.isButton)
                                        
                                        
                                        HStack {
                                            TextField("Checklist Item", text: $item.text, axis: .vertical)
                                                .font(.callout)
                                                .lineLimit(3)
                                        }
                                        .strikethrough(item.isChecked)
                                    }
                                    .padding(5)
                                    
                                
                                
                            }
                        }
                            
                            HStack {
                                TextField("Add New Item...", text: $newChecklistItem)
                                Button("Add Item") {
                                        let newItem = ChecklistItem(text: newChecklistItem)
                                        reminder.checklist.append(newItem)
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
                                    showingReminderDeleteWithTaskAlert = true
                                    return
                                }
                            }
                            
                            
                            showingReminderAlert = true
                            
                        }
                    
                }
                
                
            }
            .sensoryFeedback(.warning, trigger: deleteHaptic)
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
                    deleteHaptic.toggle()
                    reminder.toggleCompleted(true)
                    dismiss()
                    modelContext.delete(reminder)
                    try? modelContext.save()
                            }
                    }
            .alert("Are you sure you want to permanently delete this reminder and its associated task?", isPresented: $showingReminderDeleteWithTaskAlert) {
                Button("Delete", role: .destructive) {
                    
                    Task {
                        
                        lnManager.removeRequest(withIdentifier: reminder.id)
                    }
                    deleteHaptic.toggle()
                    reminder.toggleCompleted(true)
                    dismiss()
                    if reminder.task!.inAppGenerated {
                        modelContext.delete(reminder.task!)
                    } else {
                        reminder.task!.deleted1 = true
                    }
                    
                    
                    modelContext.delete(reminder)
                    try? modelContext.save()
                            }
                    }
            .alert("Cannot complete action because associated task needs at least one reminder.", isPresented: $showingCannotDeleteAlert) { }
        }
    
}
