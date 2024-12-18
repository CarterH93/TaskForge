//
//  EnableNotifications.swift
//  Reminder
//
//  Created by Carter Hawkins on 8/13/24.
//

import SwiftUI
import SwiftData

struct SuggestedActions : View {
    var settings: Settings1
    @Environment(LocalNotificationManager.self) var lnManager
    @Environment(\.scenePhase) var scenePhase
   
    var body: some View {
        @Bindable var lnManager: LocalNotificationManager = lnManager
        if !lnManager.isGranted || settings.icsSources.isEmpty {
            Section("Suggested Actions") {
            VStack {
                
                if !lnManager.isGranted {
                    
                        
                        Button("Enable Notifications") {
                            lnManager.openSettings()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                
                if !lnManager.isGranted && settings.icsSources.isEmpty {
                    Divider()
                }
                
                if settings.icsSources.isEmpty {
                    NavigationLink("Add Canvas or Calendar Connection") {
                        syncing()
                    }
                    
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
            .headerProminence(.increased)
            }
       
        }
       
    }

#Preview {
    NavigationStack {
        SuggestedActions(settings: Settings1())
    }
}
