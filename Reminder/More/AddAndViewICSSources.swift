//
//  AddAndViewICSSources.swift
//  Task Forge
//
//  Created by Carter Hawkins on 1/1/25.
//

import SwiftUI
import SwiftData

struct AddAndViewICSSources: View {
    @State private var deleteHaptic = false
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
        deleteHaptic.toggle()
        }
    var body: some View {
 
            Section("Add .ICS Link") {
                HStack {
                    TextField("Paste Link Here...", text: $link)
                    PasteButton(payloadType: String.self) { strings in
                        guard let first = strings.first else { return }
                        link = first
                    }
                    .buttonBorderShape(.capsule)
                }
                Button("Add Source") {
                    
                    if let url = URL(string: link) {
                        //Do work
                        localTempURLHold = settings.first!.icsSources
                        localTempURLHold.append(url)
                        settings.first!.icsSources.append(url)
                        try? modelContext.save()
                        showingNewSheet = true
                    }
                    link = ""
                }
            }
            
            Section {
                ForEach(settings.first!.icsSources, id: \.self) { link in
                    Text(link.description)
                }
                .onDelete(perform: removeRows)
            } header: {
                HStack {
                    Text("Synced Sources")
                    Spacer()
                    EditButton()
                        .font(.footnote)
                }
            
            
        }
        .sensoryFeedback(.warning, trigger: deleteHaptic)
        .sheet(isPresented: $showingNewSheet) {
            cleanUpSpam(localTempURLHold: localTempURLHold)
                .presentationDragIndicator(.visible)
                }
    }
    }


#Preview {
    AddAndViewICSSources()
}
