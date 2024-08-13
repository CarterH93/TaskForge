//
//  syncing.swift
//  Reminder
//
//  Created by Carter Hawkins on 8/12/24.
//

import SwiftUI



struct syncing: View {
    @State private var link = ""
    @Environment(Settings.self) var settings
    
    func removeRows(at offsets: IndexSet) {
        settings.icsSources.remove(atOffsets: offsets)
        }
    
    var body: some View {
        List {
            Section("Add URL Link") {
                TextField("paste link here", text: $link)
                Button("Add Source") {
                    
                    if let url = URL(string: link) {
                        //Do work
                        settings.icsSources.append(url)
                    }
                    link = ""
                }
            }
            
            Section("Synced Sources") {
                ForEach(settings.icsSources, id: \.self) { link in
                    Text(link.description)
                }
                .onDelete(perform: removeRows)
            }
            
        }
        .navigationTitle("Syncing")
    }
}

#Preview {
    NavigationStack {
        syncing()
    }
}
