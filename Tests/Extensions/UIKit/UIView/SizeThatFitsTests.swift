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

@Suite("UIView Size Calculation Tests")
@MainActor
struct UIViewSizeCalculationTests {

    // A mock view designed to return fractional sizes to test the `rounded(.up)` logic
    // and verify the correct axes are constrained.
    private class MockSizeView: UIView {
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            let isWidthConstrained = size.width != .greatestFiniteMagnitude
            let isHeightConstrained = size.height != .greatestFiniteMagnitude

            if isWidthConstrained && !isHeightConstrained {
                // Testing height(for: width)
                return CGSize(width: size.width, height: 15.2)
            } else if !isWidthConstrained && isHeightConstrained {
                // Testing width(for: height)
                return CGSize(width: 20.8, height: size.height)
            } else {
                // Testing unconstrained sizeThatFits property
                return CGSize(width: 30.1, height: 40.9)
            }
        }
    }

    @Test("sizeThatFits property rounds up unconstrained dimensions")
    func unconstrainedSizeThatFits() {
        let view = MockSizeView()
        let size = view.sizeThatFits

        // 30.1 -> 31.0, 40.9 -> 41.0
        #expect(size.width == 31.0)
        #expect(size.height == 41.0)
    }

    @Test("width(for:) respects height constraint and rounds up")
    func widthForHeight() {
        let view = MockSizeView()
        let width = view.width(for: 100)

        // 20.8 -> 21.0
        #expect(width == 21.0)
    }

    @Test("height(for:) respects width constraint and rounds up")
    func heightForWidth() {
        let view = MockSizeView()
        let height = view.height(for: 100)

        // 15.2 -> 16.0
        #expect(height == 16.0)
    }
}
