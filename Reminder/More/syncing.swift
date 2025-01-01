//
//  syncing.swift
//  Reminder
//
//  Created by Carter Hawkins on 8/12/24.
//

import SwiftUI
import SwiftData



struct syncing: View {
    var body: some View {
        List {
            AddAndViewICSSources()
            Section {
                NavigationLink("Clean up Spam") {
                   deleteListOfTasks()
                }
            }
            
        }
        .navigationTitle("Syncing")
    }
}

#Preview {
    NavigationStack {
        syncing()
    }
}
