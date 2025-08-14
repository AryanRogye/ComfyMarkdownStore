//
//  ContentView.swift
//  ComfyMarkdownExample
//
//  Created by Aryan Rogye on 8/13/25.
//

import SwiftUI
import ComfyMarkdownUI

struct ContentView: View {
    @State var fontsize : CGFloat = 18.0
    var body: some View {
        VStack {
            ComfyMarkdown(text: """
            # Test
            ## TEST
            ### Test
            #### Test
            #### Test
            ##### Test
            ###### Test
            """, maxFontSize: $fontsize)
            
            /// Small Counter To Increase Font Size
            Button("Increase Font Size") {
                fontsize += 1
            }
            .padding()
            /// Small Counter To Decrease Font Size
            Button("Decrease Font Size") {
                fontsize -= 1
            }
        }
    }
}

#Preview {
    ContentView()
}
