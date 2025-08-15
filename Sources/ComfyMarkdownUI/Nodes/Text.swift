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
            //        case .emphasis:
            //            node.children.reduce(into: Text("")) { partial, child in
            //                partial + TextView(text: child.plainText, node: child).body.italic()
            //            }
            //        case .strong:
            //            node.children.reduce(into: Text("")) { partial, child in
            //                partial + TextView(text: text, node: child).bold()
            //            }
        default: Text("")
        }
        
    }
}
