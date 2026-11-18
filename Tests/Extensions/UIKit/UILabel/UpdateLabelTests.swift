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

@Suite("UILabel Update Tests")
@MainActor
struct UILabelUpdateTests {

    @Test("Update changes textColor when the new value is different")
    func updateChangesTextColorWhenDifferent() {
        let label = UILabel()
        label.textColor = .red

        label.update(textColor: .blue)

        #expect(label.textColor == .blue)
    }

    @Test("Update maintains textColor when the new value is the same")
    func updateIgnoresSameTextColor() {
        let label = UILabel()
        let color = UIColor.red
        label.textColor = color

        label.update(textColor: color)

        #expect(label.textColor == color)
    }

    @Test("Update changes font when the new value is different")
    func updateChangesFontWhenDifferent() {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)

        let newFont = UIFont.systemFont(ofSize: 16)
        label.update(font: newFont)

        #expect(label.font == newFont)
    }

    @Test("Update maintains font when the new value is the same")
    func updateIgnoresSameFont() {
        let label = UILabel()
        let font = UIFont.systemFont(ofSize: 12)
        label.font = font

        label.update(font: font)

        #expect(label.font == font)
    }

    @Test("Updates numberOfLines when a new value is provided")
    func updatesToNewValue() {
        let label = UILabel()
        label.numberOfLines = 1

        label.update(numberOfLines: 0)

        // The value should reflect the new assignment.
        #expect(label.numberOfLines == 0)
    }

    @Test("Maintains numberOfLines when the same value is provided")
    func maintainsSameValue() {
        let label = UILabel()
        label.numberOfLines = 2

        label.update(numberOfLines: 2)

        // The value should remain unchanged.
        #expect(label.numberOfLines == 2)
    }

    @Test("Update changes text when the new value is different")
    func updateChangesTextWhenDifferent() {
        let label = UILabel()
        label.text = "Initial Text"

        label.update(text: "Updated Text")

        // The value should reflect the new text assignment.
        #expect(label.text == "Updated Text")
    }

    @Test("Update maintains text when the new value is the same")
    func updateIgnoresSameText() {
        let label = UILabel()
        let text = "Stable Text"
        label.text = text

        label.update(text: text)

        // The value should remain unchanged.
        #expect(label.text == text)
    }

    @Test("Update changes attributedText when the new value is different")
    func updateChangesAttributedTextWhenDifferent() {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "Initial")

        let newAttributedText = NSAttributedString(
            string: "Updated",
            attributes: [.foregroundColor: UIColor.blue]
        )
        label.update(attributedText: newAttributedText)

        // The value should reflect the new attributed text assignment.
        #expect(label.attributedText == newAttributedText)
    }

    @Test("Update maintains attributedText when the new value is the same")
    func updateIgnoresSameAttributedText() {
        let label = UILabel()
        let attributedText = NSAttributedString(
            string: "Stable",
            attributes: [.foregroundColor: UIColor.red]
        )
        label.attributedText = attributedText

        label.update(attributedText: attributedText)

        // The value should remain unchanged.
        #expect(label.attributedText == attributedText)
    }
}
