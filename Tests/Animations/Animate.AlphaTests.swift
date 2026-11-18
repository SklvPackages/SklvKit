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

@Suite("UIView Animation Extensions Tests")
@MainActor
struct UIViewAnimationTests {

    @Test("Update alpha immediately without animation")
    func updateAlphaImmediately() {
        let view = UIView()
        view.alpha = 1.0

        var isCompletionCalled = false

        view.update(alpha: 0.5, animated: false) { finished in
            isCompletionCalled = true
        }

        #expect(view.alpha == 0.5)
        #expect(isCompletionCalled)
    }

    @Test("Update alpha with animation")
    func updateAlphaAnimated() async {
        let view = UIView()
        view.alpha = 1.0

        await withCheckedContinuation { continuation in
            view.update(alpha: 0.0, animated: true) { _ in
                continuation.resume()
            }
        }

        #expect(view.alpha == 0.0)
    }
}
