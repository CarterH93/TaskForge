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
    
    @Query(
        sort: \Reminder.due
    ) var reminders: [Reminder]
    @Environment(\.modelContext) var modelContext
    @State private var showingSheetForNewReminderCreation = false
    
    @Environment(ViewModel.self) private var viewModel
    
    @Environment(LocalNotificationManager.self) var lnManager
    
    
    func filterDate(date: Date, num: Int) -> [Reminder] {
        var firstFilter: [Reminder]
        
        if settings.showCompleted {
            firstFilter = reminders.filter { $0.task?.deleted1 ?? false == false }
        } else {
            firstFilter = reminders.filter { $0.isCompleted == false && $0.task?.deleted1 ?? false == false }
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
    
    @Environment(\.scenePhase) var scenePhase
    @State private var buttonPressHaptic = false
        var body: some View {
            NavigationStack {
                List {
                    
                    ForEach(startOfDaySections...ListViewDateFormatter.maxDayRange(settings), id: \.self) { num in
                        
                        Section(ListViewDateFormatter.formatDateBasedOnNum(num: num, maxDayRange: ListViewDateFormatter.maxDayRange(settings))) {
                            
                            ForEach(filterDate(date: ListViewDateFormatter.dateBasedOnNum(num), num: num)) { reminder in
                                NavigationLink {
                                    viewReminderView(reminder: reminder)
                                } label: {
                                    ReminderObjectView(reminder: reminder, maxDayRange: ListViewDateFormatter.maxDayRange(settings), num: num, settings: settings, showCompletedButton: true, showDue: true, showAssociatedTask: true, showNotes: true, delayCompletion: true)
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
                        buttonPressHaptic.toggle()
                    } label: {
                        plusButton()
                    }
                    .sensoryFeedback(ViewModel.buttonPressHapticImpact, trigger: buttonPressHaptic)
                    .padding(.bottom, 40)
                    .padding(.trailing)
                    
                }
                .refreshable {
                    if viewModel.loadingICSData == false {
                        viewModel.loadingICSData = true
                        let cache = MagicBox(modelContainer: modelContext.container)
                        
                        await cache.work()
                        viewModel.loadingICSData = false
                    }
                    
                    lnManager.clearRequests()
                    
                    for newReminder in ReminderFilter.filterReminders(reminders) {
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
                .onChange(of: scenePhase) { _, newPhase in
                   
                    
                    if newPhase == .inactive {
                                        print("Inactive")
                                    } else if newPhase == .active {
                                        print("Active")
                                        
                                        for reminder in settings.remindersThatNeedUIUpdate {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                                                let realReminder = reminders.first(where: { $0.id == reminder})
                                                print(realReminder!.name)
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
                
            }
        }

}


