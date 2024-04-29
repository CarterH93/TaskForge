//
//  Assignment.swift
//  Reminder
//
//  Created by Carter Hawkins on 4/28/24.
//

import Foundation
import SwiftData

@Model
class Assignment {
    //Provided by calendar
    var id: String
    var name: String
    var info: String
    //Provided by user
    var notes: String
    
    //Tutorial for using images https://youtu.be/0hZxtIXmotw?si=lMDfRudYtNNM8sCE&t=968
    @Attribute(.externalStorage)
    var image: Data?
    
    init(id: String, name: String, info: String, notes: String) {
        self.id = id
        self.name = name
        self.info = info
        self.notes = notes
    }
}
