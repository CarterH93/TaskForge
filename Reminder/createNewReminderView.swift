//
//  createNewReminderView.swift
//  Reminder
//
//  Created by Carter Hawkins on 8/8/24.
//

import SwiftUI

struct createNewReminderView: View {
    @Environment(\.dismiss) var dismiss
    
    var isValidReminder: Bool {
        !name.isEmpty && due > Date.now ? true : false
    }
    
    @Environment(\.modelContext) var modelContext
    @State private var name = ""
    @State private var due = Date.now.addingTimeInterval(3600)
    var body: some View {
        NavigationStack {
            Form {
                Section("name") {
                    TextField("type here...", text: $name)
                }
                
                
                Section("due") {
                    DatePicker("Select Due Date", selection: $due, in: Date.now.addingTimeInterval(60)...)
                }
                
                Button("Add New Reminder") {
                    if isValidReminder {
                        let newReminder = Reminder(id: UUID().uuidString, name: name, due: due)
                        modelContext.insert(newReminder)
                        do {
                            try modelContext.save()
                        } catch {
                            
                        }
                        dismiss()
                    }
                }
                .disabled(isValidReminder ? false : true)
                
            }
            .navigationTitle("New Reminder")
        }
    }
}

#Preview {
    createNewReminderView()
}
