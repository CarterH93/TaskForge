//
//  EnableNotifications.swift
//  Reminder
//
//  Created by Carter Hawkins on 8/13/24.
//

import SwiftUI

struct EnableNotifications: View {
    @Environment(LocalNotificationManager.self) var lnManager
    @Environment(\.scenePhase) var scenePhase
    var body: some View {
        @Bindable var lnManager: LocalNotificationManager = lnManager
        VStack {
            if !lnManager.isGranted {
                Button("Enable Notifications") {
                    lnManager.openSettings()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .onChange(of: scenePhase) { _, newValue in
            if newValue == .active {
                Task {
                    await lnManager.getCurrentSettings()
                    await lnManager.getPendingRequests()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        EnableNotifications()
    }
}
