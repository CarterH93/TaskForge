//
//  OnboardingHolderView.swift
//  Task Forge
//
//  Created by Carter Hawkins on 1/1/25.
//

import SwiftUI

struct OnboardingHolderView: View {
    var body: some View {
        TabView {
            Screen1()
            Screen2()
            Screen3()
            Screen4()
            Screen5()
            Screen6()
            Screen7()
            Screen8()
        }
        .interactiveDismissDisabled()
        .tabViewStyle(.page)
        .onAppear {
            UIPageControl.appearance().currentPageIndicatorTintColor = .label
            UIPageControl.appearance().pageIndicatorTintColor = .secondaryLabel
        }
    }
}

#Preview {
    OnboardingHolderView()
}
