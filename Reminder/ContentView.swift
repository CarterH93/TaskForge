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
                    .onAppear {
                        
                        //Needed to fix weird glitch with tabview and updating swiftdata.
                        let task = Task(oldid: "temp", name: "temp", info: "", due: Date.now)
                        modelContext.insert(task)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                            modelContext.delete(task)
                                                                        })
                       
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
