//
//  ReminderOrTaskListObject.swift
//  Task Forge
//
//  Created by Carter Hawkins on 12/19/24.
//

import SwiftUI

struct ReminderObjectView: View {
    var reminder: Reminder
    var maxDayRange: Int
    var num: Int
    var settings: Settings1
    var showCompletedButton: Bool
    var showDue: Bool
    var showAssociatedTask: Bool
    
    
    var body: some View {
        HStack {
            if showCompletedButton {
                Image(systemName: reminder.isCompleted ? "checkmark.circle.fill" : "circle")
                    .onTapGesture {
                        withAnimation(.linear(duration: 0.01)) {
                            reminder.toggleCompleted()
                        }
                    }
                    .accessibilityAddTraits(.isButton)
            }
            
            VStack {
                HStack {
                        Text(reminder.name)
                        if !reminder.notes.isEmpty {
                            Text(reminder.notes)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                    if showDue {
                        Text((num >= maxDayRange && !settings.showOnlyToday) || num < 0 ? reminder.due.formatted(.dateTime.day().month().hour().minute()) : reminder.due.formatted(.dateTime.hour().minute()))
                    }
                }
                
                if showAssociatedTask {
                    if let task = reminder.task {
                        Text("Task Due: \(taskBody(task))")
                            .foregroundColor(.orange)
                    }
                }
            }
            .strikethrough(reminder.isCompleted)
        }
        .padding(5)
    }
   
}

struct TaskObjectView: View {
    var task: TaskObject
    var maxDayRange: Int
    var num: Int
    var settings: Settings1
    var showCompletedButton: Bool
    var showDue: Bool
    
    
    var body: some View {
        HStack {
            if showCompletedButton {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .onTapGesture {
                        withAnimation(.linear(duration: 0.01)) {
                            task.toggleCompleted()
                        }
                    }
                    .accessibilityAddTraits(.isButton)
            }
            
            VStack {
                HStack {
                        Text(task.name)
                        if !task.notes.isEmpty {
                            Text(task.notes)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                    if showDue {
                        Text((num >= maxDayRange && !settings.showOnlyToday) || num < 0 ? task.due.formatted(.dateTime.day().month().hour().minute()) : task.due.formatted(.dateTime.hour().minute()))
                    }
                }
                
            }
            .strikethrough(task.isCompleted)
        }
        .padding(5)
    }
   
}
