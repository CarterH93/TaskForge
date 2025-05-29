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
            VStack(spacing: 32) {
                VStack(spacing: 8) {
                    Text("Sync Your Tasks")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    Text("Select a method of syncing tasks")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                VStack(spacing: 16) {
                    NavigationLink(destination: Screen3()) {
                        Text("Sync with Canvas (Recommended)")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Text("or")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Link(destination: URL(string: "https://guide.taskforgeapp.com/sync-tasks-from-google-calendar")!) {
                        Text("Sync with Google Calendar")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    Screen2()
}
