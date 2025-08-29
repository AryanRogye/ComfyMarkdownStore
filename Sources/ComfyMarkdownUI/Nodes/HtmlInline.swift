//
//  HtmlInline.swift
//  ComfyMarkdownStore
//
//  Created by Aryan Rogye on 8/24/25.
//

import SwiftUI

struct HTMLInlineView: View {
    let literal: String
    var body: some View {
        if literal.lowercased().contains("<br") {
            // render a line break inline
            Text("HELLLOOOO")
        } else {
            // fallback: strip tags and show text
            Text(literal.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression))
        }
    }
}
