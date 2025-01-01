//
//  Screen7.swift
//  MyProject
//
//  Designed in DetailsPro
//  Copyright © (My Organization). All rights reserved.
//

import SwiftUI

struct Screen7: View {
    var body: some View {
        VStack {
            Text("Reminders")
                .frame(alignment: .center)
                .clipped()
                .padding()
                .font(.title2)
            VStack {
                Text("Reminders will be sent as a notification.")
                    .frame(alignment: .center)
                    .clipped()
                    .font(.system(.title2, weight: .regular))
                Image("OnboardingPhoto8")
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .mask { RoundedRectangle(cornerRadius: 10, style: .continuous) }
            }
            .padding(.top, 60)
            VStack {
                Text("When all reminders for a task are complete, the task is complete.")
                    .frame(alignment: .center)
                    .clipped()
                    .font(.system(.title2, weight: .regular))
                    .padding(.bottom)
                VStack {
                    Text("Note:")
                        .font(.system(.body, weight: .semibold))
                        .padding(.bottom)
                    Text("Reminders are the main tool you should use and work off of.")
                        .multilineTextAlignment(.center)
                }
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(.primary, lineWidth: 1)
                        .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.primary.opacity(0)))
                }
            }
            .padding(.top, 40)
            Spacer()
            Spacer()
        }
        .padding()
    }
}

#Preview {
    Screen7()
}
