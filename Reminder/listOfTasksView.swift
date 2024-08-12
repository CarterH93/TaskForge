//
//  listOfTasksView.swift
//  Reminder
//
//  Created by Carter Hawkins on 8/8/24.
//

import SwiftUI
import SwiftData


struct listOfTasksView: View {
    
    let maxDayRange = 8
    
    
    @Query(
        sort: \Task.due
    ) var tasks: [Task]
    @Environment(\.modelContext) var modelContext
    @State private var showingSheetForNewTaskCreation = false
    
    @State private var showCompleted = true
    
    
    func filterDate(date: Date, num: Int) -> [Task] {
        var firstFilter: [Task]
        
        if showCompleted {
            firstFilter = tasks
        } else {
            firstFilter = tasks.filter { $0.completed == false }
        }
        
        if num >= maxDayRange {
            return firstFilter.filter {
                $0.due >= date
               
                
            }
        }
        
        if num < 0 {
            return firstFilter.filter {
                $0.due < date
               
                
            }
        }
        
        return firstFilter.filter {
            Calendar.current.isDate(date, inSameDayAs: $0.due)
            
        }
        
        
    }
    
    
    func dateBasedOnNum(_ num: Int) -> Date {
        Calendar.current.startOfDay(for: Date.now.addingTimeInterval(Double(num * 86400)))
    }
    
    func formatDateBasedOnNum(_ num: Int) -> String {
        
        let date = dateBasedOnNum(num)
    
        
        if Calendar.current.isDate(date, inSameDayAs: Date.now) {
            return "Today"
        }
        
        if Calendar.current.isDate(date, inSameDayAs: Date.now.addingTimeInterval(86400)) {
            return "Tomorrow"
        }
        
        if num >= maxDayRange {
            return "later"
        }
        if num < 0 {
            return "Over Due"
        }
        
        return date.formatted(.dateTime.weekday().day().month())
        
    }
    
    
        var body: some View {
            NavigationStack {
                List {
                    
                    ForEach(-1...maxDayRange, id: \.self) { num in
                        
                        Section(formatDateBasedOnNum(num)) {
                            
                            ForEach(filterDate(date: dateBasedOnNum(num), num: num)) { task in
                                NavigationLink {
                                    viewTaskView(task: task)
                                } label: {
                                    HStack {
                                        
                                        Image(systemName: task.completed ? "checkmark.circle.fill" : "circle")
                                            .onTapGesture {
                                                withAnimation(.linear(duration: 0.01)) {
                                                    task.completed.toggle()
                                                }
                                            }
                                            .accessibilityAddTraits(.isButton)
                                        HStack {
                                            Text(task.name)
                                            Text(num >= maxDayRange || num < 0 ? task.due.formatted(.dateTime.day().month().hour().minute()) : task.due.formatted(.dateTime.hour().minute()))
                                        }
                                    }
                                }
                            }
                        }
                        .headerProminence(num < 1 ? .increased : .standard)
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
                        withAnimation(.linear(duration: 0.01)) {
                            showCompleted.toggle()
                        }
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
