//
//  Task.swift
//  Reminder
//
//  Created by Carter Hawkins on 4/28/24.
//

import Foundation
import SwiftData

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
    var completed: Bool = false
    var notes: String = ""
    var label: String?
    
    //Tutorial for using images https://youtu.be/0hZxtIXmotw?si=lMDfRudYtNNM8sCE&t=968
    @Attribute(.externalStorage)
    var image: [Data]?
    
    var reminders: [Reminder]?
    
    var id: String {
        return "\(oldid)\(name)\(info)\(due)"
    }
    
    var magicBoxID: MagicBoxID {
        return MagicBoxID(oldID: oldid, id: id)
    }
    
    init(oldid: String, name: String, info: String, due: Date, inAppGenerated: Bool = false, deleted1: Bool = false, completed: Bool = false, notes: String = "", label: String? = nil, image: [Data]? = nil) {
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
