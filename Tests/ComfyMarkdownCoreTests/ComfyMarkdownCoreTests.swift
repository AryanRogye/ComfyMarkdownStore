//
//  ComfyMarkdownCoreTests.swift
//  ComfyMarkdownCore
//
//  Created by Aryan Rogye on 8/13/25.
//

import XCTest
@testable import ComfyMarkdownCore

final class ComfyMarkdownCoreTests: XCTestCase {
    
    let comfyMarkdownCore = ComfyMarkdownCore()
    
    var baseMarkdown = """
        ## Hello World
        """
    
    // MARK: - Basic Elements Tests
    
    func testSimpleHeadingAST() throws {
        let markdown = "## Hello World"
        let ast = try XCTUnwrap(comfyMarkdownCore.parse(markdown: markdown))
        
        XCTAssertEqual(ast.type, .document)
        XCTAssertEqual(ast.children.count, 1)
        
        let heading = ast.children[0]
        XCTAssertEqual(heading.type, .heading(level: 2))
        XCTAssertEqual(heading.children.count, 1)
        
        let textNode = heading.children[0]
        XCTAssertEqual(textNode.type, .text("Hello World"))
    }
    
    func testAllHeadingLevels() throws {
        let markdown = """
        # Heading 1
        ## Heading 2
        ### Heading 3
        #### Heading 4
        ##### Heading 5
        ###### Heading 6
        """
        
        let ast = try XCTUnwrap(comfyMarkdownCore.parse(markdown: markdown))
        XCTAssertEqual(ast.children.count, 6)
        
        for i in 0..<6 {
            let heading = ast.children[i]
            XCTAssertEqual(heading.type, .heading(level: i + 1))
            XCTAssertEqual(heading.children.first?.type, .text("Heading \(i + 1)"))
        }
    }
    
    func testEmphasisParsing() throws {
        let markdown = "This is *italic* and **bold**"
        let ast = try XCTUnwrap(comfyMarkdownCore.parse(markdown: markdown))
        
        // paragraph node
        XCTAssertEqual(ast.children[0].type, .paragraph)
        
        let paragraphChildren = ast.children[0].children
        XCTAssertEqual(paragraphChildren[0].type, .text("This is "))
        XCTAssertEqual(paragraphChildren[1].type, .emphasis)
        XCTAssertEqual(paragraphChildren[1].children.first?.type, .text("italic"))
        XCTAssertEqual(paragraphChildren[2].type, .text(" and "))
        XCTAssertEqual(paragraphChildren[3].type, .strong)
        XCTAssertEqual(paragraphChildren[3].children.first?.type, .text("bold"))
    }
    
    func testAlternativeEmphasisSyntax() throws {
        let markdown = "This is _italic_ and __bold__"
        let ast = try XCTUnwrap(comfyMarkdownCore.parse(markdown: markdown))
        
        let paragraphChildren = ast.children[0].children
        XCTAssertEqual(paragraphChildren[1].type, .emphasis)
        XCTAssertEqual(paragraphChildren[3].type, .strong)
    }
    
    func testNestedEmphasis() throws {
        let markdown = "***bold and italic***"
        let ast = try XCTUnwrap(comfyMarkdownCore.parse(markdown: markdown))
        
        let paragraph = ast.children[0]
        // Should have strong containing emphasis or vice versa
        XCTAssertTrue(paragraph.children.first?.type == .strong || paragraph.children.first?.type == .emphasis)
    }
    
    // MARK: - Link Tests
    
    func testInlineLinks() throws {
        let markdown = "Check out [Google](https://google.com) for search."
        let ast = try XCTUnwrap(comfyMarkdownCore.parse(markdown: markdown))
        
        let paragraphChildren = ast.children[0].children
        XCTAssertEqual(paragraphChildren[0].type, .text("Check out "))
        XCTAssertEqual(paragraphChildren[1].type, .link(url: "https://google.com", title: nil))
        XCTAssertEqual(paragraphChildren[1].children.first?.type, .text("Google"))
        XCTAssertEqual(paragraphChildren[2].type, .text(" for search."))
    }
    
    func testLinksWithTitles() throws {
        let markdown = "[GitHub](https://github.com \"The best place for code\")"
        let ast = try XCTUnwrap(comfyMarkdownCore.parse(markdown: markdown))
        
        let link = ast.children[0].children[0]
        XCTAssertEqual(link.type, .link(url: "https://github.com", title: "The best place for code"))
    }
    
