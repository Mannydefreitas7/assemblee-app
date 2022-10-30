//
//  LabelTextField.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/9/22.
//

import SwiftUI

struct LabelTextField: View {
    
    var label: String
    var hint: String?
    var prompt: String?
    var isError: Bool = false
    var isSecure: Bool = false
    @Binding var text: String
    var systemImage: String?
    var keyboardType: UIKeyboardType = .alphabet
    var textType: UITextContentType = .familyName
    
    
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 5) {
            Text(label)
                .bold()
                .foregroundColor(Color(isError ? .systemRed : .secondaryLabel))
                .offset(x: 15)
            HStack {
                if isSecure {
                    SecureField(label, text: $text, prompt: Text(prompt ?? ""))
                } else {
                    
                    TextField(label, text: $text, prompt: Text(prompt ?? ""))
                        .keyboardType(keyboardType)
                        .multilineTextAlignment(.leading)
                        .textContentType(textType)
                        .textInputAutocapitalization(keyboardType != .emailAddress ? .words : .never)
                        .autocorrectionDisabled()
                        
                }

                if let systemImage = systemImage {
                    Spacer()
                    Image(systemName: systemImage)
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
            
            if let hint = hint {
                Text(hint)
                   // .offset(x: 15, y: 0)
                    .font(.caption)
                    .foregroundColor(Color(isError ? .systemRed : .tertiaryLabel))
                    .transition(.move(edge: .top))
                    .animation(.spring(), value: hint.count > 1)
                    .padding(.horizontal, 4)
            }
        }
    }
}

struct LabelTextField_Previews: PreviewProvider {
    static var previews: some View {
        LabelTextField(label: "Name", hint: "test", prompt: "Placeholder text", isError: true, text: .constant(""), systemImage: "checkmark")
    }
}
