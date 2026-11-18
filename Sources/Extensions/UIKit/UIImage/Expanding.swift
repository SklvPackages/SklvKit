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
extension UIImage {
    /// Expands the edges of the image by the specified insets and fills the new space with a color.
    ///
    /// - Parameters:
    ///   - insets: The insets by which to expand the image. Positive values add space around the image.
    ///   - color: The background color to fill the newly created space. Defaults to `.clear`.
    /// - Returns: A new image with expanded edges, or the original image if the insets are zero
    ///   or would result in an invalid size.
    public func expandingEdges(
        _ insets: UIEdgeInsets,
        fillColor color: UIColor = .clear
    ) -> UIImage {
        guard insets != .zero else { return self }

        let currentSize = size
        let newSize = CGSize(
            width: currentSize.width + insets.left + insets.right,
            height: currentSize.height + insets.top + insets.bottom
        )

        guard newSize.width > 0 && newSize.height > 0 else { return self }

        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        format.opaque = false

        return UIGraphicsImageRenderer(size: newSize, format: format).image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: newSize))
            draw(at: CGPoint(x: insets.left, y: insets.top))
        }
    }
}
