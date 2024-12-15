//
//  plusButton.swift
//  Task Forge
//
//  Created by Carter Hawkins on 12/15/24.
//

import SwiftUI

struct plusButton: View {
    var body: some View {
        Image(systemName: "plus")
             .font(.largeTitle)
             .padding()
             .foregroundColor(.white)
             .background(.blue)
             .mask(Circle())
             .shadow(radius: 5)
             
    }
}

#Preview {
    plusButton()
}
