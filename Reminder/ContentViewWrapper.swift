//
//  ContentViewWrapper.swift
//  Reminder
//
//  Created by Carter Hawkins on 8/13/24.
//

import SwiftUI

struct ContentViewWrapper: View {
    @Environment(LocalNotificationManager.self) var lnManager
    var body: some View {
        @Bindable var lnManager: LocalNotificationManager = lnManager
        ContentView()
            .sheet(item: $lnManager.nextView) { $0 }
            .task {
                try? await lnManager.requestAuthorization()
            }
    }
}

#Preview {
    ContentViewWrapper()
}
