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

@Model
class Reminder {
    var id: String = ""
    var name: String = ""
    var due: Date = Date.now
    var completed: Bool = false
    var notes: String = ""
    var label: String?
    var UIUpdate: String = ""
    
    //The variable to go off for the correct completed value. Looks at parent tasks to see if they are marked off as completed
    var completedWrapper: Bool {
        
        if completed {
            return true
        }
        
        if let task = task {
            if task.completed {
                return true
            }
        }
        
        return false
    }
    
    //We do not want the user changing the reminder completed bool if the parent task is completed. Results in weird behavior.
    var canChangeCompleted: Bool {
        if let task = task {
            if task.completed || task.deleted1 {
                return false
            }
        }
        return true
    }
    
    //Tutorial for using images https://youtu.be/0hZxtIXmotw?si=lMDfRudYtNNM8sCE&t=968
    @Attribute(.externalStorage)
    var image: [Data]?
    
    var task: TaskObject?
    
    init(id: String, name: String, due: Date, completed: Bool = false, notes: String = "", label: String? = nil, image: [Data]? = nil, UIUpdate: String = "") {
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
