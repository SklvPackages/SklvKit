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

@Suite("UIViewController Removal Tests")
@MainActor
struct UIViewControllerRemovalTests {

    @Test("removeFromEverywhere correctly removes child and view from hierarchy")
    func removeFromEverywhere() {
        let parentController = UIViewController()
        let childController = UIViewController()

        // Setup using the standard flow (or our previously created addSubcontroller)
        parentController.addChild(childController)
        parentController.view.addSubview(childController.view)
        childController.didMove(toParent: parentController)

        // Ensure it's correctly added first
        #expect(childController.parent === parentController)
        #expect(childController.view.superview === parentController.view)

        // Perform action
        childController.removeFromEverywhere()

        // Verify view controller hierarchy is severed
        #expect(childController.parent == nil)
        #expect(parentController.children.contains(childController) == false)

        // Verify view hierarchy is severed
        #expect(childController.view.superview == nil)
    }
}
