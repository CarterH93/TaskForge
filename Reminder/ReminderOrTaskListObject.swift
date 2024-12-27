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
    @Environment(ViewModel.self) private var viewModel
    
    var body: some View {
        HStack {
            if showCompletedButton {
                Image(systemName: reminder.isCompleted ? "checkmark.circle.fill" : "circle")
                    .onTapGesture {
                        withAnimation {
                            reminder.toggleCompleted()
                        }
                        if reminder.isCompleted {
                            viewModel.toggleConfetti.toggle()
                            viewModel.playCompletionSound()
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
                Spacer()
                if showDue {
                    Text((num >= maxDayRange && !settings.showOnlyToday) || num < 0 ? reminder.due.formatted(.dateTime.day().month().hour().minute()) : reminder.due.formatted(.dateTime.hour().minute()))
                        .font(.callout)
                        .foregroundStyle((num < 0) ? .red : .blue)
                        .strikethrough(reminder.isCompleted)
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
    var showNotes: Bool
    
    init(task: TaskObject, maxDayRange: Int = 0, num: Int? = nil, settings: Settings1 = Settings1(), showCompletedButton: Bool, showDue: Bool, showNotes: Bool) {
        self.task = task
        self.maxDayRange = maxDayRange
        if let num = num {
            self.num = num
        } else {
            if task.due < Calendar.current.startOfDay(for: Date.now) {
                self.num = -1
            } else {
                self.num = 3
            }
        }
        self.settings = settings
        self.showCompletedButton = showCompletedButton
        self.showDue = showDue
        self.showNotes = showNotes
    }
    
    @Environment(ViewModel.self) private var viewModel
    
    var body: some View {
        HStack {
            if showCompletedButton {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .onTapGesture {
                        withAnimation {
                            task.toggleCompleted()
                        }
                        if task.isCompleted {
                            viewModel.toggleConfetti.toggle()
                            viewModel.playCompletionSound()
                        }
                    }
                    .accessibilityAddTraits(.isButton)
                    .padding(.trailing)
            }
            
            VStack {
                HStack {
                    Text(task.name)
                        .font(.callout)
                    Spacer()
                }
                .strikethrough(task.isCompleted)
                
                HStack {
                   if (!task.notes.isEmpty && showNotes) {
                        Image(systemName: "text.justify.leading")
                        Text(task.notes)
                            .lineLimit(1)
                       Spacer()
                    }
                    
                }
                .foregroundColor(.secondary)
                .font(.footnote)
            }
                Spacer()
                if showDue {
                    Text((num >= maxDayRange && !settings.showOnlyToday) || num < 0 ? task.due.formatted(.dateTime.day().month().hour().minute()) : task.due.formatted(.dateTime.hour().minute()))
                        .font(.callout)
                        .foregroundStyle((num < 0) ? .red : .blue)
                        .strikethrough(task.isCompleted)
                }
                    
                
        
            
        }
        .padding(5)
    }
   
}
