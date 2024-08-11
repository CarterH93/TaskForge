//
//  viewReminderView.swift
//  Reminder
//
//  Created by Carter Hawkins on 8/10/24.
//

import SwiftUI
import SwiftData

struct viewReminderView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var showingReminderAlert = false
    
    @Environment(\.modelContext) var modelContext

    var reminder: Reminder

   
    
  
    var body: some View {
        NavigationStack {
            Form {
                
                Section("description") {
                    Text(reminder.notes ?? "N/A")
                }
                
                Section("due") {
                    Text(reminder.due.formatted())
                }
                
                
                
                Section {
                    Button(reminder.completed ? "Mark as uncomplete" : "Mark as complete") {
                        reminder.completed.toggle()
                        
                    }
                }
                
                Section {
                  
                        Button("Delete Reminder", role: .destructive) {
                            showingReminderAlert = true
                            
                            
                        }
                    
                }
                
                
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
