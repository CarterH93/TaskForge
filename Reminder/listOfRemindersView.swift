//
//  listOfRemindersView.swift
//  Reminder
//
//  Created by Carter Hawkins on 8/8/24.
//

import SwiftUI
import SwiftData

struct listOfRemindersView: View {
    @Query var reminders: [Reminder]
    @Environment(\.modelContext) var modelContext
    @State private var showingSheetForNewReminderCreation = false
    
        var body: some View {
            NavigationStack {
                List {
                    ForEach(reminders) { reminder in
                        HStack {
                            Text(reminder.name)
                            Text(reminder.due.formatted())
                        }
                    }
                }
                .navigationTitle("Reminders")
                .sheet(isPresented: $showingSheetForNewReminderCreation) {
                            createNewReminderView()
                        .presentationDragIndicator(.visible)
                        }
                .toolbar {
                    Button("Add Reminder") {
                        showingSheetForNewReminderCreation = true
                    }
                }
            }
        }

    
    func addSamples() {
        let sampleReminder = Reminder(id: String(Int.random(in: 1...88888)), name: "Test 123", due: Date.now)
        
       
        modelContext.insert(sampleReminder)
        do {
            try modelContext.save()
        } catch {
            
        }
    }
}

#Preview {
    listOfRemindersView()
}
