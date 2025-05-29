//
//  ReminderApp.swift
//  Reminder
//
//  Created by Carter Hawkins on 4/28/24.
//

import SwiftUI
import SwiftData
import Vortex
import StoreKit

@main
struct ReminderApp: App {
    
    @Environment(\.requestReview) var requestReview
    
    @State var lnManager = LocalNotificationManager()
    @State private var viewModel = ViewModel()
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(lnManager)
                .environment(viewModel)
                .onAppear {
                    if viewModel.storage.numberOfTimesOpenedApp > 20 {
                        requestReview()
                    }
                    viewModel.storage.numberOfTimesOpenedApp += 1
                }
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
                print("settingscount11\(settings.count)")
                if settings.isEmpty {
                    context.insert(Settings1())
                    print("settingscount11    inserted")
                    
                }
                    print("settingscount11\(settings.count)")
                }
                
            
    }
}
