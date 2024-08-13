//
//  cleanUpSpam.swift
//  Reminder
//
//  Created by Carter Hawkins on 8/12/24.
//

import SwiftUI

struct cleanUpSpam: View {
    @Environment(\.modelContext) var modelContext
    var localTempURLHold: [URL]
    var body: some View {
        Text("Delete unwanted assignments")
            .task {
                let cache = MagicBox(modelContainer: modelContext.container)
                
                await cache.work(deletePastDueTasksOnIntialSync: true, inputURLS: localTempURLHold)
            }
    }
}

