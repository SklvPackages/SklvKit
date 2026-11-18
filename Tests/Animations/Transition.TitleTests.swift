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

@Suite("UIViewController Title Update Tests")
@MainActor
struct UIViewControllerTitleUpdateTests {

    @Test("Update title immediately without navigation controller")
    func updateTitleWithoutNavigationController() {
        let viewController = UIViewController()
        viewController.title = "Old Title"

        var isCompletionCalled = false

        viewController.update(title: "New Title", animated: true) { finished in
            isCompletionCalled = true
        }

        #expect(viewController.title == "New Title")
        #expect(isCompletionCalled)
    }

    @Test("Update title immediately with navigation controller")
    func updateTitleImmediatelyWithNavigationController() {
        let viewController = UIViewController()
        _ = UINavigationController(rootViewController: viewController)
        viewController.title = "Old Title"

        var isCompletionCalled = false

        viewController.update(title: "New Title", animated: false) { finished in
            isCompletionCalled = true
        }

        #expect(viewController.title == "New Title")
        #expect(isCompletionCalled)
    }

    @Test("Update title with animation via navigation bar")
    func updateTitleAnimatedWithNavigationController() async {
        let viewController = UIViewController()
        _ = UINavigationController(rootViewController: viewController)
        viewController.title = "Old Title"

        await withCheckedContinuation { continuation in
            viewController.update(title: "New Title", animated: true) { _ in
                continuation.resume()
            }
        }

        #expect(viewController.title == "New Title")
    }
}
