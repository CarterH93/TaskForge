//
//  NextView.swift
//  Reminder
//
//  Created by Carter Hawkins on 8/13/24.
//

import SwiftUI

struct NextView: View, Identifiable {
    var id: String
    var body: some View {
        Text(id)
    }
}

#Preview {
    NextView(id: "")
}
