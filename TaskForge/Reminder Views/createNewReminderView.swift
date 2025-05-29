//
//  createNewReminderView.swift
//  Reminder
//
//  Created by Carter Hawkins on 8/8/24.
//

import SwiftUI

struct createNewReminderView: View {
    @Environment(LocalNotificationManager.self) var lnManager
    @Environment(\.dismiss) var dismiss
    
    var isValidReminder: Bool {
        !name.isEmpty && due > Date.now ? true : false
    }
    
   
    
    @Environment(\.modelContext) var modelContext
    @State private var name = ""
    @State private var notes = ""
    @State private var due = Date.now.addingTimeInterval(3600)
    @State private var buttonPressHaptic = false
    var body: some View {
        @Bindable var lnManager: LocalNotificationManager = lnManager
        NavigationStack {
        Form {
            Section("Name") {
                TextField("Type Here...", text: $name)
            }
            
            Section("Remind") {
                DatePicker("Remind:", selection: $due, in: Date.now.addingTimeInterval(60)...)
            }
            
            Section("Notes") {
                ImprovedTextEditor(text: $notes)
            }
            
            
            
            
            
        }
        .navigationTitle("New Reminder")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
            Button("Create") {
                if isValidReminder {
                    let newReminder = Reminder(id: UUID().uuidString, name: name, due: due, notes: notes)
                    modelContext.insert(newReminder)
                    try? modelContext.save()
                    buttonPressHaptic.toggle()
                    dismiss()
                }
            }
            .disabled(isValidReminder ? false : true)
            .sensoryFeedback(ViewModel.buttonPressHapticImpact, trigger: buttonPressHaptic)
        }
            
        }
    }
        }
}

#Preview {
    createNewReminderView()
}
