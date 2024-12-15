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
   
    @Query(
        sort: \Settings1.Date1
    ) var settings: [Settings1]
    
    
    @Query(
        sort: \Reminder.due
    ) var reminders: [Reminder]
    @Environment(\.modelContext) var modelContext
    @State private var showingSheetForNewReminderCreation = false
    
    @State private var showCompleted = false
    
    @EnvironmentObject var dataload: dataLoad
    
    @Environment(LocalNotificationManager.self) var lnManager
    
    var filterReminders: [Reminder] {
    reminders.filter { $0.due > Date.now && $0.completedWrapper == false }
    }
    
    
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
    
    var startOfDaySections: Int {
        if filterDate(date: dateBasedOnNum(-1), num: -1).count == 0 {
            return 0
        } else {
            return -1
        }
    }
    
    @Environment(\.scenePhase) var scenePhase
    
    
    
        var body: some View {
            NavigationStack {
                List {
                    
                    ForEach(startOfDaySections...maxDayRange, id: \.self) { num in
                        
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
                                                        reminder.toggleCompleted()
                                                    }
                                                }
                                            }
                                            .accessibilityAddTraits(.isButton)
                                        HStack {
                                            VStack {
                                                Text(reminder.name)
                                                if !reminder.notes.isEmpty {
                                                    Text(reminder.notes)
                                                        .font(.caption)
                                                        .foregroundColor(.secondary)
                                                        .lineLimit(1)
                                                }
                                                if let task = reminder.task {
                                                    Text("Task Due: \(taskBody(task))")
                                                        .foregroundColor(.orange)
                                                }
                                            }
                                            Text(num >= maxDayRange || num < 0 ? reminder.due.formatted(.dateTime.day().month().hour().minute()) : reminder.due.formatted(.dateTime.hour().minute()))
                                        }
                                    }
                                    .padding(5)
                                }
                            }
                        }
                        .headerProminence(num < 1 ? .increased : .standard)
                    }
                    
                    
                }
                .safeAreaInset(edge: .bottom, alignment: .trailing) {
                    Button {
                        showingSheetForNewReminderCreation = true
                    } label: {
                        plusButton()
                    }
                    .padding(.bottom, 40)
                    .padding(.trailing)
                    
                }
                .refreshable {
                    if dataload.loadingICSData == false {
                        dataload.loadingICSData = true
                        let cache = MagicBox(modelContainer: modelContext.container)
                        
                        await cache.work()
                        dataload.loadingICSData = false
                    }
                    
                    lnManager.clearRequests()
                    
                    for newReminder in filterReminders {
                        Task {
                            
                            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: newReminder.due)
                            
                            
                            
                            let localNotification = LocalNotification(identifier: newReminder.id, categoryIdentifier: "reminderNotification", title: newReminder.name, userInfo: ["nextView" : newReminder.id], body: todayReminderBody(newReminder), dateComponents: dateComponents, repeats: false)
                            
                            await lnManager.schedule(localNotification: localNotification)
                            
                        }
                    }
                    
                }
                
                .navigationTitle("Reminders")
                .sheet(isPresented: $showingSheetForNewReminderCreation) {
                            createNewReminderView()
                        .presentationDragIndicator(.visible)
                        }
                .toolbar {
                    Button {
                        withAnimation(.linear(duration: 0.01)) {
                            showCompleted.toggle()
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.title3)
                    }
                }
                .onChange(of: scenePhase) { _, newPhase in
                   
                    
                    if newPhase == .inactive {
                                        print("Inactive")
                                    } else if newPhase == .active {
                                        print("Active")
                                        
                                        for reminder in settings.first!.remindersThatNeedUIUpdate {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                                                let realReminder = reminders.first(where: { $0.id == reminder})
                                                realReminder?.UIUpdate += "fdsa"
                                                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                                                    settings.first!.remindersThatNeedUIUpdate.remove(reminder)
                                                                                                })
                                                                                            })
                                            
                                            
                                            
                                        }
                                        
                                    } else if newPhase == .background {
                                        print("Background")
                                    }
                }
            }
        }

}

#Preview {
    listOfRemindersView()
}
