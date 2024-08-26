//
//  syncing.swift
//  Reminder
//
//  Created by Carter Hawkins on 8/12/24.
//

import SwiftUI
import SwiftData



struct syncing: View {
    @State private var link = ""
    @State private var showingNewSheet = false
    
    @Environment(\.modelContext) var modelContext
    @Query(
        sort: \Settings1.Date1
    ) var settings: [Settings1]
    
    @State private var localTempURLHold: [URL] = []
    
    func removeRows(at offsets: IndexSet) {
        localTempURLHold = settings.first!.icsSources
        localTempURLHold.remove(atOffsets: offsets)
        settings.first!.icsSources.remove(atOffsets: offsets)
        showingNewSheet = true
        }
    
    var body: some View {
        List {
            Section("Add URL Link") {
                TextField("paste link here", text: $link)
                Button("Add Source") {
                    
                    if let url = URL(string: link) {
                        //Do work
                        localTempURLHold = settings.first!.icsSources
                        localTempURLHold.append(url)
                        settings.first!.icsSources.append(url)
                        
                        showingNewSheet = true
                    }
                    link = ""
                }
            }
            
            Section("Synced Sources") {
                ForEach(settings.first!.icsSources, id: \.self) { link in
                    Text(link.description)
                }
                .onDelete(perform: removeRows)
            }
            
            Section {
                NavigationLink("Clean up spam") {
                   deleteListOfTasks()
                }
            }
            
        }
        .sheet(isPresented: $showingNewSheet) {
            cleanUpSpam(localTempURLHold: localTempURLHold)
                .presentationDragIndicator(.visible)
                }
        .navigationTitle("Syncing")
    }
}

#Preview {
    NavigationStack {
        syncing()
    }
}
