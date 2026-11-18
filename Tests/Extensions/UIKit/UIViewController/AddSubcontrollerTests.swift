//
//  Copyright (c) 2026 Andrew Sokolov
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Testing
import UIKit
@testable import SklvKit

@Suite("UIViewController Child Management Tests")
@MainActor
struct UIViewControllerChildTests {

    @Test("addSubcontroller correctly adds child and view hierarchy")
    func addSubcontroller() {
        let parentController = UIViewController()
        let childController = UIViewController()

        // Ensure initial state
        #expect(parentController.children.isEmpty)
        #expect(childController.parent == nil)
        #expect(childController.view.superview == nil)

        // Perform action
        parentController.addSubcontroller(childController)

        // Verify view controller hierarchy
        #expect(parentController.children.contains(childController))
        #expect(childController.parent === parentController)

        // Verify view hierarchy
        #expect(childController.view.superview === parentController.view)
        #expect(parentController.view.subviews.contains(childController.view))
    }
}
