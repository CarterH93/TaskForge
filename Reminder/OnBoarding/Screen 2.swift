//
//  Screen2.swift
//  MyProject
//
//  Designed in DetailsPro
//  Copyright © (My Organization). All rights reserved.
//

import SwiftUI

struct Screen2: View {
    var body: some View {
        NavigationStack {
            
            VStack {
                Text("Sync Your Tasks")
                    .frame(alignment: .center)
                    .clipped()
                    .padding()
                    .font(.title2)
                VStack(alignment: .leading) {
                    Text("Select a method of syncing tasks")
                        .frame(alignment: .center)
                        .clipped()
                    
                    NavigationLink() {
                        Screen3()
                    } label: {
                        Text("Sync with Canvas (Recommended)")
                            .font(.title2)
                    }
                        .buttonStyle(.borderedProminent)
                        .padding()
                    
                    Text("or...")
                        .frame(alignment: .center)
                        .multilineTextAlignment(.center)
                        .clipped()
                    
                    Link("Sync with Google Calendar", destination: URL(string: "https://guide.taskforgeapp.com/sync-tasks-from-google-calendar")!)
                        .buttonStyle(.borderedProminent)
                        .padding()
                }
                .padding(.top, 60)
                Spacer()
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    Screen2()
}
