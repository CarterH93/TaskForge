//
//  ContentViewWrapper.swift
//  Reminder
//
//  Created by Carter Hawkins on 8/13/24.
//

import SwiftUI
import Vortex

struct ContentViewWrapper: View {
    @Environment(LocalNotificationManager.self) var lnManager
    
    @Environment(ViewModel.self) private var viewModel
    
    let confetti = VortexSystem(
        tags: ["square", "circle"],
        position: [0.5, 0],
        shape: .box(width: 1, height: 0),
        birthRate: 0,
        lifespan: 10,
        speed: 0.2,
        speedVariation: 0.5,
        angle: .degrees(180),
        angleRange: .degrees(90),
        acceleration: [0, 0.7],
        angularSpeedVariation: [4, 4, 4],
        colors: .random(.white, .red, .green, .blue, .pink, .orange, .cyan),
        size: 0.5,
        sizeVariation: 0.5
    )
    
    var body: some View {
        @Bindable var lnManager: LocalNotificationManager = lnManager
        
       
            ZStack {
                
                   ContentView()
                        .sheet(item: $lnManager.nextView) { $0 }
                     .task {
                            try? await lnManager.requestAuthorization()
                        }
                
                VortexViewReader { proxy in
                    
                VortexView(confetti) {
                    
                    Rectangle()
                        .fill(.white)
                        .frame(width: 16, height: 16)
                        .tag("square")
                    
                    Circle()
                        .fill(.white)
                        .frame(width: 16)
                        .tag("circle")
                    
                }
                .allowsHitTesting(false)
                .onChange(of: viewModel.toggleConfetti) {
                    proxy.burst()
                    print("saw toggle")
                }
                }
            }
        
           
        .ignoresSafeArea()
    }
}

#Preview {
    ContentViewWrapper()
}
