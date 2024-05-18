//
//  ContentView.swift
//  ICS Parser Example Project
//
//  Created by Carter Hawkins on 11/26/22.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query var assignments: [Assignment]
    @Environment(\.modelContext) var modelContext
    
        var body: some View {
                NavigationStack {
                    List {
                        ForEach(assignments) { assignment in
                            Text(assignment.name)
                        }
                    }
                    .navigationTitle("Reminders")
                    .toolbar {
                        Button("Add Samples", action: addSamples)
                    }
                    .task {
                        await MagicBox().work(modelContext)
                    }
                    .refreshable {
                        await MagicBox().work(modelContext)
                    }
                }
        }

    
    func addSamples() {
        let sampleAssignment = Assignment(id: "1", name: "Test", info: "hi", due: Date.now)
        modelContext.insert(sampleAssignment)
    }
    
}


#Preview {
    ContentView()
}
