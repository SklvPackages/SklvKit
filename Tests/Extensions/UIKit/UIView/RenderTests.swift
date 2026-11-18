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

@Suite("UIView Render Tests")
@MainActor
struct UIViewRenderTests {

    @Test("Renders view with valid bounds into an image")
    func rendersValidView() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.backgroundColor = .red

        let image = view.render

        #expect(image.size.width == 100)
        #expect(image.size.height == 100)
    }

    @Test("Returns empty image for view with zero bounds")
    func rendersZeroBoundsView() {
        let view = UIView(frame: .zero)

        let image = view.render

        #expect(image.size == .zero)
    }

    @Test("Renders subviews correctly")
    func rendersHierarchy() {
        let parentView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        let childView = UIView(frame: CGRect(x: 50, y: 50, width: 100, height: 100))
        parentView.addSubview(childView)

        let image = parentView.render

        // The resulting image should still match the parent's bounds
        #expect(image.size.width == 200)
        #expect(image.size.height == 200)
    }
}
