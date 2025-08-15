//
//  CurrentlySupported.swift
//
//
//  Created by Aryan Rogye on 8/14/25.
//


public enum CurrentlySupported: String, CaseIterable, Hashable {
    case heading        = "Headings"
    case paragraph      = "Paragraphs"
    case thematicBreak  = "Thematic Breaks"
    case blockQuote     = "Block Quotes"
    case codeBlock      = "Code Blocks"
    case list           = "Lists"
    case listItem       = "List Items"
    case emphasis       = "Emphasis"
    
    public var icon: String {
        switch self {
        case .heading:          return "textformat.size.larger"
        case .paragraph:        return "text.alignleft"
        case .thematicBreak:    return "line.horizontal.3"
        case .blockQuote:       return "text.quote"
        case .codeBlock:        return "curlybraces.square"
        case .list:             return "list.bullet"
        case .listItem:         return "list.bullet.circle"
        case .emphasis:         return "textformat.abc"
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
        case .emphasis:
            return [
            """
            This is *italic* text and this is **bold** text.
            You can also use ***both*** together.
            """,
            """
            _Italic_ and __bold__ are also supported.
            """
            ]
        }
    }
}
