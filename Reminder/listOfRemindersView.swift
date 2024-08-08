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
    
        var body: some View {
            NavigationStack {
                List {
                    ForEach(reminders) { reminder in
                        Text(reminder.name)
                    }
                }
                .navigationTitle("Reminders")
                .toolbar {
                    Button("Add Samples", action: addSamples)
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