    func testReferenceLinks() throws {
        let markdown = """
        This is [a reference link][1] and [another][ref].
        
        [1]: https://example.com
        [ref]: https://reference.com "Reference Title"
        """
        
        let ast = try XCTUnwrap(comfyMarkdownCore.parse(markdown: markdown))
        
        // First paragraph should contain reference links
        let paragraphChildren = ast.children[0].children
        XCTAssertEqual(paragraphChildren[1].type, .link(url: "https://example.com", title: nil))
        XCTAssertEqual(paragraphChildren[3].type, .link(url: "https://reference.com", title: "Reference Title"))
    }
    
    func testAutoLinks() throws {
        let markdown = "Visit https://example.com or email test@example.com"
        let ast = try XCTUnwrap(comfyMarkdownCore.parse(markdown: markdown))
        
        let paragraphChildren = ast.children[0].children
        // Should detect automatic links
        XCTAssertTrue(paragraphChildren.contains { child in
            if case .link(let url, _) = child.type {
                return url == "https://example.com" || url == "mailto:test@example.com"
            }
            return false
        })
    }
    
    // MARK: - Image Tests
    
    func testImages() throws {
        let markdown = "![Alt text](https://example.com/image.png)"
        let ast = try XCTUnwrap(comfyMarkdownCore.parse(markdown: markdown))
        
        let image = ast.children[0].children[0]
        XCTAssertEqual(image.type, .image(url: "https://example.com/image.png", title: nil))
        
        // Alt text should be in the image's children as text nodes
        XCTAssertEqual(image.children.first?.type, .text("Alt text"))
    }
    
    func testImagesWithTitles() throws {
        let markdown = "![Alt](image.png \"Image Title\")"
        let ast = try XCTUnwrap(comfyMarkdownCore.parse(markdown: markdown))
        
        let image = ast.children[0].children[0]
        XCTAssertEqual(image.type, .image(url: "image.png", title: "Image Title"))
        
        // Alt text should be in the image's children as text nodes
        XCTAssertEqual(image.children.first?.type, .text("Alt"))
    }
    
    // MARK: - List Tests
    
    func testUnorderedList() throws {
        let markdown = """
        - Item 1
        - Item 2
        - Item 3
        """
        
        let ast = try XCTUnwrap(comfyMarkdownCore.parse(markdown: markdown))
        
        let list = ast.children[0]
        XCTAssertEqual(list.type, .list(ordered: false, start: 1, tight: true, delimiter: nil))
        XCTAssertEqual(list.children.count, 3)
        
        for i in 0..<3 {
            let listItem = list.children[i]
            XCTAssertEqual(listItem.type, .listItem)
            XCTAssertEqual(listItem.children.first?.children.first?.type, .text("Item \(i + 1)"))
        }
    }
    
    func testOrderedList() throws {
        let markdown = """
        1. First item
        2. Second item
        3. Third item
        """
        
        let ast = try XCTUnwrap(comfyMarkdownCore.parse(markdown: markdown))
        
        let list = ast.children[0]
        XCTAssertEqual(list.type, .list(ordered: true, start: 1, tight: true, delimiter: "."))
        XCTAssertEqual(list.children.count, 3)
    }
    
    func testNestedLists() throws {
        let markdown = """
        - Item 1
          - Nested item 1
          - Nested item 2
        - Item 2
        """
        
        let ast = try XCTUnwrap(comfyMarkdownCore.parse(markdown: markdown))
        
        let list = ast.children[0]
        XCTAssertEqual(list.children.count, 2)
        
        let firstItem = list.children[0]
        XCTAssertTrue(firstItem.children.count >= 2) // paragraph + nested list
        
        let nestedList = firstItem.children[1]
        XCTAssertEqual(nestedList.type, .list(ordered: false, start: 1, tight: true, delimiter: nil))
        XCTAssertEqual(nestedList.children.count, 2)
    }
    
    func testLooseList() throws {
        let markdown = """
        - Item 1
        
          With a paragraph
        
        - Item 2
        """
        
        let ast = try XCTUnwrap(comfyMarkdownCore.parse(markdown: markdown))
        
        let list = ast.children[0]
        XCTAssertEqual(list.type, .list(ordered: false, start: 1, tight: false, delimiter: nil))
    }
    
    // MARK: - Code Tests
    
    func testInlineCode() throws {
        let markdown = "Use the `print()` function to output text."
        let ast = try XCTUnwrap(comfyMarkdownCore.parse(markdown: markdown))
        
        let paragraphChildren = ast.children[0].children
        XCTAssertEqual(paragraphChildren[0].type, .text("Use the "))
        XCTAssertEqual(paragraphChildren[1].type, .code("print()"))
        XCTAssertEqual(paragraphChildren[2].type, .text(" function to output text."))
    }
    
