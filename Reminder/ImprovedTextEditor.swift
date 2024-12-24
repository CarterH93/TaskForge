import SwiftUI

struct ImprovedTextEditor: View {
    
    @Binding private var text: String
    
    let placeholder = "Enter Notes Here..."
    
    init(text: Binding<String>) {
        self._text = text
        UITextView.appearance().backgroundColor = .clear
    }
    
    
    var body: some View {


                ZStack(alignment: .topLeading) {
                    Color(UIColor.secondarySystemGroupedBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    Text(text.isEmpty ? placeholder: text)
                        .padding(6)
                        .padding(.bottom, 4)
                        .opacity(text.isEmpty ? 1 : 0)
                        .foregroundStyle(.secondary)
                    TextEditor(text: $text)
                        .frame(alignment: .leading)
                        .cornerRadius(6.0)
                        .multilineTextAlignment(.leading)
                }
            
        
    }
}


