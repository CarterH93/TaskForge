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
        VStack {
            Text("Tasks")
                .frame(alignment: .center)
                .clipped()
                .padding()
                .font(.title2)
            VStack {
                Text("Your Canvas Assignments are automatically made into tasks.")
                    .frame(alignment: .center)
                    .clipped()
                    .font(.system(.title2, weight: .regular))
                Image("OnboardingPhoto6")
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .mask { RoundedRectangle(cornerRadius: 10, style: .continuous) }
            }
            .padding(.top, 60)
            VStack {
                Text("Reminders are made automatically for each task.")
                    .frame(alignment: .center)
                    .clipped()
                    .font(.system(.title2, weight: .regular))
                Image("OnboardingPhoto7")
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .mask { RoundedRectangle(cornerRadius: 10, style: .continuous) }
            }
            .padding(.top, 40)
            Spacer()
            Spacer()
        }
        .padding()
    }
}

#Preview {
    Screen6()
}
