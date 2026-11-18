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

import UIKit

@MainActor
extension UITextView {
    /// Updates the text color of the text view, avoiding redundant assignments.
    ///
    /// This method checks if the new color is different from the current `textColor`
    /// before applying it, preventing unnecessary redraw cycles.
    ///
    /// - Parameter newValue: The new text color to apply.
    public func update(textColor newValue: UIColor) {
        guard newValue !== textColor else { return }
        textColor = newValue
    }

    /// Updates the font of the text view, avoiding redundant assignments.
    ///
    /// This method checks if the new font is different from the current `font`
    /// before applying it, preventing unnecessary text measurements and layout passes.
    ///
    /// - Parameter newValue: The new font to apply.
    public func update(font newValue: UIFont) {
        guard newValue !== font else { return }
        font = newValue
    }

    /// Updates the editable state of the text view, avoiding redundant assignments.
    ///
    /// - Parameter newValue: A Boolean value indicating whether the text view should be editable.
    public func update(isEditable newValue: Bool) {
        guard newValue != isEditable else { return }
        isEditable = newValue
    }

    /// Updates the text of the text view, avoiding redundant assignments.
    ///
    /// This method checks if the new text is different from the current `text`
    /// before applying it, preventing unnecessary layout invalidations and TextKit rendering passes.
    ///
    /// - Parameter newValue: The new text string to apply.
    public func update(text newValue: String) {
        guard newValue != text else { return }
        text = newValue
    }

    /// Updates the attributed text of the text view, avoiding redundant assignments.
    ///
    /// This method checks if the new attributed text is different from the current `attributedText`
    /// before applying it, preventing unnecessary layout invalidations and TextKit rendering passes.
    ///
    /// - Parameter newValue: The new attributed text to apply.
    public func update(attributedText newValue: NSAttributedString) {
        guard newValue != attributedText else { return }
        attributedText = newValue
    }
}
