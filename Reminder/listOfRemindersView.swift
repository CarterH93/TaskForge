//
//  listOfRemindersView.swift
//  Reminder
//
//  Created by Carter Hawkins on 8/8/24.
//

import SwiftUI
import SwiftData

struct listOfRemindersView: View {
    let maxDayRange = 8
    @Environment(Settings.self) var settings
    
    @Query(
        sort: \Reminder.due
    ) var reminders: [Reminder]
    @Environment(\.modelContext) var modelContext
    @State private var showingSheetForNewReminderCreation = false
    
    @State private var showCompleted = false
    
    
    func filterDate(date: Date, num: Int) -> [Reminder] {
        var firstFilter: [Reminder]
        
        if showCompleted {
            firstFilter = reminders
        } else {
            firstFilter = reminders.filter { $0.completedWrapper == false }
        }
        
        if num >= maxDayRange {
            return firstFilter.filter {
                $0.due >= date
               
                
            }
        }
        
        if num < 0 {
            return firstFilter.filter {
                $0.due < date
               
                
            }
        }
        
        return firstFilter.filter {
            Calendar.current.isDate(date, inSameDayAs: $0.due)
            
        }
        
        
    }
    
    
    func dateBasedOnNum(_ num: Int) -> Date {
        if num < 0 {
            return Calendar.current.startOfDay(for: Date.now)
        }
        return Calendar.current.startOfDay(for: Date.now.addingTimeInterval(Double(num * 86400)))
    }
    
    func formatDateBasedOnNum(_ num: Int) -> String {
        
        let date = dateBasedOnNum(num)
        
        if num < 0 {
            return "Over Due"
        }
        
        if Calendar.current.isDate(date, inSameDayAs: Date.now) {
            return "Today"
        }
        
        if Calendar.current.isDate(date, inSameDayAs: Date.now.addingTimeInterval(86400)) {
            return "Tomorrow"
        }
        
        if num >= maxDayRange {
            return "later"
        }
        
        
        return date.formatted(.dateTime.weekday().day().month())
        
    }
    
    @Environment(\.scenePhase) var scenePhase
    
    
    
        var body: some View {
            NavigationStack {
                Button("update") {
                    for reminder in settings.remindersThatNeedUIUpdate {
                        let realReminder = reminders.first(where: { $0.id == reminder})
                        realReminder?.UIUpdate += "fdsa"
                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1), execute: {
                            settings.remindersThatNeedUIUpdate.remove(reminder)
                                                                        })
                        
                        
                    }
                }
                List {
                    
                    ForEach(-1...maxDayRange, id: \.self) { num in
                        
                        Section(formatDateBasedOnNum(num)) {
                            
                            ForEach(filterDate(date: dateBasedOnNum(num), num: num)) { reminder in
                                NavigationLink {
                                    viewReminderView(reminder: reminder)
                                } label: {
                                    HStack {
                                        
                                        Image(systemName: reminder.completedWrapper ? "checkmark.circle.fill" : "circle")
                                            .onTapGesture {
                                                withAnimation(.linear(duration: 0.01)) {
                                                    if reminder.canChangeCompleted  {
                                                        reminder.completed.toggle()
                                                    }
                                                }
                                            }
                                            .accessibilityAddTraits(.isButton)
                                        HStack {
                                            Text(reminder.name)
                                            Text(num >= maxDayRange || num < 0 ? reminder.due.formatted(.dateTime.day().month().hour().minute()) : reminder.due.formatted(.dateTime.hour().minute()))
                                        }
                                    }
                                }
                            }
                        }
                        .headerProminence(num < 1 ? .increased : .standard)
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
                        withAnimation(.linear(duration: 0.01)) {
                            showCompleted.toggle()
                        }
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
