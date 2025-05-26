//
//  createNewTaskView.swift
//  Reminder
//
//  Created by Carter Hawkins on 8/8/24.
//

import SwiftUI
import SwiftData


struct createNewTaskView: View {
    @Environment(\.dismiss) var dismiss
    
    var isValidTask: Bool {
        !name.isEmpty && due > Date.now ? true : false
    }
    
    @Environment(\.modelContext) var modelContext
    
    @Query(
        sort: \Settings1.Date1
    ) var settings: [Settings1]
    
    @State private var name = ""
    @State private var notes = ""
    @State private var due = {
        let calendar = Calendar.current
        let now = Date()
        var components = calendar.dateComponents([.year, .month, .day], from: now)
        components.hour = 23
        components.minute = 59
        components.second = 0
        return calendar.date(from: components) ?? Date()
    }()
    @State private var buttonPressHaptic = false
    var body: some View {
          NavigationStack {
        Form {
            Section("Name") {
                TextField("Type Here...", text: $name)
            }
            
            Section("Due") {
                DatePicker("Due:", selection: $due, in: Date.now.addingTimeInterval(60)...)
            }
            
            Section("Notes") {
                ImprovedTextEditor(text: $notes)
            }
        }
        .navigationTitle("New Task")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Create") {
                    if isValidTask {
                        let newTask = TaskObject(oldid: UUID().uuidString, name: name, due: due, inAppGenerated: true, notes: notes)
                        newTask.reminders = [Reminder(id: UUID().uuidString, name: "Work on \(newTask.name)", due: due.addingTimeInterval(-settings.first!.defaultReminderWrapper))]
                        modelContext.insert(newTask)
                        try? modelContext.save()
                        buttonPressHaptic.toggle()
                        dismiss()
                    }
                }
                .disabled(isValidTask ? false : true)
                .sensoryFeedback(ViewModel.buttonPressHapticImpact, trigger: buttonPressHaptic)
            }
        }
    }
            
        }
    }

#Preview {
    NavigationStack {
        createNewTaskView()
    }
    
}
