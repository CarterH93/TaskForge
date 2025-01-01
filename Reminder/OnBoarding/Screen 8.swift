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
        VStack {
            Text("Notifications")
                .frame(alignment: .center)
                .clipped()
                .padding()
                .font(.title2)
            VStack {
                Image("OnboardingPhoto9")
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .mask { RoundedRectangle(cornerRadius: 10, style: .continuous) }
                    .frame(width: 100)
                    .clipped()
                Text("Enable notifications for reminders to work properly.")
                    .frame(alignment: .center)
                    .clipped()
                    .font(.system(.title2, weight: .regular))
                    .padding()
                
                if !lnManager.isGranted {
                    
                        
                        Button("Enable Notifications") {
                            Task {
                                if try await lnManager.requestAuthorization() {
                                    
                                } else {
                                    lnManager.openSettings()
                                }
                            }
                            
                        }
                        .buttonStyle(.borderedProminent)
                    }
                
                VStack {
                    Text("Pro Tip:")
                        .font(.system(.body, weight: .semibold))
                        .padding(.bottom)
                    Text("Long press on notifications to use quick actions.")
                        .multilineTextAlignment(.center)
                    Image("OnboardingPhoto10")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .mask { RoundedRectangle(cornerRadius: 10, style: .continuous) }
                        .frame(width: 210)
                        .clipped()
                }
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(.primary, lineWidth: 1)
                        .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.primary.opacity(0)))
                }
                Button() {
                    if !lnManager.isGranted {
                        Task {
                            if try await lnManager.requestAuthorization() {
                                
                            } else {
                                lnManager.openSettings()
                            }
                        }
                    }
                    viewModel.storage.showingOnboardingScreen = false
                } label: {
                    Text("Close")
                        .font(.largeTitle)
                }
                    .buttonStyle(.borderedProminent)
            }
            .padding(.top, 40)
            Spacer()
            
        }
        .onChange(of: scenePhase) { _, newValue in
            if newValue == .active {
                Task {
                    await lnManager.getCurrentSettings()
                    await lnManager.getPendingRequests()
                }
            }
        }
        .padding()
    }
}

#Preview {
    Screen8()
}