    func testCodeBlock() throws {
        let markdown = """
        ```swift
        func hello() {
            print("Hello, World!")
        }
        ```
        """
        
        let ast = try XCTUnwrap(comfyMarkdownCore.parse(markdown: markdown))
        
        let codeBlock = ast.children[0]
        XCTAssertEqual(codeBlock.type, .codeBlock(info: "swift", literal: "func hello() {\n    print(\"Hello, World!\")\n}"))
    }
    
    func testIndentedCodeBlock() throws {
        let markdown = """
        Regular paragraph.
        
            This is an indented code block
            with multiple lines
        """
        
        let ast = try XCTUnwrap(comfyMarkdownCore.parse(markdown: markdown))
        XCTAssertEqual(ast.children.count, 2)
        
        let codeBlock = ast.children[1]
        XCTAssertEqual(codeBlock.type, .codeBlock(info: nil, literal: "This is an indented code block\nwith multiple lines"))
    }
    
    // MARK: - Blockquote Tests
    
    func testSimpleBlockquote() throws {
        let markdown = "> This is a blockquote."
        let ast = try XCTUnwrap(comfyMarkdownCore.parse(markdown: markdown))
        
        let blockquote = ast.children[0]
        XCTAssertEqual(blockquote.type, .blockQuote)
        
        let paragraph = blockquote.children[0]
        XCTAssertEqual(paragraph.type, .paragraph)
        XCTAssertEqual(paragraph.children.first?.type, .text("This is a blockquote."))
    }
    
    func testNestedBlockquotes() throws {
        let markdown = """
        > Level 1
        > > Level 2
        > > > Level 3
        """
        
        let ast = try XCTUnwrap(comfyMarkdownCore.parse(markdown: markdown))
        
        let outerQuote = ast.children[0]
        XCTAssertEqual(outerQuote.type, .blockQuote)
        
        // Should contain nested blockquotes
        XCTAssertTrue(outerQuote.children.contains { child in
            child.type == .blockQuote
        })
    }
    
    func testBlockquoteWithOtherElements() throws {
        let markdown = """
        > ## Heading in blockquote
        > 
        > - List item 1
        > - List item 2
        > 
        > `inline code` in blockquote
        """
        
        let ast = try XCTUnwrap(comfyMarkdownCore.parse(markdown: markdown))
        
        let blockquote = ast.children[0]
        XCTAssertEqual(blockquote.type, .blockQuote)
        XCTAssertTrue(blockquote.children.count > 1)
        
        // Should contain heading, list, and paragraph
        let childTypes = blockquote.children.map { $0.type }
        XCTAssertTrue(childTypes.contains { type in
            if case .heading(_) = type { return true }
            return false
        })
        XCTAssertTrue(childTypes.contains { type in
            if case .list(_, _, _, _) = type { return true }
            return false
        })
    }
    
    // MARK: - HTML and Custom Elements Tests
    
    func testHTMLBlock() throws {
        let markdown = """
        <div class="custom">
        <p>HTML content</p>
        </div>
        """
        
        let ast = try XCTUnwrap(comfyMarkdownCore.parse(markdown: markdown))
        
        let htmlBlock = ast.children[0]
        if case .htmlBlock(let html) = htmlBlock.type {
            XCTAssertTrue(html.contains("div"))
            XCTAssertTrue(html.contains("custom"))
        } else {
            XCTFail("Expected HTML block")
        }
    }
    
    func testHTMLInline() throws {
        let markdown = "This has <span>inline HTML</span> in it."
        let ast = try XCTUnwrap(comfyMarkdownCore.parse(markdown: markdown))
        
        let paragraphChildren = ast.children[0].children
        XCTAssertTrue(paragraphChildren.contains { child in
            if case .htmlInline(let html) = child.type {
                return html.contains("span")
            }
            return false
        })
    }
    
    func testSoftBreak() throws {
        let markdown = "Line one\nLine two"
        let ast = try XCTUnwrap(comfyMarkdownCore.parse(markdown: markdown))
        
        let paragraphChildren = ast.children[0].children
        XCTAssertTrue(paragraphChildren.contains { child in
            child.type == .softBreak
        })
    }
    
    func testLineBreak() throws {
        let markdown = "Line one  \nLine two"  // Two spaces before newline
        let ast = try XCTUnwrap(comfyMarkdownCore.parse(markdown: markdown))
        
        let paragraphChildren = ast.children[0].children
        XCTAssertTrue(paragraphChildren.contains { child in
            child.type == .lineBreak
        })
    }
    
    // MARK: - Horizontal Rule Tests
    
