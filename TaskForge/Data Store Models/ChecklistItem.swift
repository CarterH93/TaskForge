//
//  checklistItem.swift
//  Task Forge
//
//  Created by Carter Hawkins on 7/2/25.
//

//Because of cloudkits inverse relationship requirement, we have two create two seperate classes (even though they are the same thing)

import SwiftData

@Model
class ChecklistItemTask {
    
    var text: String = ""
    var isChecked: Bool = false
    var order: Int = 0
    
    var task: TaskObject?
    
    init(text: String, isChecked: Bool = false, order: Int) {
        self.text = text
        self.isChecked = isChecked
    }
}


@Model
class ChecklistItemReminder {
    
    var text: String = ""
    var isChecked: Bool = false
    var order: Int = 0
    
    var reminder: Reminder?
    
    init(text: String, isChecked: Bool = false, order: Int) {
        self.text = text
        self.isChecked = isChecked
    }
}
