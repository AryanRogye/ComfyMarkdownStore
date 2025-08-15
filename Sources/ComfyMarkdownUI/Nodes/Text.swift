//
//  Text.swift
//
//
//  Created by Aryan Rogye on 8/14/25.
//

import SwiftUI
import ComfyMarkdownCore

public struct TextView: View {
    
    var text: String
    var node: MarkdownNode
    
    public var body: some View {
        switch node.type {
        case .text(let text):
            Text(text)
        default: Text("")
        }
        
    }
}
