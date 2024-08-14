//
//  More.swift
//  Reminder
//
//  Created by Carter Hawkins on 8/12/24.
//

import SwiftUI

struct More: View {
    
    
    
    var body: some View {
        NavigationStack {
            List {
                EnableNotifications()
                Section("Syncing") {
                    NavigationLink("Add Canvas or Calendar Connection") {
                        syncing()
                    }
                }
                .headerProminence(.increased)
                
                
            }
            .navigationTitle("More")
        }
    }
}

#Preview {
    More()
}
