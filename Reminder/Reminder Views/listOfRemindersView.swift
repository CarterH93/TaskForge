//
//  listOfRemindersView.swift
//  Reminder
//
//  Created by Carter Hawkins on 8/8/24.
//

import SwiftUI
import SwiftData

struct listOfRemindersView: View {
    var settings: Settings1
    private var maxDayRange: Int {
        if settings.showOnlyToday {
            return 0
        } else {
            return 8
        }
    }
    
    
    @Query(
        sort: \Reminder.due
    ) var reminders: [Reminder]
    @Environment(\.modelContext) var modelContext
    @State private var showingSheetForNewReminderCreation = false
    
    @Environment(dataLoad.self) private var dataload
    
    @Environment(LocalNotificationManager.self) var lnManager
    
    var filterReminders: [Reminder] {
        reminders.filter { $0.due > Date.now && $0.isCompleted == false && $0.task?.deleted1 ?? false == false}
    }
    
    
    func filterDate(date: Date, num: Int) -> [Reminder] {
        var firstFilter: [Reminder]
        
        if settings.showCompleted {
            firstFilter = reminders.filter { $0.task?.deleted1 ?? false == false }
        } else {
            firstFilter = reminders.filter { $0.isCompleted == false && $0.task?.deleted1 ?? false == false }
        }
        
        if num >= maxDayRange && !settings.showOnlyToday {
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
                                    ReminderObjectView(reminder: reminder, maxDayRange: maxDayRange, num: num, settings: settings, showCompletedButton: true, showDue: true, showAssociatedTask: true, showNotes: true)
                                        .padding(4)
                                }
                            }
                        }
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color(UIColor.secondarySystemGroupedBackground))
                                .padding([.top, .bottom], 6)
                                
                        )
                        .listRowSeparator(.hidden)
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
                        .presentationDetents([.medium, .large])
                        }
                .toolbar {
                    Menu {
                        Button {
                            withAnimation(.linear(duration: 0.01)) {
                                settings.showOnlyToday.toggle()
                            }
                        } label: {
                            HStack {
                                Text(settings.showOnlyToday ? "✓ Show Only Today" : "Show Only Today")
                                Image(systemName: "calendar.badge.checkmark")
                            }
                        }
                        
                        Button {
                            withAnimation(.linear(duration: 0.01)) {
                                settings.showCompleted.toggle()
                                }
                            } label: {
                                HStack {
                                    Text(settings.showCompleted ? "✓ Show Completed" : "Show Completed")
                                    Image(systemName: "checklist.checked")
                                }
                            }
                        
                        
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.title3)
                    }
                    
                }
                //Commented out because glitch is no longer a problem
                /*
                .onChange(of: scenePhase) { _, newPhase in
                   
                    
                    if newPhase == .inactive {
                                        print("Inactive")
                                    } else if newPhase == .active {
                                        print("Active")
                                        
                                        for reminder in settings.remindersThatNeedUIUpdate {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                                                let realReminder = reminders.first(where: { $0.id == reminder})
                                                realReminder?.UIUpdate += "fdsa"
                                                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                                                    settings.remindersThatNeedUIUpdate.remove(reminder)
                                                                                                })
                                                                                            })
                                            
                                            
                                            
                                        }
                                        
                                    } else if newPhase == .background {
                                        print("Background")
                                    }
                }
                */
            }
        }

}


