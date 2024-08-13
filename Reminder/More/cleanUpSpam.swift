//
//  cleanUpSpam.swift
//  Reminder
//
//  Created by Carter Hawkins on 8/12/24.
//

import SwiftUI

struct cleanUpSpam: View {
    @Environment(\.modelContext) var modelContext
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .task {
                let cache = MagicBox(modelContainer: modelContext.container)
                
                await cache.work(deletePastDueTasksOnIntialSync: true)
            }
    }
}

#Preview {
    cleanUpSpam()
}
