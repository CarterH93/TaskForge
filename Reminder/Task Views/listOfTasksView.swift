//
//  listOfTasksView.swift
//  Reminder
//
//  Created by Carter Hawkins on 8/8/24.
//

import SwiftUI
import SwiftData


struct listOfTasksView: View {
    var settings: Settings1
    
    @EnvironmentObject var dataload: dataLoad
    private var maxDayRange: Int {
        if settings.showOnlyToday {
            return 0
        } else {
            return 8
        }
    }
    

    
    static var now: Date { Date.now }
    @Query var reminders: [Reminder]
    
    var filterReminders: [Reminder] {
        reminders.filter { $0.due > Date.now && $0.isCompleted == false && $0.task?.deleted1 ?? false == false}
    }
    
   
    
    @Query(
        sort: \TaskObject.due
    ) var tasks: [TaskObject]
    @Environment(\.modelContext) var modelContext
    @State private var showingSheetForNewTaskCreation = false
    
 
    @Environment(LocalNotificationManager.self) var lnManager
    
    func filterDate(date: Date, num: Int) -> [TaskObject] {
        let preFilter = tasks.filter { $0.deleted1 == false }
        
        var firstFilter: [TaskObject]
        
        if settings.showCompleted {
            firstFilter = preFilter
        } else {
            firstFilter = preFilter.filter { $0.isCompleted == false }
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
    
        var body: some View {
            @Bindable var lnManager: LocalNotificationManager = lnManager
            NavigationStack {
                List {
                    
                    ForEach(startOfDaySections...maxDayRange, id: \.self) { num in
                        
                        Section(formatDateBasedOnNum(num)) {
                            
                            ForEach(filterDate(date: dateBasedOnNum(num), num: num)) { task in
                                NavigationLink {
                                    viewTaskView(task: task)
                                } label: {
                                    TaskObjectView(task: task, maxDayRange: maxDayRange, num: num, settings: settings, showCompletedButton: true, showDue: true)
                                }
                            }
                        }
                        .headerProminence(num < 1 ? .increased : .standard)
                    }
                
                    
                }
                .safeAreaInset(edge: .bottom, alignment: .trailing) {
                    Button {
                        showingSheetForNewTaskCreation = true
                    } label: {
                        plusButton()
                    }
                    .padding(.bottom, 40)
                    .padding(.trailing)
                    
                }
                .navigationTitle("Tasks")
                .sheet(isPresented: $showingSheetForNewTaskCreation) {
                            createNewTaskView()
                        .presentationDragIndicator(.visible)
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
        }

    
}

