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
    @State private var showingSheetForNewTaskCreation = false
        var body: some View {
            NavigationStack {
                List {
                    ForEach(tasks) { task in
                        NavigationLink {
                            viewTaskView(task: task)
                        } label: {
                            HStack {
                                Text(task.name)
                                Text(task.due.formatted())
                            }
                        }
                        
                    }
                }
                .navigationTitle("Tasks")
                .sheet(isPresented: $showingSheetForNewTaskCreation) {
                            createNewTaskView()
                        .presentationDragIndicator(.visible)
                        }
                .toolbar {
                    Button("Add Task") {
                        showingSheetForNewTaskCreation = true
                    }
                }
            }
            .refreshable {
                let cache = MagicBox(modelContainer: modelContext.container)
                
                await cache.work()
            }
        }

    
}

#Preview {
    listOfTasksView()
}
