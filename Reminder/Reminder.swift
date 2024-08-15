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
    var id: String
    var name: String
    var due: Date
    var completed: Bool
    var notes: String
    var label: String?
    
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
            if task.completed {
                return false
            }
        }
        return true
    }
    
    //Tutorial for using images https://youtu.be/0hZxtIXmotw?si=lMDfRudYtNNM8sCE&t=968
    @Attribute(.externalStorage)
    var image: [Data]?
    
    var task: TaskObject?
    
    init(id: String, name: String, due: Date, completed: Bool = false, notes: String = "", label: String? = nil, image: [Data]? = nil) {
        self.id = id
        self.name = name
        self.due = due
        self.completed = completed
        self.notes = notes
        self.label = label
        self.image = image
        
        
        
    }
}
