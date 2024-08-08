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
    
        var body: some View {
                    TabView {
                        
                        listOfRemindersView()
                            .tabItem {
                                Label("Reminders", systemImage: "bell")
                            }
                        
                        
                        listOfTasksView()
                            .tabItem {
                                Label("Tasks", systemImage: "list.bullet.clipboard")
                            }
                    }
                    .task(priority: .background) {
                        let cache = MagicBox(modelContainer: modelContext.container)
                        
                        await cache.work()
                    }
                    
                
        }

    
}


#Preview {
    ContentView()
}
