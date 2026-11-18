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
    /// Crops the image by the specified absolute edge insets in points.
    ///
    /// - Parameter insets: The insets to apply to the edges of the image.
    /// - Returns: A new cropped image, or the original image if the insets are zero or
    ///   would result in an invalid size (e.g., cropping more than the image's dimensions).
    public func croppingEdges(by insets: UIEdgeInsets) -> UIImage {
        guard insets != .zero else { return self }

        let currentSize = size
        let newSize = CGSize(
            width: currentSize.width - insets.left - insets.right,
            height: currentSize.height - insets.top - insets.bottom
        )

        guard newSize.width > 0 && newSize.height > 0 else { return self }

        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        format.opaque = false

        return UIGraphicsImageRenderer(size: newSize, format: format).image { _ in
            draw(at: CGPoint(x: -insets.left, y: -insets.top))
        }
    }

    /// Crops the image by the specified relative edge insets.
    ///
    /// The insets are expressed as fractions of the image's dimensions (e.g., 0.1 represents 10%).
    ///
    /// - Parameter insets: The relative insets to apply to the edges of the image.
    /// - Returns: A new cropped image, or the original image if the insets are zero or
    ///   would result in an invalid size.
    public func croppingEdges(relativeTo insets: UIEdgeInsets) -> UIImage {
        guard insets != .zero else { return self }

        let currentSize = size
        return croppingEdges(by: UIEdgeInsets(
            top: currentSize.height * insets.top,
            left: currentSize.width * insets.left,
            bottom: currentSize.height * insets.bottom,
            right: currentSize.width * insets.right
        ))
    }
}
