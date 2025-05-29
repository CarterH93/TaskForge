//
//  Screen3.swift
//  MyProject
//
//

import SwiftUI

struct Screen3: View {
    var body: some View {
            ScrollView {
                VStack(spacing: 32) {
                    VStack(spacing: 8) {
                        Text("Sync with Canvas")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        Text("Follow these steps to get your Canvas calendar link")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    
                    VStack(alignment: .leading, spacing: 32) {
                        StepView(
                            title: "On Canvas:",
                            description: "Click on the Hamburger menu icon",
                            imageName: "OnboardingPhoto11"
                        )
                        StepView(
                            title: nil,
                            description: "Click the Calendar Tab",
                            imageName: "OnboardingPhoto12"
                        )
                        StepView(
                            title: nil,
                            description: "Scroll down and click the Calendar Feed",
                            imageName: "OnboardingPhoto13"
                        )
                        StepView(
                            title: nil,
                            description: "Copy the URL Link\n*Make sure to select the entire URL",
                            imageName: "OnboardingPhoto14"
                        )
                    }
                    
                    Text("Exit out of this screen and scroll to next screen to paste the link")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 32)
                }
                .padding()
            }
    }
}

struct StepView: View {
    var title: String?
    var description: String
    var imageName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let title = title {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            Text(description)
                .font(.body)
            Image(imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .frame(maxWidth: .infinity)
        }
        .padding(.bottom, 100)
    }
}

#Preview {
    Screen3()
}
