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
                        NavigationLink {
                            viewReminderView(reminder: reminder)
                        } label: {
                            HStack {
                                Text(reminder.name)
                                Text(reminder.due.formatted())
                            }
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

}

#Preview {
    listOfRemindersView()
}
