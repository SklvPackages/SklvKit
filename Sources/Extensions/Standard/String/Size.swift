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

extension String {
    /// Calculates the bounding height of the string constrained to a specific width and number of lines.
    ///
    /// - Parameters:
    ///   - width: The maximum allowable width for the text container.
    ///   - font: The font used to render the text.
    ///   - numberOfLines: The maximum number of lines. A value of 0 indicates no limit. Defaults to 0.
    /// - Returns: The calculated bounding height, rounded up to the nearest whole number.
    @Sendable
    public func height(width: CGFloat, font: UIFont, numberOfLines: Int = 0) -> CGFloat {
        guard !isEmpty else { return 0 }

        let maxHeight: CGFloat

        if numberOfLines == 0 {
            maxHeight = .greatestFiniteMagnitude
        } else {
            maxHeight = font.lineHeight * CGFloat(numberOfLines)
        }

        let height = self.boundingRect(
            with: CGSize(width: width, height: maxHeight),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font],
            context: nil
        ).height

        return height.rounded(.up)
    }

    /// Calculates the bounding width of the string constrained to a specific height.
    ///
    /// - Parameters:
    ///   - height: The maximum allowable height for the text container.
    ///   - font: The font used to render the text.
    /// - Returns: The calculated bounding width, rounded up to the nearest whole number.
    @Sendable
    public func width(height: CGFloat, font: UIFont) -> CGFloat {
        guard !isEmpty else { return 0 }

        let width = self.boundingRect(
            with: CGSize(width: .greatestFiniteMagnitude, height: height),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font],
            context: nil
        ).width

        return width.rounded(.up)
    }

    /// Calculates the bounding size of the string.
    ///
    /// - Parameters:
    ///   - font: The font used to render the text.
    /// - Returns: The calculated bounding size, rounded up to the nearest whole number.
    @Sendable
    public func singleLineSize(font: UIFont) -> CGSize {
        guard !isEmpty else { return .zero }

        let size = self.boundingRect(
            with: CGSize(width: .greatestFiniteMagnitude, height: font.lineHeight),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font],
            context: nil
        ).size

        return CGSize(
            width: size.width.rounded(.up),
            height: size.height.rounded(.up)
        )
    }
}
