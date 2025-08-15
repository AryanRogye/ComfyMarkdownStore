//
//  Constants.swift
//  ComfyMarkdownExample
//
//  Created by Aryan Rogye on 8/14/25.
//

import SwiftUI

enum AppAnim {
    static let snap = Animation.interactiveSpring(response: 0.25, dampingFraction: 0.9, blendDuration: 0.05)
    static let modeSwitch = Animation.interactiveSpring(
        response: 0.35, // a hair longer than snap
        dampingFraction: 0.85,
        blendDuration: 0.05
    )
}

#if os(iOS)
enum Haptics {
    static func light() { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
    static func medium() { UIImpactFeedbackGenerator(style: .medium).impactOccurred() }
    static func success() { UINotificationFeedbackGenerator().notificationOccurred(.success) }
}
#endif

@MainActor
enum Keyboard {
    static func hide() {
#if os(iOS)
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
#endif
    }
}
