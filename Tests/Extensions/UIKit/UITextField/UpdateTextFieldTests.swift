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

@Suite("UITextField Update Tests")
@MainActor
struct UITextFieldUpdateTests {

    @Test("Update textColor changes value when different")
    func updateTextColorWhenDifferent() {
        let textField = UITextField()
        textField.textColor = .red

        let newColor = UIColor.blue
        textField.update(textColor: newColor)

        #expect(textField.textColor == newColor)
    }

    @Test("Update font changes value when different")
    func updateFontWhenDifferent() {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 12)

        let newFont = UIFont.systemFont(ofSize: 16)
        textField.update(font: newFont)

        #expect(textField.font == newFont)
    }

    @Test("Update changes placeholder when the new value is different")
    func updateChangesPlaceholderWhenDifferent() {
        let textField = UITextField()
        textField.placeholder = "Initial Text"

        textField.update(placeholder: "Updated Text")

        // The value should reflect the new text assignment.
        #expect(textField.placeholder == "Updated Text")
    }

    @Test("Update maintains placeholder when the new value is the same")
    func updateIgnoresSamePlaceholder() {
        let textField = UITextField()
        let text = "Stable Text"
        textField.placeholder = text

        textField.update(placeholder: text)

        // The value should remain unchanged.
        #expect(textField.placeholder == text)
    }

    @Test("Update changes text when the new value is different")
    func updateChangesTextWhenDifferent() {
        let textField = UITextField()
        textField.text = "Initial Text"

        textField.update(text: "Updated Text")

        // The value should reflect the new text assignment.
        #expect(textField.text == "Updated Text")
    }

    @Test("Update maintains text when the new value is the same")
    func updateIgnoresSameText() {
        let textField = UITextField()
        let text = "Stable Text"
        textField.text = text

        textField.update(text: text)

        // The value should remain unchanged.
        #expect(textField.text == text)
    }

    @Test("Update changes attributedText when the new value is different")
    func updateChangesAttributedTextWhenDifferent() {
        let textField = UITextField()
        textField.attributedText = NSAttributedString(string: "Initial")

        let newAttributedText = NSAttributedString(
            string: "Updated",
            attributes: [.foregroundColor: UIColor.blue]
        )
        textField.update(attributedText: newAttributedText)

        // UITextField automatically injects default font and paragraph styles into its attributedText.
        // Therefore, we verify the update by checking the underlying string content rather than strict equality.
        #expect(textField.attributedText?.string == "Updated")
    }

    @Test("Update maintains attributedText when the new value is the same")
    func updateIgnoresSameAttributedText() {
        let textField = UITextField()
        let initialText = NSAttributedString(
            string: "Stable",
            attributes: [.foregroundColor: UIColor.red]
        )

        // 1. Assign the text initially so UIKit can inject its default typography attributes.
        textField.attributedText = initialText

        // 2. Read back the mutated attributed string (now containing NSFont and NSParagraphStyle).
        let stabilizedText = textField.attributedText

        // 3. Update using the stabilized string.
        textField.update(attributedText: stabilizedText)

        // The value should remain identical to the stabilized version.
        #expect(textField.attributedText == stabilizedText)
    }
}
