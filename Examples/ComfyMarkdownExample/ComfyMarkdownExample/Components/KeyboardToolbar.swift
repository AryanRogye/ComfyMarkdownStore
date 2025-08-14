//
//  KeyboardToolbar.swift
//  CleanMarkdown
//
//  Created by Aryan Rogye on 8/12/25.
//

import SwiftUI

struct KeyboardToolbar: View {
    
    @Binding var fontSize: CGFloat
    @Binding var isFocused: Bool
    var onKeyboardDismiss: () -> Void
    
    var body: some View {
        HStack {
            decreaseFontSize
            increaseFontSize
            Spacer()
            Button(action: {
                onKeyboardDismiss()
            }) {
                Text("Close")
                    .padding()
                    .frame(maxHeight: .infinity)
            }
        }
        .background(Color(.systemGray6))
        .frame(maxWidth: .infinity, maxHeight: 30)
    }
    
    private var decreaseFontSize: some View {
        Button(action: {
            fontSize = fontSize > 10 ? fontSize - 1 : fontSize
        }) {
            Image(systemName: "minus.circle.fill")
                .foregroundColor(.gray)
        }
    }
    
    private var increaseFontSize: some View {
        Button(action: {
            fontSize = fontSize < 30 ? fontSize + 1 : fontSize
        }) {
            Image(systemName: "plus.circle.fill")
                .foregroundColor(.gray)
        }
    }
}
