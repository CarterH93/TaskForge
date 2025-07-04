//
//  checklistItem.swift
//  Task Forge
//
//  Created by Carter Hawkins on 7/2/25.
//

import Foundation

@Observable
class ChecklistItem: Identifiable, Codable {
    var id: String = UUID().uuidString
    var text: String
    var isChecked: Bool = false
    
    init(text: String) {
        self.text = text
    }
}
