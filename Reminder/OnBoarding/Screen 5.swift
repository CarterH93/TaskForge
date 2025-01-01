//
//  Screen5.swift
//  MyProject
//
//  Designed in DetailsPro
//  Copyright © (My Organization). All rights reserved.
//

import SwiftUI

struct Screen5: View {
    var body: some View {
        VStack {
            Text("Sync Your Assignments")
                .frame(alignment: .center)
                .clipped()
                .padding()
                .font(.title2)
            VStack {
                Image("OnboardingPhoto5")
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .mask { RoundedRectangle(cornerRadius: 10, style: .continuous) }
                Text("Paste Your Canvas Link Below:")
                    .font(.system(.title2, weight: .semibold))
                    .padding()
                    .padding(.top, 30)
            
                    syncing()
                .frame(maxHeight: 300)
            }
        }
        .padding()
    }
}
