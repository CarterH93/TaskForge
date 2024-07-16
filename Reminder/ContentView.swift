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
                    .task {
                        //Fix this error using this video
                   // https://www.notion.so/carterhawkins/Fixing-data-race-issues-e4d800127da74fda9b3b10bcbc3599a0?pvs=4
                        await MagicBox().work(modelContext)
                    }
                    .refreshable {
                        await MagicBox().work(modelContext)
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
