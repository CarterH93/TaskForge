//
//  ContentView.swift
//  ICS Parser Example Project
//
//  Created by Carter Hawkins on 11/26/22.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(LocalNotificationManager.self) var lnManager
    @Environment(\.scenePhase) var scenePhase
    
    @Query var reminders: [Reminder]
    @Query var tasks: [TaskObject]
    @Environment(ViewModel.self) private var viewModel
    @Query(
        sort: \Settings1.Date1
    ) var settings: [Settings1]
    
   
    
        var body: some View {
            @Bindable var lnManager: LocalNotificationManager = lnManager
                    TabView {
                        
                        listOfRemindersView(settings: settings.first ?? Settings1())
                            .tabItem {
                                Label("Reminders", systemImage: "bell")
                            }
                        
                        
                        listOfTasksView(settings: settings.first ?? Settings1())
                            .tabItem {
                                Label("Tasks", systemImage: "list.bullet.clipboard")
                            }
                        
                        More()
                            .tabItem {
                                Label("More", systemImage: "ellipsis.circle")
                            }
                    }
            //Commented out because glitch is no longer a problem.
            /*
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                           
                                                                       
                        //Needed to fix weird glitch with tabview and updating swiftdata.
                        let task = TaskObject(oldid: "temp", name: "temp", info: "", due: Date.now)
                        modelContext.insert(task)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                            modelContext.delete(task)
                                                                        })
                        })
                       
                    }
            */
                    .task(priority: .background) {
                        if viewModel.loadingICSData == false {
                            viewModel.loadingICSData = true
                            let cache = MagicBox(modelContainer: modelContext.container)
                            
                            await cache.work()
                            viewModel.loadingICSData = false
                        }
                        
                        
                    }
                    .onChange(of: scenePhase) { _, newPhase in
                        if newPhase == .inactive {
                            for pendingCompletionItem in viewModel.pendingCompletion {
                                if let reminder = reminders.first(where: {$0.id == pendingCompletionItem.id} ) {
                                    withAnimation {
                                        reminder.toggleCompleted(true)
                                    }
                                    print("completed delay reminder")
                                    viewModel.pendingCompletion.remove(pendingCompletionItem)
                                }
                                
                                if let task = tasks.first(where: {$0.id == pendingCompletionItem.id} ) {
                                    withAnimation {
                                        task.toggleCompleted(true)
                                    }
                                    print("completed delay task")
                                    viewModel.pendingCompletion.remove(pendingCompletionItem)
                                }
                            }
                        }
                    }
                    .onChange(of: scenePhase) { _, newPhase in
                       
                        if newPhase == .background { return }
                        
                        let remindersFromStorage = ReminderFilter.filterReminders(reminders)
                         
                         ViewModel.fixReminderDueDatesToBeBeforeTaskDue(reminders: remindersFromStorage, settings: settings.first ?? Settings1())
                        
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


#Preview {
    ContentView()
}
