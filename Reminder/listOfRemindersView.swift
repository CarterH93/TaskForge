//
//  listOfRemindersView.swift
//  Reminder
//
//  Created by Carter Hawkins on 8/8/24.
//

import SwiftUI
import SwiftData

struct listOfRemindersView: View {
    @Query(
        sort: \Reminder.due
    ) var reminders: [Reminder]
    @Environment(\.modelContext) var modelContext
    @State private var showingSheetForNewReminderCreation = false
    
    
    @State private var showCompleted = false
    
    var filteredReminder: [Reminder] {
        if showCompleted {
            return reminders
        } else {
            return reminders.filter { $0.completedWrapper == false }
        }
    }
    
        var body: some View {
            NavigationStack {
                List {
                    ForEach(filteredReminder) { reminder in
                        NavigationLink {
                            viewReminderView(reminder: reminder)
                        } label: {
                            HStack {
                                Image(systemName: reminder.completedWrapper ? "checkmark.circle.fill" : "circle")
                                    .onTapGesture {
                                        reminder.completed.toggle()
                                    }
                                    .accessibilityAddTraits(.isButton)
                                HStack {
                                    Text(reminder.name)
                                    Text(reminder.due.formatted())
                                }
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
                    Button {
                        showCompleted.toggle()
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
        }

}

#Preview {
    listOfRemindersView()
}
