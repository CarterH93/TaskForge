//
//  NextView.swift
//  Reminder
//
//  Created by Carter Hawkins on 8/13/24.
//

import SwiftUI
import SwiftData
import Vortex

struct NextView: View, Identifiable {
    @Environment(\.modelContext) var modelContext
    @Query var reminders: [Reminder]
    @Environment(ViewModel.self) private var viewModel
    
    var id: String
    
    
    
    var body: some View {
         NavigationStack {
        ZStack {
            
            viewReminderView(reminder: reminders.first(where: { $0.id == id } )!)
            
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
}

#Preview {
    NextView(id: "")
}
