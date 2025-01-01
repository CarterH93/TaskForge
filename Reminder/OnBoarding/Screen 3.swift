//
//  Screen3.swift
//  MyProject
//
//  Designed in DetailsPro
//  Copyright © (My Organization). All rights reserved.
//

import SwiftUI

struct Screen3: View {
    var body: some View {
        VStack {
            Text("Sync Your Assignments")
                .frame(alignment: .center)
                .clipped()
                .padding()
                .font(.title2)
            VStack(alignment: .leading) {
                Text("On Canvas:")
                    .frame(alignment: .center)
                    .clipped()
                Image("OnboardingPhoto3")
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .mask { RoundedRectangle(cornerRadius: 10, style: .continuous) }
                    .padding(.vertical)
                Text("Next, click the Calendar Feed button to bring up a calendar link.")
            }
            .padding(.top, 60)
            Spacer()
            Spacer()
        }
        .padding()
    }
}

#Preview {
    Screen3()
}
