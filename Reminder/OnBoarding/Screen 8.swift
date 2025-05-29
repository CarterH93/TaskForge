//
//  Screen8.swift
//  MyProject
//
//  Designed in DetailsPro
//  Copyright © (My Organization). All rights reserved.
//

import SwiftUI



struct Screen8: View {
    @Environment(LocalNotificationManager.self) var lnManager
    @Environment(\.scenePhase) var scenePhase
    @Environment(ViewModel.self) private var viewModel

    var body: some View {

                VStack(spacing: 32) {
                    VStack(spacing: 8) {
                        Text("Notifications")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        Text("Enable notifications for reminders to work properly.")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    Image("OnboardingPhoto9")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .frame(width: 100)
                    if !lnManager.isGranted {
                        Button("Enable Notifications") {
                            Task {
                                if try await lnManager.requestAuthorization() {
                                    // Success
                                } else {
                                    lnManager.openSettings()
                                }
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    VStack(spacing: 16) {
                        Text("Pro Tip:")
                            .font(.title3)
                            .fontWeight(.semibold)
                        Text("Long press on notifications to use quick actions.")
                            .multilineTextAlignment(.center)
                            .font(.body)
                        Image("OnboardingPhoto10")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .frame(width: 210)
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(Color.primary.opacity(0.2), lineWidth: 1)
                    )
                    Button {
                        if !lnManager.isGranted {
                            Task {
                                if try await lnManager.requestAuthorization() {
                                    // Success
                                } else {
                                    lnManager.openSettings()
                                }
                            }
                        }
                        viewModel.storage.showingOnboardingScreen = false
                    } label: {
                        Text("Close")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    .buttonStyle(.borderedProminent)
                    Spacer()
                }
                .padding()
            
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
    Screen8()
}
