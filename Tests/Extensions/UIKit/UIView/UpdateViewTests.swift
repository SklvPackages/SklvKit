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

@Suite("UIView Property Update Tests")
@MainActor
struct UIViewUpdateTests {

    @Test("Update layoutMargins changes value when different")
    func updateLayoutMargins() {
        let view = UIView()
        let initialInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        let newInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

        view.layoutMargins = initialInsets
        view.update(layoutMargins: newInsets)

        #expect(view.layoutMargins == newInsets)
    }

    @Test("Update geometry properties changes values when different")
    func updateGeometry() {
        let view = UIView(frame: .zero)

        view.update(frame: CGRect(x: 10, y: 10, width: 100, height: 100))
        #expect(view.frame == CGRect(x: 10, y: 10, width: 100, height: 100))

        view.update(origin: CGPoint(x: 20, y: 20))
        #expect(view.frame.origin == CGPoint(x: 20, y: 20))

        view.update(size: CGSize(width: 50, height: 50))
        #expect(view.frame.size == CGSize(width: 50, height: 50))

        view.update(x: 30)
        #expect(view.frame.origin.x == 30)

        view.update(y: 40)
        #expect(view.frame.origin.y == 40)

        view.update(width: 60)
        #expect(view.frame.size.width == 60)

        view.update(height: 70)
        #expect(view.frame.size.height == 70)
    }

    @Test("Update appearance properties changes values when different")
    func updateAppearance() {
        let view = UIView()

        view.update(backgroundColor: .red)
        #expect(view.backgroundColor == .red)

        view.update(tintColor: .blue)
        #expect(view.tintColor == .blue)

        view.alpha = 1.0
        view.update(alpha: 0.5)
        #expect(view.alpha == 0.5)
    }

    @Test("Update state properties changes values when different")
    func updateState() {
        let view = UIView()

        view.isHidden = false
        view.update(isHidden: true)
        #expect(view.isHidden == true)

        view.isUserInteractionEnabled = true
        view.update(isUserInteractionEnabled: false)
        #expect(view.isUserInteractionEnabled == false)
    }
}
