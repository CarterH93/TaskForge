//
//  ContentView.swift
//  ICS Parser Example Project
//
//  Created by Carter Hawkins on 11/26/22.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query var tasks: [Task]
    @Environment(\.modelContext) var modelContext
    
        var body: some View {
                NavigationStack {
                    List {
                        ForEach(tasks) { task in
                            Text(task.name)
                        }
                    }
                    .navigationTitle("Reminders")
                    .toolbar {
                        Button("Add Samples", action: addSamples)
                    }
                    .task(priority: .background) {
                        
                        //maybe retrieve URL data here and pass it into the magicbox
                       
                        let cache = MagicBox(modelContainer: modelContext.container)
                        
                        await cache.work()
                    }
                    .refreshable {
                        let cache = MagicBox(modelContainer: modelContext.container)
                        
                        await cache.work()
                    }
                }
        }

    
    func addSamples() {
        let sampleTask = Task(id: "1", name: "Test", info: "hi", due: Date.now)
        modelContext.insert(sampleTask)
    }
    
}


#Preview {
    ContentView()
}
