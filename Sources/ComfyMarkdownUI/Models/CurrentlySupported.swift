//
//  CurrentlySupported.swift
//
//
//  Created by Aryan Rogye on 8/14/25.
//


public enum CurrentlySupported: String, CaseIterable, Hashable {
    case heading = "Headings"
    case paragraph = "Paragraphs"
    case thematicBreak = "Thematic Breaks"
    case blockQuote = "Block Quotes"
    case codeBlock = "Code Blocks"
    case list = "Lists"
    case listItem = "List Items"
    
    public var icon: String {
        switch self {
        case .heading:
            return "textformat.size.larger"      // Feels like a heading style
        case .paragraph:
            return "text.alignleft"              // Common paragraph alignment icon
        case .thematicBreak:
            return "line.horizontal.3"           // Visual horizontal divider
        case .blockQuote:
            return "text.quote"                   // Dedicated quote mark icon
        case .codeBlock:
            return "curlybraces.square"           // Matches code block visually
        case .list:
            return "list.bullet"                  // Standard list bullet icon
        case .listItem:
            return "list.bullet.circle"           // Matches list item but with emphasis
        }
    }
    
    public var examples: [String] {
        switch self {
        case .heading:
            return [
            """
            # Heading Level 1
            ## Heading Level 2
            ### Heading Level 3
            """
            ]
            
        case .paragraph:
            return [
            """
            This is a paragraph of text in Markdown.  
            It can span multiple lines and include **bold** or *italic* text.
            """
            ]
            
        case .thematicBreak:
            return [
            """
            ---
            """,
            """
            ***
            """,
            """
            ___
            """
            ]
            
        case .blockQuote:
            return [
            """
            > This is a block quote in Markdown.  
            > It can span multiple lines and is often used for quotations.
            """
            ]
            
        case .codeBlock:
            return [
            """
            ```
            let greeting = "Hello, world!"
            print(greeting)
            ```
            """,
            """
            ```swift
            struct Person {
                var name: String
            }
            ```
            """
            ]
            
        case .list:
            return [
            """
            - Item one
            - Item two
            - Item three
            """,
            """
            1. First
            2. Second
            3. Third
            """
            ]
            
        case .listItem:
            return [
            """
            - Milk
            - Bread
            - Eggs
            """,
            """
            * Apples
            * Bananas
            * Cherries
            """
            ]
        }
    }
}
