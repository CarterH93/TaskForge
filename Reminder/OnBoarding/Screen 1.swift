//
//  Screen1.swift
//  MyProject
//
//  Designed in DetailsPro
//  Copyright © (My Organization). All rights reserved.
//

import SwiftUI

struct Screen1: View {
    var body: some View {
        VStack {
            Image("TaskForgeLogo")
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80)
                .clipped()
                .mask { RoundedRectangle(cornerRadius: 10, style: .continuous) }
                .padding(.top)
            Text("Welcome to Task Forge")
                .padding()
                .font(.system(.title, weight: .semibold))
            Text("Get automated reminders for your Canvas assignments.")
                .padding(.vertical, 50)
            Image("OnboardingPhoto1")
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .mask { RoundedRectangle(cornerRadius: 10, style: .continuous) }
                .clipped()
                .frame(width: 280)
                .clipped()
            Spacer()
        }
        .padding()
    }
}

#Preview {
    Screen1()
}
