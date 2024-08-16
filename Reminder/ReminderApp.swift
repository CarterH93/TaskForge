//
//  ReminderApp.swift
//  Reminder
//
//  Created by Carter Hawkins on 4/28/24.
//

import SwiftUI
import SwiftData

@main
struct ReminderApp: App {
    @State var lnManager = LocalNotificationManager()
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(lnManager)
        }
        .modelContainer(for: [TaskObject.self, Settings1.self])

        
    }
}

struct RootView: View {
    
    @Environment(\.modelContext) private var context
    @Query(
        sort: \Settings1.Date1
    ) var settings: [Settings1]
 

    
    var body: some View {
        
        ContentViewWrapper()
            .onAppear {
                if settings.isEmpty {
                    context.insert(Settings1())
                    
                }
                
            }
    }
}
