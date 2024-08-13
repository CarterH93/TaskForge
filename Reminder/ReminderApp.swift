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
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: [TaskObject.self, Settings.self])

        
    }
}

struct RootView: View {
    
    @Environment(\.modelContext) private var context
    @Query private var settings: [Settings]
    @State private var syncComplete: Bool = false
    
    @State private var currentSettings: Settings?
    
    var body: some View {
        
        VStack {
            
            Group {
                if let currentSettings {
                    ContentView()
                        
                } else {
                    ContentView()
                        
                }
            }
                .onReceive(NotificationCenter.default.publisher(for: .NSPersistentStoreRemoteChange).receive(on: RunLoop.main), perform: { _ in
                    syncComplete = true
                })
                .onChange(of: syncComplete, {
                    
                    if syncComplete {
                       
                        if settings.isEmpty {
                            context.insert(Settings())
                        } else {
                            currentSettings = settings.first!
                        }
                        
                        syncComplete = false
                    }
            })
                .environment(currentSettings ?? Settings())
        }
    }
}
