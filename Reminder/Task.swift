//
//  Task.swift
//  Reminder
//
//  Created by Carter Hawkins on 4/28/24.
//

import Foundation
import SwiftData

@Model
class Task {
    //Provided by calendar
    var id: String
    var name: String
    var info: String
    var due: Date
    var inAppGenerated: Bool
    //Provided by user
    var completed: Bool
    var notes: String?
    var label: String?
    
    //Tutorial for using images https://youtu.be/0hZxtIXmotw?si=lMDfRudYtNNM8sCE&t=968
    @Attribute(.externalStorage)
    var image: [Data]?
    
    init(id: String, name: String, info: String, due: Date, inAppGenerated: Bool = false, completed: Bool = false, notes: String? = nil, label: String? = nil, image: [Data]? = nil) {
        self.id = id
        self.name = name
        self.info = info
        self.due = due
        self.inAppGenerated = inAppGenerated
        self.completed = completed
        self.notes = notes
        self.label = label
        self.image = image
    }
}
