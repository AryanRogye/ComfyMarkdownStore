//
//  CustomTextView.swift
//  CleanMarkdown
//
//  Created by Aryan Rogye on 8/12/25.
//

import UIKit
import SwiftUI

class CustomTextView: UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        backgroundColor = .secondarySystemBackground
        textAlignment = .left
        isEditable = true
        isSelectable = true
        isScrollEnabled = false
    }
}

struct CustomTextFieldWrapper: UIViewRepresentable {
    
    @Binding var textFieldText: String
    @Binding var fontSize: CGFloat
    @Binding var isFocused : Bool
    var onKeyboardDismiss: () -> Void
    
    init(
        textFieldText: Binding<String>,
        fontSize: Binding<CGFloat>,
        isFocused: Binding<Bool>,
        onKeyboardDismiss: @escaping () -> Void
    ) {
        self._textFieldText = textFieldText
        self._fontSize = fontSize
        self._isFocused = isFocused
        self.onKeyboardDismiss = onKeyboardDismiss
    }
    
    func makeUIView(context: Context) -> CustomTextView {
        let tv = CustomTextView()
        tv.delegate = context.coordinator
        
        // Host SwiftUI toolbar inside a UIInputView and assign it
        let host = UIHostingController(
            rootView: KeyboardToolbar(
                fontSize: $fontSize,
                isFocused: $isFocused
            ) {
                onKeyboardDismiss()
            }
        )
        host.view.backgroundColor = .clear
        host.view.translatesAutoresizingMaskIntoConstraints = false
        
        let accessory = UIInputView(frame: .zero, inputViewStyle: .keyboard)
        accessory.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        accessory.addSubview(host.view)
        
        NSLayoutConstraint.activate([
            host.view.leadingAnchor.constraint(equalTo: accessory.leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: accessory.trailingAnchor),
            host.view.topAnchor.constraint(equalTo: accessory.topAnchor),
            host.view.bottomAnchor.constraint(equalTo: accessory.bottomAnchor),
        ])
        
        accessory.allowsSelfSizing = true
        
        tv.inputAccessoryView = accessory
        
        // Optional: hide QuickType shortcut bar if you only want your controls
        tv.inputAssistantItem.leadingBarButtonGroups = []
        tv.inputAssistantItem.trailingBarButtonGroups = []
        
        return tv
    }
    
    func updateUIView(_ uiView: CustomTextView, context: Context) {
        /// Update text if it has changed
        if uiView.text != textFieldText {
            uiView.text = textFieldText
        }
        
        /// Update font size if it has changed
        if abs((uiView.font?.pointSize ?? 0) - normalizeFontSize()) > 0.01 {
            uiView.font = UIFont.systemFont(ofSize: normalizeFontSize())
        }
        
        // Drive first-responder from SwiftUI focus
        if isFocused && !uiView.isFirstResponder {
            DispatchQueue.main.async { uiView.becomeFirstResponder() }
        }
    }
    
    private func normalizeFontSize() -> CGFloat {
        let adjusted = fontSize - 7
        return adjusted.clamped(to: 8...72)
    }
    
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: CustomTextFieldWrapper
        init(_ parent: CustomTextFieldWrapper) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            // Avoid feedback loops by only pushing when actually changed
            if parent.textFieldText != textView.text {
                DispatchQueue.main.async {
                    self.parent.textFieldText = textView.text
                }
            }
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if !parent.isFocused {
                parent.isFocused = true
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            if parent.isFocused {
                parent.isFocused = false
            }
        }
    }
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        min(max(self, limits.lowerBound), limits.upperBound)
    }
}
