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

@Suite("UIFont Menlo Tests")
@MainActor
struct UIFontMenloTests {

    @Test("Creates regular Menlo font for light weight")
    func createsRegularMenloForLightWeight() {
        let font = UIFont.menloFont(ofSize: 14, weight: .light)

        #expect(font != nil)
        #expect(font?.fontName == "Menlo-Regular")
        #expect(font?.pointSize == 14)
    }

    @Test("Creates bold Menlo font for heavy weight")
    func createsBoldMenloForHeavyWeight() {
        let font = UIFont.menloFont(ofSize: 16, weight: .heavy)

        #expect(font != nil)
        #expect(font?.fontName == "Menlo-Bold")
        #expect(font?.pointSize == 16)
    }

    @Test("Creates preferred Menlo font matching text style size")
    func createsPreferredMenloFont() {
        let style: UIFont.TextStyle = .body
        let expectedSize = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style).pointSize

        let font = UIFont.preferredMenloFont(forTextStyle: style, weight: .regular)

        #expect(font != nil)
        #expect(font?.fontName.contains("Menlo") == true)
        #expect(font?.pointSize == expectedSize)
    }
}
