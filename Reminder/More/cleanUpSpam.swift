//
//  cleanUpSpam.swift
//  Reminder
//
//  Created by Carter Hawkins on 8/12/24.
//

import SwiftUI
import SwiftData

struct cleanUpSpam: View {
    @Environment(\.modelContext) var modelContext
    @Environment(LocalNotificationManager.self) var lnManager
    @Query var reminders: [Reminder]
    
    var filterReminders: [Reminder] {
        reminders.filter { $0.due > Date.now && $0.isCompleted == false && $0.task?.deleted1 ?? false == false}
    }
    
    @Query(
        sort: \Settings1.Date1
    ) var settings: [Settings1]
    @EnvironmentObject var dataload: dataLoad
    
    var localTempURLHold: [URL]
    var body: some View {
        @Bindable var lnManager: LocalNotificationManager = lnManager
        deleteListOfTasks()
            .task {
                if dataload.loadingICSData == false {
                    dataload.loadingICSData = true
                    let cache = MagicBox(modelContainer: modelContext.container)
                    
                    await cache.work(deletePastDueTasksOnIntialSync: true, inputURLS: localTempURLHold)
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

