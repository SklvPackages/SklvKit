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
extension UIFont {
    /// Returns the system font associated with the specified text style, weight, and trait collection.
    ///
    /// This method extracts the current point size for the given text style,
    /// compatible with the provided trait collection, and creates a system font
    /// with that size and the requested weight.
    ///
    /// - Parameters:
    ///   - style: The text style for which to return a font.
    ///   - weight: The requested weight of the font.
    ///   - traitCollection: The trait collection to use for resolving the text style size.
    /// - Returns: A system font object sized appropriately for the specified text style and trait collection with the given weight.
    public static func preferredFont(
        forTextStyle style: UIFont.TextStyle,
        weight: UIFont.Weight,
        compatibleWith traitCollection: UITraitCollection? = nil
    ) -> UIFont {
        .systemFont(
            ofSize: UIFontDescriptor.preferredFontDescriptor(
                withTextStyle: style,
                compatibleWith: traitCollection
            ).pointSize,
            weight: weight
        )
    }
}
