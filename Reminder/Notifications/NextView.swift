//
//  NextView.swift
//  Reminder
//
//  Created by Carter Hawkins on 8/13/24.
//

import SwiftUI
import SwiftData

struct NextView: View, Identifiable {
    @Environment(\.modelContext) var modelContext
    @Query var reminders: [Reminder]
    
    var id: String
    
    
    
    var body: some View {
            viewReminderView(reminder: reminders.first(where: { $0.id == id } )!)
       
    }
}

#Preview {
    NextView(id: "")
}
