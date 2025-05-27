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
        
        ScrollView {
            Text("On Canvas:")
                .frame(alignment: .center)
                .clipped()
            Text("Click on the Hamburger menu icon")
            Image("OnboardingPhoto11")
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .mask { RoundedRectangle(cornerRadius: 10, style: .continuous) }
                .padding(.vertical)
                .padding(.bottom, 100)
            
            Text("Click the Calendar Tab")
            Image("OnboardingPhoto12")
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .mask { RoundedRectangle(cornerRadius: 10, style: .continuous) }
                .padding(.vertical)
                .padding(.bottom, 100)
            
            Text("Scroll down and click the Calendar Feed")
            Image("OnboardingPhoto13")
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .mask { RoundedRectangle(cornerRadius: 10, style: .continuous) }
                .padding(.vertical)
                .padding(.bottom, 100)
            
            Text("Copy the URL Link")
            Text("*Make sure to select the entire URL")
            Image("OnboardingPhoto14")
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .mask { RoundedRectangle(cornerRadius: 10, style: .continuous) }
                .padding(.vertical)
                .padding(.bottom, 100)
            
            Text("Exit out of this screen and scroll to next screen to paste the link")
                .padding(.bottom, 100)
        }
        .padding(.top, 60)
        .padding([.leading, .trailing])
    }
}

#Preview {
    Screen3()
}
