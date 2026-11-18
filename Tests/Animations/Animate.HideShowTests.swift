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

@Suite("UIView Visibility Update Tests")
@MainActor
struct UIViewVisibilityTests {

    @Test("Hide view immediately without animation")
    func hideImmediately() {
        let view = UIView()
        view.alpha = 1.0
        view.isHidden = false

        var isCompletionCalled = false

        view.hide(animated: false) { finished in
            isCompletionCalled = true
        }

        #expect(view.alpha == 0.0)
        #expect(view.isHidden == true)
        #expect(isCompletionCalled)
    }

    @Test("Show view immediately without animation")
    func showImmediately() {
        let view = UIView()
        view.alpha = 0.0
        view.isHidden = true

        var isCompletionCalled = false

        view.show(animated: false) { finished in
            isCompletionCalled = true
        }

        #expect(view.alpha == 1.0)
        #expect(view.isHidden == false)
        #expect(isCompletionCalled)
    }

    @Test("Hide view with animation")
    func hideAnimated() async {
        let view = UIView()
        view.alpha = 1.0
        view.isHidden = false

        await withCheckedContinuation { continuation in
            view.hide(animated: true) { _ in
                continuation.resume()
            }
        }

        #expect(view.alpha == 0.0)
//        #expect(view.isHidden == true)
    }

    @Test("Show view with animation")
    func showAnimated() async {
        let view = UIView()
        view.alpha = 0.0
        view.isHidden = true

        await withCheckedContinuation { continuation in
            view.show(animated: true) { _ in
                continuation.resume()
            }
        }

        #expect(view.alpha == 1.0)
        #expect(view.isHidden == false)
    }
}
