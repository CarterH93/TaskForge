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
    var showNotes: Bool
    
    
    init(reminder: Reminder, maxDayRange: Int = 0, num: Int? = nil, settings: Settings1 = Settings1(), showCompletedButton: Bool, showDue: Bool, showAssociatedTask: Bool, showNotes: Bool) {
        self.reminder = reminder
        self.maxDayRange = maxDayRange
        if let num = num {
            self.num = num
        } else {
            if reminder.due < Calendar.current.startOfDay(for: Date.now) {
                self.num = -1
            } else {
                self.num = 3
            }
        }
        self.settings = settings
        self.showCompletedButton = showCompletedButton
        self.showDue = showDue
        self.showAssociatedTask = showAssociatedTask
        self.showNotes = showNotes
    }
    
    
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
                    .padding(.trailing)
            }
                
            
            VStack {
                HStack {
                    Text(reminder.name)
                        .font(.callout)
                    Spacer()
                    if showDue {
                        Text((num >= maxDayRange && !settings.showOnlyToday) || num < 0 ? reminder.due.formatted(.dateTime.day().month().hour().minute()) : reminder.due.formatted(.dateTime.hour().minute()))
                            .font(.callout)
                            .foregroundStyle((num < 0) ? .red : .blue)
                    }
                }
                .strikethrough(reminder.isCompleted)
                
                HStack {
                    if (!reminder.notes.isEmpty && showNotes) && (showAssociatedTask && reminder.task != nil) {
                        Image(systemName: "text.justify.leading")
                    } else if (!reminder.notes.isEmpty && showNotes) {
                        Image(systemName: "text.justify.leading")
                        Text(reminder.notes)
                            .lineLimit(1)
                    }
                
                if showAssociatedTask {
                    if let task = reminder.task {
                        Image(systemName: "list.bullet.clipboard")
                        Text(taskBody(task))
                    }
                }
                    
                    if (!reminder.notes.isEmpty && showNotes) || (showAssociatedTask && reminder.task != nil) {
                        Spacer()
                    }
                
            }
                .foregroundColor(.secondary)
                .font(.footnote)
            }
            
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
