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

@Suite("UITextField Placeholder Update Tests")
@MainActor
struct UITextFieldPlaceholderTests {

    @Test("Update placeholder immediately without animation")
    func updatePlaceholderImmediately() {
        let textField = UITextField()
        textField.placeholder = "Old Placeholder"

        var isCompletionCalled = false

        textField.update(placeholder: "New Placeholder", animated: false) { finished in
            isCompletionCalled = true
        }

        #expect(textField.placeholder == "New Placeholder")
        #expect(isCompletionCalled)
    }

    @Test("Update placeholder immediately when text is not empty, ignoring animation request")
    func updatePlaceholderImmediatelyWhenTextNotEmpty() {
        let textField = UITextField()
        textField.text = "User Input"
        textField.placeholder = "Old Placeholder"

        var isCompletionCalled = false

        textField.update(placeholder: "New Placeholder", animated: true) { finished in
            isCompletionCalled = true
        }

        #expect(textField.placeholder == "New Placeholder")
        #expect(isCompletionCalled)
    }

    @Test("Update placeholder with animation when text is empty")
    func updatePlaceholderAnimatedEmptyText() async {
        let textField = UITextField()
        textField.text = ""
        textField.placeholder = "Old Placeholder"

        await withCheckedContinuation { continuation in
            textField.update(placeholder: "New Placeholder", animated: true) { _ in
                continuation.resume()
            }
        }

        #expect(textField.placeholder == "New Placeholder")
    }
}
