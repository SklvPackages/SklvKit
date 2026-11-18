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

@Suite("UILabel Text Update Tests")
@MainActor
struct UILabelTextUpdateTests {

    @Test("Update text immediately without animation")
    func updateTextImmediately() {
        let label = UILabel()
        label.text = "Old Text"

        var isCompletionCalled = false

        label.update(text: "New Text", animated: false) { finished in
            isCompletionCalled = true
        }

        #expect(label.text == "New Text")
        #expect(isCompletionCalled)
    }

    @Test("Update text with animation")
    func updateTextAnimated() async {
        let label = UILabel()
        label.text = "Old Text"

        await withCheckedContinuation { continuation in
            label.update(text: "New Text", animated: true) { _ in
                continuation.resume()
            }
        }

        #expect(label.text == "New Text")
    }

    @Test("Update attributed text immediately without animation")
    func updateAttributedTextImmediately() {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "Old Attributed")
        let newAttributedText = NSAttributedString(string: "New Attributed")

        var isCompletionCalled = false

        label.update(attributedText: newAttributedText, animated: false) { finished in
            isCompletionCalled = true
        }

        #expect(label.attributedText?.string == "New Attributed")
        #expect(isCompletionCalled)
    }

    @Test("Update attributed text with animation")
    func updateAttributedTextAnimated() async {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "Old Attributed")
        let newAttributedText = NSAttributedString(string: "New Attributed")

        await withCheckedContinuation { continuation in
            label.update(attributedText: newAttributedText, animated: true) { _ in
                continuation.resume()
            }
        }

        #expect(label.attributedText?.string == "New Attributed")
    }
}
