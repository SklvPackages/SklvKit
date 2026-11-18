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

@Suite("String Size Calculation Tests")
struct StringSizeTests {
    let font = UIFont.systemFont(ofSize: 16)
    let width: CGFloat = 100

    @Test("Calculates height for a single line of text with no limits")
    func singleLineNoLimit() {
        let text = "Short text"
        let expected = font.lineHeight.rounded(.up)

        // We compare against the rounded up line height to match the method's
        // rounding behavior and prevent precision issues.
        #expect(text.height(width: width, font: font) == expected)
    }

    @Test("Calculates height for text wrapping into multiple lines")
    func multilineNoLimit() {
        let text = "This is a significantly longer string that will definitely wrap to multiple lines."
        let singleLine = font.lineHeight.rounded(.up)

        // A wrapped string must inherently exceed the height of a single line.
        #expect(text.height(width: width, font: font) > singleLine)
    }

    @Test("Constrains height to a specific number of lines")
    func constrainedLines() {
        let text = "Line 1\nLine 2\nLine 3\nLine 4"
        let expectedMax = (font.lineHeight * 2).rounded(.up)

        // We enforce numberOfLines = 2, so the height should strictly equal
        // the calculated maximum height for two lines.
        #expect(text.height(width: width, font: font, numberOfLines: 2) == expectedMax)
    }

    @Test("Returns zero height for an empty string")
    func emptyString() {
        let text = ""

        // An empty string shouldn't take up any vertical space.
        #expect(text.height(width: width, font: font) == 0)
    }
}
