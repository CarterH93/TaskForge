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
    
   
    
    var body: some View {
        @Bindable var lnManager: LocalNotificationManager = lnManager
        
       
            ZStack {
                
                   ContentView()
                        .sheet(item: $lnManager.nextView) { $0 }
                     .task {
                            try? await lnManager.requestAuthorization()
                        }
                
                VortexViewReader { proxy in
                    
                    VortexView(viewModel.confetti) {
                    
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
