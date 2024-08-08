//
//  listOfTasksView.swift
//  Reminder
//
//  Created by Carter Hawkins on 8/8/24.
//

import SwiftUI
import SwiftData

struct listOfTasksView: View {
    @Query var tasks: [Task]
    @Environment(\.modelContext) var modelContext
    
        var body: some View {
            NavigationStack {
                List {
                    ForEach(tasks) { task in
                        Text(task.name)
                    }
                }
                .navigationTitle("Tasks")
                .toolbar {
                    Button("Add Samples", action: addSamples)
                }
            }
        }

    
    func addSamples() {
        let sampleTask = Task(oldid: String(Int.random(in: 1...88888)), name: "Test123", info: "test", due: Date.now, inAppGenerated: true)
        modelContext.insert(sampleTask)
    }
    
}

#Preview {
    listOfTasksView()
}
