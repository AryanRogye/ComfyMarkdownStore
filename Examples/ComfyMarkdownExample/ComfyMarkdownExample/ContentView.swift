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
            
            ---
            
            This is a paragraph.  
            It can span multiple lines in the source file,  
            and Markdown will wrap it together when rendered.
            
            ***
            
            This is a second paragraph, because it’s separated by a blank line.
            
            ---
            
            > This is a BlockQuoteView
            > With Another one
            
            > Testing With Detached
            > Lines in between
            
            ---
            
            ```swift
                let test = Test()
            ```
            
            ---
            
            - Item 1
              - Item 2
                - item 3
              - item 2
            - item 3
            
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
