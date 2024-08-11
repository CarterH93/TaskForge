//
//  listOfTasksView.swift
//  Reminder
//
//  Created by Carter Hawkins on 8/8/24.
//

import SwiftUI
import SwiftData

struct listOfTasksView: View {
    
    @Query(
        sort: \Task.due
    ) var tasks: [Task]
    @Environment(\.modelContext) var modelContext
    @State private var showingSheetForNewTaskCreation = false
    
    @State private var showCompleted = true
    
    var filteredTasks: [Task] {
        if showCompleted {
            return tasks
        } else {
            return tasks.filter { $0.completed == false }
        }
    }
    
        var body: some View {
            NavigationStack {
                List {
                    ForEach(filteredTasks) { task in
                       
                                
                                NavigationLink {
                                    viewTaskView(task: task)
                                } label: {
                                    HStack {
                                        
                                        Image(systemName: task.completed ? "checkmark.circle.fill" : "circle")
                                            .onTapGesture {
                                                task.completed.toggle()
                                            }
                                            .accessibilityAddTraits(.isButton)
                                        HStack {
                                            Text(task.name)
                                            Text(task.due.formatted())
                                        }
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
                    Button {
                        showCompleted.toggle()
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
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
