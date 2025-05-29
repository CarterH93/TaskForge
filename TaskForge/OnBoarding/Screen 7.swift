//
//  Screen7.swift
//  MyProject
//
//

import SwiftUI

struct Screen7: View {
    var body: some View {
  
                VStack(spacing: 32) {
                    VStack(spacing: 8) {
                        Text("Reminders")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        Text("Reminders will be sent as a notification.")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    Image("OnboardingPhoto8")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .frame(maxWidth: 280)
                    VStack(spacing: 16) {
                        Text("When all reminders for a task are complete, the task is complete.")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        VStack(spacing: 8) {
                            Text("Note:")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Text("Reminders are the main tool you should use and work off of.")
                                .multilineTextAlignment(.center)
                                .font(.body)
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(Color.primary.opacity(0.2), lineWidth: 1)
                        )
                    }
                    Spacer()
                }
                .padding()
            
        
    }
}

#Preview {
    Screen7()
}
