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
    
    
    @Query(
        sort: \Settings1.Date1
    ) var settings: [Settings1]
    @Environment(dataLoad.self) private var dataload
    
    var localTempURLHold: [URL]
    var body: some View {
        @Bindable var lnManager: LocalNotificationManager = lnManager
        deleteListOfTasks()
            .task {
                if dataload.loadingICSData == false {
                    dataload.loadingICSData = true
                    let cache = MagicBox(modelContainer: modelContext.container)
                    
                    await cache.work(inputURLS: localTempURLHold)
                    dataload.loadingICSData = false
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
    }
}

