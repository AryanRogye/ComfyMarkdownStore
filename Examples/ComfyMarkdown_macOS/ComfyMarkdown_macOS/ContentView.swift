//
//  ContentView.swift
//  ComfyMarkdown_macOS
//
//  Created by Aryan Rogye on 8/13/25.
//

import SwiftUI
import ComfyMarkdownUI

struct ContentView: View {
    var body: some View {
        ComfyMarkdown(text: """
            ## TEST
            """)
    }
}

#Preview {
    ContentView()
}
