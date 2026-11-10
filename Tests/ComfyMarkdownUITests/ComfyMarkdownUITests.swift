import XCTest
@testable import ComfyMarkdownUI
import ComfyMarkdownCore

final class ComfyMarkdownUITests: XCTestCase {
    func testTogglingLowestRepeatedTaskItemUpdatesBottomLine() throws {
        let markdown = """
        - [ ] This is some text that 
        - [ ] This is some text that 
        - [ ] This is some text that 
        """
        
        let parser = ComfyMarkdownCore()
        let ast = try XCTUnwrap(parser.parse(markdown: markdown))
        let list = try XCTUnwrap(ast.children.first)
        let bottomTaskItem = list.children[2]
        
        let updatedMarkdown = try XCTUnwrap(
            TaskMarkdownToggler.toggledMarkdown(
                text: markdown,
                node: bottomTaskItem
            )
        )
        
        XCTAssertEqual(
            updatedMarkdown,
            """
            - [ ] This is some text that 
            - [ ] This is some text that 
            - [x] This is some text that 
            """
        )
    }
    
    func testTogglingBottomTaskItemUpdatesBottomLine() throws {
        let markdown = """
        - [ ] First
        - [ ] Second
        - [ ] Third
        """
        
        let parser = ComfyMarkdownCore()
        let ast = try XCTUnwrap(parser.parse(markdown: markdown))
        let list = try XCTUnwrap(ast.children.first)
        let bottomTaskItem = list.children[2]
        
        let updatedMarkdown = try XCTUnwrap(
            TaskMarkdownToggler.toggledMarkdown(
                text: markdown,
                node: bottomTaskItem
            )
        )
        
        XCTAssertEqual(
            updatedMarkdown,
            """
            - [ ] First
            - [ ] Second
            - [x] Third
            """
        )
    }
    
    func testTogglingTaskItemFallsBackToChildSourceRange() throws {
        let markdown = """
        - [ ] This is some text that
        - [ ] This is some text that
        """
        
        let taskItemWithoutSourceRange = MarkdownNode(
            type: .listItem(checked: false),
            children: [
                MarkdownNode(
                    type: .paragraph,
                    children: [
                        MarkdownNode(
                            type: .text("This is some text that"),
                            sourceRange: MarkdownSourceRange(
                                startLine: 2,
                                startColumn: 7,
                                endLine: 2,
                                endColumn: 28
                            )
                        )
                    ],
                    sourceRange: MarkdownSourceRange(
                        startLine: 2,
                        startColumn: 7,
                        endLine: 2,
                        endColumn: 29
                    )
                )
            ],
            sourceRange: nil
        )
        
        let updatedMarkdown = try XCTUnwrap(
            TaskMarkdownToggler.toggledMarkdown(
                text: markdown,
                node: taskItemWithoutSourceRange
            )
        )
        
        XCTAssertEqual(
            updatedMarkdown,
            """
            - [ ] This is some text that
            - [x] This is some text that
            """
        )
    }
}
