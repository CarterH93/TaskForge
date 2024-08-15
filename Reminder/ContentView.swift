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
    @Query var reminders: [Reminder]
    
    var filterReminders: [Reminder] {
    reminders.filter { $0.due > Date.now && $0.completedWrapper == false }
    }
    
        var body: some View {
            @Bindable var lnManager: LocalNotificationManager = lnManager
                    TabView {
                        
                        listOfRemindersView()
                            .tabItem {
                                Label("Reminders", systemImage: "bell")
                            }
                        
                        
                        listOfTasksView()
                            .tabItem {
                                Label("Tasks", systemImage: "list.bullet.clipboard")
                            }
                        
                        More()
                            .tabItem {
                                Label("More", systemImage: "ellipsis.circle")
                            }
                    }
                    .onAppear {
                        
                        //Needed to fix weird glitch with tabview and updating swiftdata.
                        let task = TaskObject(oldid: "temp", name: "temp", info: "", due: Date.now)
                        modelContext.insert(task)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                            modelContext.delete(task)
                                                                        })
                       
                    }
                    .task(priority: .background) {
                        let cache = MagicBox(modelContainer: modelContext.container)
                        
                        await cache.work()
                        
                        
                        
                    }
                    .onAppear {
                        lnManager.clearRequests()
                        
                        for newReminder in filterReminders {
                            Task {
                                
                                let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: newReminder.due)
                                
                                let localNotification = LocalNotification(identifier: newReminder.id, categoryIdentifier: "reminderNotification", title: newReminder.name, userInfo: ["nextView" : newReminder.id], body: newReminder.notes, dateComponents: dateComponents, repeats: false)
                                
                                await lnManager.schedule(localNotification: localNotification)
                                
                            }
                        }
                    }
                    
                
        }

    
}


#Preview {
    ContentView()
}
