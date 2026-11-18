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

@Suite("UIFont Preferred Font Tests")
@MainActor
struct UIFontPreferredFontTests {

    @Test("Creates preferred system font with specific weight and matches style size")
    func createsPreferredSystemFontWithWeight() {
        let style: UIFont.TextStyle = .title1
        let expectedSize = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style).pointSize

        let font = UIFont.preferredFont(forTextStyle: style, weight: .heavy)

        // Ensure the generated font matches the expected size for the style
        #expect(font.pointSize == expectedSize)

        // Ensure it successfully created a font (system font with heavy weight
        // usually includes "Heavy" or "Black" in its internal fontName).
        #expect(font.fontName.lowercased().contains("heavy") || font.fontName.lowercased().contains("black"))
    }

    @Test("Creates preferred system font with regular weight")
    func createsPreferredSystemFontWithRegularWeight() {
        let style: UIFont.TextStyle = .footnote
        let expectedSize = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style).pointSize

        let font = UIFont.preferredFont(forTextStyle: style, weight: .regular)

        #expect(font.pointSize == expectedSize)
    }
}
