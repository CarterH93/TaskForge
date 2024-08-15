//
//  NextView.swift
//  Reminder
//
//  Created by Carter Hawkins on 8/13/24.
//

import SwiftUI

struct NextView: View, Identifiable {
    @Environment(\.modelContext) var modelContext
    var id: String
    var body: some View {
        VStack {
            Text(id)
        }
    }
}

#Preview {
    NextView(id: "")
}
