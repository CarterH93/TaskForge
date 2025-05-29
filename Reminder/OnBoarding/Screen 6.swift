//
//  Screen6.swift
//  MyProject
//
//  Designed in DetailsPro
//  Copyright © (My Organization). All rights reserved.
//

import SwiftUI

struct Screen6: View {
    var body: some View {
                VStack(spacing: 32) {
                    VStack(spacing: 8) {
                        Text("Tasks")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        Text("Your Canvas Assignments and Calendar events are automatically made into tasks.")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    VStack(spacing: 16) {
                        Image("OnboardingPhoto6")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .frame(maxWidth: 280)
                        Text("Reminders are made automatically for each task.")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        Image("OnboardingPhoto7")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .frame(maxWidth: 280)
                    }
                    Spacer()
                }
                .padding()
            
        
    }
}

#Preview {
    Screen6()
}
