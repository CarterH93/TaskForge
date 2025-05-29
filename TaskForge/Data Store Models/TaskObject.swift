//
//  Task.swift
//  Reminder
//
//  Created by Carter Hawkins on 4/28/24.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class TaskObject {
    //Provided by calendar
    var oldid: String = ""
    var name: String = ""
    var info: String = ""
    var due: Date = Date.now
    var inAppGenerated: Bool = false
    var deleted1: Bool = false
    //Provided by user
    private var completed: Bool = false
    var notes: String = ""
    var label: String?
    
    //Tutorial for using images https://youtu.be/0hZxtIXmotw?si=lMDfRudYtNNM8sCE&t=968
    @Attribute(.externalStorage)
    var image: [Data]?
    
    var reminders: [Reminder]?
    
    var isCompleted: Bool {
        if deleted1 {
            return true
        }
        return completed
    }
    
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
            self.completed.toggle()
        }
        
        //If task is not completed but all its reminders are completed
        //Set reminder with larger due date to be uncomplete
        if !self.completed {
            
            var uncomplete = false
            
            for reminder in reminders ?? [] {
                if !reminder.isCompleted {
                    uncomplete = true
                    break
                }
            }
            
            if uncomplete == false {
                //Set reminder with largest due date to be uncomplete
                let largestDueDate = reminders?.max { $0.due < $1.due }
                largestDueDate?.toggleCompleted(false)
                
            }
        }
        
    }
    
    var id: String {
        return "\(oldid)\(name)\(info)\(due)"
    }
    
    var magicBoxID: MagicBoxID {
        return MagicBoxID(oldID: oldid, id: id)
    }
    
    init(oldid: String, name: String, info: String = "", due: Date, inAppGenerated: Bool = false, deleted1: Bool = false, completed: Bool = false, notes: String = "", label: String? = nil, image: [Data]? = nil) {
        self.oldid = oldid
        self.name = name
        self.info = info
        self.due = due
        self.inAppGenerated = inAppGenerated
        self.deleted1 = deleted1
        self.completed = completed
        self.notes = notes
        self.label = label
        self.image = image
    }
}


struct MagicBoxID: Hashable {
    var oldID: String
    var id: String
}

func taskBody(_ task: TaskObject) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, MMM dd"
    let time = DateFormatter()
    time.dateFormat = "h:mm a"
    
    let relativeDateFormatter = DateFormatter()
    relativeDateFormatter.timeStyle = .none
    relativeDateFormatter.dateStyle = .medium
    relativeDateFormatter.locale = Locale(identifier: "en_GB")
    relativeDateFormatter.doesRelativeDateFormatting = true
   
    let string = relativeDateFormatter.string(from: task.due)
    
        if let _ = string.rangeOfCharacter(from: .decimalDigits) {
            //Old full date method, not using anymore
           // return "\(dateFormatter.string(from: task.due) ) at \(time.string(from: task.due))"
            
            let numDays = Calendar.current.dateComponents([.day], from: Date.now, to: task.due).day ?? 0
            
            if Calendar.current.startOfDay(for: Date.now) > Calendar.current.startOfDay(for: task.due) {
                //Task is overdue
                return "Overdue by \(abs(numDays) + 1) days"
            } else {
                //Task is in the future
                return "Due in \(numDays) days"
            }
            
        } else {
            return "Due \(string) at \(time.string(from: task.due))"
        }
}
