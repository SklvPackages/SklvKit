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

@Suite("UIView Border Tests")
@MainActor
struct UIViewBorderTests {

    @Test("Set border width changes value when different")
    func setBorderWidthChangesWhenDifferent() {
        let view = UIView()
        view.layer.borderWidth = 1.0

        view.setBorder(width: 2.0)

        #expect(view.layer.borderWidth == 2.0)
    }

    @Test("Set border width maintains value when the same")
    func setBorderWidthIgnoresSameValue() {
        let view = UIView()
        view.layer.borderWidth = 3.0

        view.setBorder(width: 3.0)

        #expect(view.layer.borderWidth == 3.0)
    }

    @Test("Set border color changes value when different")
    func setBorderColorChangesWhenDifferent() {
        let view = UIView()
        view.layer.borderColor = UIColor.red.cgColor

        let newColor = UIColor.blue
        view.setBorder(color: newColor)

        #expect(view.layer.borderColor == newColor.cgColor)
    }

    @Test("Set border color maintains value when the same")
    func setBorderColorIgnoresSameValue() {
        let view = UIView()
        let color = UIColor.green
        view.layer.borderColor = color.cgColor

        view.setBorder(color: color)

        #expect(view.layer.borderColor == color.cgColor)
    }

    @Test("Set border width and color updates both properties")
    func setBorderWidthAndColor() {
        let view = UIView()
        let color = UIColor.cyan

        view.setBorder(width: 5.0, color: color)

        #expect(view.layer.borderWidth == 5.0)
        #expect(view.layer.borderColor == color.cgColor)
    }
}
