//
//  Screen5.swift
//  MyProject
//
//

import SwiftUI

struct Screen5: View {
    var body: some View {
            VStack(spacing: 32) {
                VStack(spacing: 8) {
                    Text("Sync Your Assignments")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    Text("Paste your Canvas link below")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                Image("OnboardingPhoto5")
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .frame(maxWidth: 280)
                syncing()
                    .frame(maxHeight: 300)
                Spacer()
            }
            .padding()
        }
}
