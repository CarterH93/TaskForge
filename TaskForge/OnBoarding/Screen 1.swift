//
//  Screen1.swift
//  MyProject
//
//

import SwiftUI

struct Screen1: View {
    var body: some View {
            VStack(spacing: 32) {
                VStack(spacing: 8) {
                    Image("TaskForgeLogo")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .padding(.top)
                    Text("Welcome to Task Forge")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    Text("Get automated reminders for your Canvas assignments and calendar events.")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                Image("OnboardingPhoto1")
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .frame(width: 280)
                Spacer()
            }
            .padding()
    }
}

#Preview {
    Screen1()
}
