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
    
    @Environment(ViewModel.self) private var viewModel
    
    

    
    static var now: Date { Date.now }
    @Query var reminders: [Reminder]
    
    
    
   
    
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
        
        if num >= ListViewDateFormatter.maxDayRange(settings) && !settings.showOnlyToday {
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
    
    
   
    
    
    var startOfDaySections: Int {
        if filterDate(date: ListViewDateFormatter.dateBasedOnNum(-1), num: -1).count == 0 {
            return 0
        } else {
            return -1
        }
    }
    @State private var buttonPressHaptic = false
    
        var body: some View {
            @Bindable var lnManager: LocalNotificationManager = lnManager
            NavigationStack {
                List {
                    
                    ForEach(startOfDaySections...ListViewDateFormatter.maxDayRange(settings), id: \.self) { num in
                        
                        Section(ListViewDateFormatter.formatDateBasedOnNum(num: num, maxDayRange: ListViewDateFormatter.maxDayRange(settings))) {
                            
                            ForEach(filterDate(date: ListViewDateFormatter.dateBasedOnNum(num), num: num)) { task in
                                NavigationLink {
                                    viewTaskView(task: task)
                                } label: {
                                    TaskObjectView(task: task, maxDayRange: ListViewDateFormatter.maxDayRange(settings), num: num, settings: settings, showCompletedButton: true, showDue: true, showNotes: true, delayCompletion: true)
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
                .frame(maxWidth: 600)
                .safeAreaInset(edge: .bottom, alignment: .trailing) {
                    Button {
                        showingSheetForNewTaskCreation = true
                        buttonPressHaptic.toggle()
                    } label: {
                        plusButton()
                    }
                    .sensoryFeedback(ViewModel.buttonPressHapticImpact, trigger: buttonPressHaptic)
                    .padding(.bottom, 40)
                    .padding(.trailing)
                    
                }
                .navigationTitle("Tasks")
                .sheet(isPresented: $showingSheetForNewTaskCreation) {
                            createNewTaskView()
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
            }
            .refreshable {
                if viewModel.loadingICSData == false {
                    viewModel.loadingICSData = true
                    let cache = MagicBox(modelContainer: modelContext.container)
                    
                    await cache.work()
                    viewModel.loadingICSData = false
                }
                
                let remindersFromStorage = ReminderFilter.filterReminders(reminders)
                 
                 ViewModel.fixReminderDueDatesToBeBeforeTaskDue(reminders: remindersFromStorage, settings: settings)
                
                lnManager.clearRequests()
                
                for newReminder in remindersFromStorage {
                    Task {
                        
                        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: newReminder.due)
                        
                        
                        
                        let localNotification = LocalNotification(identifier: newReminder.id, categoryIdentifier: "reminderNotification", title: newReminder.name, userInfo: ["nextView" : newReminder.id], body: todayReminderBody(newReminder), dateComponents: dateComponents, repeats: false)
                        
                        await lnManager.schedule(localNotification: localNotification)
                        
                    }
                }
                
            }
        }

    
}

