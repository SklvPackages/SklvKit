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
    /// Returns a Menlo font object with the specified size, weight, and trait collection.
    ///
    /// This method automatically maps the requested weight to either "Menlo-Regular"
    /// or "Menlo-Bold". It also respects the "Bold Text" accessibility setting
    /// from the provided trait collection for regular and medium weights.
    ///
    /// - Parameters:
    ///   - pointSize: The size (in points) to which the font is scaled.
    ///   - weight: The requested weight of the font.
    ///   - traitCollection: The trait collection to use for determining the legibility weight.
    /// - Returns: A font object of the specified size and weight, or `nil` if Menlo cannot be loaded.
    public static func menloFont(
        ofSize pointSize: CGFloat,
        weight: UIFont.Weight,
        compatibleWith traitCollection: UITraitCollection? = nil
    ) -> UIFont? {
        let bold: Bool

        switch weight {
        case .ultraLight, .thin, .light:
            bold = false
        case .regular, .medium:
            bold = ((traitCollection ?? .current).legibilityWeight == .bold)
        default:
            bold = true
        }

        return UIFont(name: bold ? "Menlo-Bold" : "Menlo-Regular", size: pointSize)
    }

    /// Returns a Menlo font object for the specified text style, weight, and trait collection.
    ///
    /// - Parameters:
    ///   - style: The text style for which to return a font.
    ///   - weight: The requested weight of the font.
    ///   - traitCollection: The trait collection to use for resolving the text style size and legibility weight.
    /// - Returns: A font object sized appropriately for the specified text style, or `nil` if Menlo cannot be loaded.
    public static func preferredMenloFont(
        forTextStyle style: UIFont.TextStyle,
        weight: UIFont.Weight,
        compatibleWith traitCollection: UITraitCollection? = nil
    ) -> UIFont? {
        .menloFont(
            ofSize: UIFontDescriptor.preferredFontDescriptor(
                withTextStyle: style,
                compatibleWith: traitCollection
            ).pointSize,
            weight: weight,
            compatibleWith: traitCollection
        )
    }
}
