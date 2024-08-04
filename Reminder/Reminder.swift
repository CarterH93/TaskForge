//
//  Reminder.swift
//  Reminder
//
//  Created by Carter Hawkins on 8/4/24.
//

import Foundation
import SwiftData

@Model
class Reminder {
    var id: String
    var name: String
    var due: Date
    var completed: Bool
    var notes: String?
    var label: String?
    
    //Tutorial for using images https://youtu.be/0hZxtIXmotw?si=lMDfRudYtNNM8sCE&t=968
    @Attribute(.externalStorage)
    var image: [Data]?
    
    var task: Task?
    
    init(id: String, name: String, due: Date, completed: Bool, notes: String? = nil, label: String? = nil, image: [Data]? = nil) {
        self.id = id
        self.name = name
        self.due = due
        self.completed = completed
        self.notes = notes
        self.label = label
        self.image = image
    }
}