    func testHorizontalRule() throws {
        let markdown = """
        Before rule
        
        ---
        
        After rule
        """
        
        let ast = try XCTUnwrap(comfyMarkdownCore.parse(markdown: markdown))
        XCTAssertEqual(ast.children.count, 3)
        
        let rule = ast.children[1]
        XCTAssertEqual(rule.type, .thematicBreak)
    }
    
    func testAlternativeHorizontalRules() throws {
        let variations = ["---", "***", "___", "- - -", "* * *", "_ _ _"]
        
        for variation in variations {
            let ast = try XCTUnwrap(comfyMarkdownCore.parse(markdown: variation))
            XCTAssertEqual(ast.children.first?.type, .thematicBreak, "Failed for: \(variation)")
        }
    }
    
    // MARK: - Complex Document Tests
    
    func testComplexDocument() throws {
        let markdown = """
        # Main Title
        
        This document has **multiple** elements including:
        
        - [Links](https://example.com)
        - `inline code`
        - ![images](image.png)
        
        ## Code Section
        
        ```python
        def hello():
            return "world"
        ```
        
        > This is a blockquote with *emphasis*
        > and multiple lines.
        
        | Table | Example |
        |-------|---------|
        | Row 1 | Data 1  |
        | Row 2 | Data 2  |
        """
        
        let ast = try XCTUnwrap(comfyMarkdownCore.parse(markdown: markdown))
        
        // Should have multiple top-level elements
        XCTAssertTrue(ast.children.count >= 6)
        
        // Verify main heading
        let mainHeading = ast.children[0]
        XCTAssertEqual(mainHeading.type, .heading(level: 1))
        
        // Should contain various element types
        let elementTypes = ast.children.map { $0.type }
        XCTAssertTrue(elementTypes.contains { type in
            if case .heading(_) = type { return true }
            return false
        })
        XCTAssertTrue(elementTypes.contains { type in
            if case .list(_, _, _, _) = type { return true }
            return false
        })
        XCTAssertTrue(elementTypes.contains { type in
            if case .codeBlock(_, _) = type { return true }
            return false
        })
        XCTAssertTrue(elementTypes.contains(.blockQuote))
    }
    
    // MARK: - Edge Cases and Error Handling
    
    func testEmptyDocument() throws {
        let ast = try XCTUnwrap(comfyMarkdownCore.parse(markdown: ""))
        XCTAssertEqual(ast.type, .document)
        XCTAssertEqual(ast.children.count, 0)
    }
    
    func testWhitespaceOnlyDocument() throws {
        let ast = try XCTUnwrap(comfyMarkdownCore.parse(markdown: "   \n\n   \t  \n"))
        XCTAssertEqual(ast.type, .document)
        // Should either be empty or contain empty paragraphs
        XCTAssertTrue(ast.children.count <= 1)
    }
    
    func testMalformedMarkdown() throws {
        let malformedCases = [
            "# Heading without closing",
            "[Link without closing paren](https://example.com",
            "![Image without closing](image.png",
            "`unclosed inline code",
            "```\nunclosed code block"
        ]
        
        for markdown in malformedCases {
            // Should not crash, should handle gracefully
            let ast = try XCTUnwrap(comfyMarkdownCore.parse(markdown: markdown))
            XCTAssertEqual(ast.type, .document)
            // Each should produce some valid AST structure
            XCTAssertTrue(ast.children.count >= 0)
        }
    }
    
    // MARK: - Performance Tests
    
    func testLargeDocumentPerformance() throws {
        let largeMarkdown = String(repeating: "## Heading\n\nParagraph with **bold** and *italic* text.\n\n", count: 1000)
        
        measure {
            _ = try? comfyMarkdownCore.parse(markdown: largeMarkdown)
        }
    }
    
    func testNestedStructurePerformance() throws {
        var nestedMarkdown = ""
        for i in 1...50 {
            nestedMarkdown += String(repeating: "> ", count: i) + "Level \(i)\n"
        }
        
        measure {
            _ = try? comfyMarkdownCore.parse(markdown: nestedMarkdown)
        }
    }
    
    // MARK: - Regression Tests
    
    func testCommonMarkdownPatterns() throws {
        let patterns = [
            "**Bold** and *italic* in same paragraph",
            "[Link](https://example.com) followed by text",
            "`code` with following text",
            "Text before ![image](img.png) and after",
            "- List item with [link](https://example.com)",
            "> Quote with **emphasis**",
            "# Heading with `code`"
        ]
        
        for pattern in patterns {
            let ast = try XCTUnwrap(comfyMarkdownCore.parse(markdown: pattern))
            XCTAssertEqual(ast.type, .document)
            XCTAssertTrue(ast.children.count > 0, "Failed to parse: \(pattern)")
        }
    }
}
