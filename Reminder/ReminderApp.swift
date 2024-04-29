//
//  ReminderApp.swift
//  Reminder
//
//  Created by Carter Hawkins on 4/28/24.
//

import SwiftUI
import SwiftData

@main
struct ReminderApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Assignment.self) { result in
            do {
                //Accessing saved data
                let container = try result.get()
                let descriptor = FetchDescriptor<Assignment>()
                let existingAssignments = try container.mainContext.fetch(descriptor)
                //Now able to access all existing assignments
                print(existingAssignments.count)
                print(existingAssignments.first?.name ?? "nothing")
                
                
                
                //Accessing remote data
                
                
                
            } catch {
                
            }
        }
    }
}
