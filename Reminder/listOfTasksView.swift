//
//  listOfTasksView.swift
//  Reminder
//
//  Created by Carter Hawkins on 8/8/24.
//

import SwiftUI
import SwiftData


struct listOfTasksView: View {
    @EnvironmentObject var dataload: dataLoad
    let maxDayRange = 8
    
    static var now: Date { Date.now }
    @Query var reminders: [Reminder]
    
    var filterReminders: [Reminder] {
    reminders.filter { $0.due > Date.now && $0.completedWrapper == false }
    }
    
    @Query(
        sort: \Settings1.Date1
    ) var settings: [Settings1]
    
    @Query(
        sort: \TaskObject.due
    ) var tasks: [TaskObject]
    @Environment(\.modelContext) var modelContext
    @State private var showingSheetForNewTaskCreation = false
    
    @State private var showCompleted = false
    @Environment(LocalNotificationManager.self) var lnManager
    
    func filterDate(date: Date, num: Int) -> [TaskObject] {
        let preFilter = tasks.filter { $0.deleted1 == false }
        
        var firstFilter: [TaskObject]
        
        if showCompleted {
            firstFilter = preFilter
        } else {
            firstFilter = preFilter.filter { $0.completed == false }
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
    
    
        var body: some View {
            @Bindable var lnManager: LocalNotificationManager = lnManager
            NavigationStack {
                List {
                    
                    ForEach(-1...maxDayRange, id: \.self) { num in
                        
                        Section(formatDateBasedOnNum(num)) {
                            
                            ForEach(filterDate(date: dateBasedOnNum(num), num: num)) { task in
                                NavigationLink {
                                    viewTaskView(task: task)
                                } label: {
                                    HStack {
                                        
                                        Image(systemName: task.completed ? "checkmark.circle.fill" : "circle")
                                            .onTapGesture {
                                                withAnimation(.linear(duration: 0.01)) {
                                                    task.completed.toggle()
                                                }
                                            }
                                            .accessibilityAddTraits(.isButton)
                                        HStack {
                                            Text(task.name)
                                            Text(num >= maxDayRange || num < 0 ? task.due.formatted(.dateTime.day().month().hour().minute()) : task.due.formatted(.dateTime.hour().minute()))
                                        }
                                    }
                                }
                            }
                        }
                        .headerProminence(num < 1 ? .increased : .standard)
                    }
                
                    
                }
                .navigationTitle("Tasks")
                .sheet(isPresented: $showingSheetForNewTaskCreation) {
                            createNewTaskView()
                        .presentationDragIndicator(.visible)
                        }
                .toolbar {
                    Button("Add Task") {
                        showingSheetForNewTaskCreation = true
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

#Preview {
    listOfTasksView()
}
