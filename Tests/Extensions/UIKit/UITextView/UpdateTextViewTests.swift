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

@Suite("UITextView Update Tests")
@MainActor
struct UITextViewUpdateTests {

    @Test("Update textColor changes value when different")
    func updateTextColorWhenDifferent() {
        let textView = UITextView()
        textView.textColor = .red

        let newColor = UIColor.blue
        textView.update(textColor: newColor)

        #expect(textView.textColor == newColor)
    }

    @Test("Update maintains textColor when the new value is the same")
    func updateIgnoresSameTextColor() {
        let textView = UITextView()
        let color = UIColor.red
        textView.textColor = color

        textView.update(textColor: color)

        #expect(textView.textColor == color)
    }

    @Test("Update font changes value when different")
    func updateFontWhenDifferent() {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 12)

        let newFont = UIFont.systemFont(ofSize: 16)
        textView.update(font: newFont)

        #expect(textView.font == newFont)
    }

    @Test("Update maintains font when the new value is the same")
    func updateIgnoresSameFont() {
        let textView = UITextView()
        let font = UIFont.systemFont(ofSize: 12)
        textView.font = font

        textView.update(font: font)

        #expect(textView.font == font)
    }

    @Test("Update isEditable changes value when different")
    func updateIsEditableWhenDifferent() {
        let textView = UITextView()
        textView.isEditable = true

        textView.update(isEditable: false)

        #expect(textView.isEditable == false)
    }

    @Test("Update maintains isEditable state when the new value is the same")
    func updateIgnoresSameIsEditable() {
        let textView = UITextView()
        textView.isEditable = true

        textView.update(isEditable: true)

        #expect(textView.isEditable == true)
    }

    @Test("Update changes text when the new value is different")
    func updateChangesTextWhenDifferent() {
        let textView = UITextView()
        textView.text = "Initial Text"

        textView.update(text: "Updated Text")

        // The value should reflect the new text assignment.
        #expect(textView.text == "Updated Text")
    }

    @Test("Update maintains text when the new value is the same")
    func updateIgnoresSameText() {
        let textView = UITextView()
        let text = "Stable Text"
        textView.text = text

        textView.update(text: text)

        // The value should remain unchanged.
        #expect(textView.text == text)
    }

    @Test("Update changes attributedText when the new value is different")
    func updateChangesAttributedTextWhenDifferent() {
        let textView = UITextView()
        textView.attributedText = NSAttributedString(string: "Initial")

        let newAttributedText = NSAttributedString(
            string: "Updated",
            attributes: [.foregroundColor: UIColor.blue]
        )
        textView.update(attributedText: newAttributedText)

        // UITextView automatically injects default font and paragraph styles into its attributedText.
        // Therefore, we verify the update by checking the underlying string content.
        #expect(textView.attributedText?.string == "Updated")
    }

    @Test("Update maintains attributedText when the new value is the same")
    func updateIgnoresSameAttributedText() {
        let textView = UITextView()
        let initialText = NSAttributedString(
            string: "Stable",
            attributes: [.foregroundColor: UIColor.red]
        )

        // 1. Assign the text initially so UIKit can inject its default typography attributes.
        textView.attributedText = initialText

        // 2. Read back the mutated attributed string (now containing NSFont and NSParagraphStyle).
        // Force unwrap is safe here, and required since our update method now expects a non-optional value.
        let stabilizedText = textView.attributedText!

        // 3. Update using the stabilized string.
        textView.update(attributedText: stabilizedText)

        // The value should remain identical to the stabilized version.
        #expect(textView.attributedText == stabilizedText)
    }
}
