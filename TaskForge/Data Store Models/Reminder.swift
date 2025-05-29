//
//  Reminder.swift
//  Reminder
//
//  Created by Carter Hawkins on 8/4/24.
//

//explanation on how the magic box works
//https://www.notion.so/carterhawkins/How-the-Magic-Box-Works-3659eff58882494792a6775a0f44963b?pvs=4


import Foundation
import SwiftData
import SwiftUI

@Model
class Reminder {
    var id: String = ""
    var name: String = ""
    var due: Date = Date.now
    private var completed: Bool = false
    var notes: String = ""
    var label: String?
    var UIUpdate: String = "initial"
    
    func delayComplete(_ viewModel: ViewModel) {
        
        if let selectedItem = viewModel.pendingCompletion.first(where: {$0.id == self.id}) {
            selectedItem.delay.cancel()
            viewModel.pendingCompletion.remove(selectedItem)
        } else {
            let delayItem = DelayItem(id: self.id)
            viewModel.pendingCompletion.insert(delayItem)
            delayItem.delay.performWork {
                
                //Complete task
                withAnimation {
                    self.toggleCompleted(true)
                }
                
                
                
                viewModel.pendingCompletion.remove(delayItem)
            }
            
        }
    }
    

    func toggleCompleted(_ manuelBool: Bool? = nil) {
        if let manuelBool = manuelBool {
            //manuelly sets value to given parameter
            self.completed = manuelBool
            
        } else {
            //If no manuel value given, just do normal toggling function
            
            //Logic to ensure reminder button doesnt do anything when uncomplete but associated task is complete
            if let task = task {
                //if task is completed but the reminder isnt
                if task.isCompleted && !completed {
                    //Toggle the task instead of reminder
                    task.toggleCompleted()
                    //Return and do not complete normal toggle function below
                    return
                }
            }
            
            //Just do normal toggle function
            self.completed.toggle()
        }
        
        
        //Sets task to be completed if all its reminders are completed
        var notCompleted = false
        
        for reminder in self.task?.reminders ?? [] {
            if !reminder.completed {
                notCompleted = true
                break
            }
        }
        
        if notCompleted == false {
            self.task?.toggleCompleted(true)
        }
        
        //Sets task to be uncompleted if there is a reminder that is not complete
        
        var taskAssociatednotCompleted = false
        
        for reminder in self.task?.reminders ?? [] {
            if !reminder.completed {
                taskAssociatednotCompleted = true
                break
            }
        }
        
        if taskAssociatednotCompleted == true {
            self.task?.toggleCompleted(false)
        }
        
    }
    
    //The variable to go off for the correct completed value. Looks at parent tasks to see if they are marked off as completed
    var isCompleted: Bool {
        
        if completed {
            return true
        }
        
        if let task = task {
            if task.isCompleted || task.deleted1 {
                return true
            }
        }
        
        return false
    }
    
    
    //Tutorial for using images https://youtu.be/0hZxtIXmotw?si=lMDfRudYtNNM8sCE&t=968
    @Attribute(.externalStorage)
    var image: [Data]?
    
    var task: TaskObject?
    
    init(id: String, name: String, due: Date, completed: Bool = false, notes: String = "", label: String? = nil, image: [Data]? = nil, UIUpdate: String = "initial") {
        self.id = id
        self.name = name
        self.due = due
        self.completed = completed
        self.notes = notes
        self.label = label
        self.image = image
        self.UIUpdate = UIUpdate
        
        
    }
}


func reminderBody(_ reminder: Reminder) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, MMM dd h:mm a"
    let time = DateFormatter()
    time.dateFormat = "h:mm a"
    
    let relativeDateFormatter = DateFormatter()
    relativeDateFormatter.timeStyle = .none
    relativeDateFormatter.dateStyle = .medium
    relativeDateFormatter.locale = Locale(identifier: "en_GB")
    relativeDateFormatter.doesRelativeDateFormatting = true
   
    let string = relativeDateFormatter.string(from: reminder.due)
    
        if let _ = string.rangeOfCharacter(from: .decimalDigits) {
            return dateFormatter.string(from: reminder.due)
        } else {
            return "\(string), \(time.string(from: reminder.due))"
        }
}

func todayReminderBody(_ reminder: Reminder) -> String {
    let time = DateFormatter()
    time.dateFormat = "h:mm a"
    return "Today, \(time.string(from: reminder.due))"
}
