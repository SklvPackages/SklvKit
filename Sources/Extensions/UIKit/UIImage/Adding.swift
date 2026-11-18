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
    /// Appends another image to the right side of the current image.
    ///
    /// - Parameter image: The image to append.
    /// - Returns: A new image consisting of the current image and the appended image side-by-side.
    public func addingRight(_ image: UIImage) -> UIImage {
        let imageSize = image.size
        guard imageSize.width > 0 && imageSize.height > 0 else { return self }

        let currentSize = size
        guard currentSize.width > 0 && currentSize.height > 0 else { return image }

        let newSize = CGSize(
            width: currentSize.width + imageSize.width,
            height: max(currentSize.height, imageSize.height)
        )

        return renderAdding(image, newSize: newSize, secondaryPosition: CGPoint(x: currentSize.width, y: 0))
    }

    /// Appends another image to the bottom of the current image.
    ///
    /// - Parameter image: The image to append.
    /// - Returns: A new image consisting of the current image with the appended image placed below it.
    public func addingBottom(_ image: UIImage) -> UIImage {
        let imageSize = image.size
        guard imageSize.width > 0 && imageSize.height > 0 else { return self }

        let currentSize = size
        guard currentSize.width > 0 && currentSize.height > 0 else { return image }

        let newSize = CGSize(
            width: max(currentSize.width, imageSize.width),
            height: currentSize.height + imageSize.height
        )

        return renderAdding(image, newSize: newSize, secondaryPosition: CGPoint(x: 0, y: currentSize.height))
    }

    // MARK: - Private Helpers

    private func renderAdding(_ image: UIImage, newSize: CGSize, secondaryPosition: CGPoint) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        format.opaque = false

        return UIGraphicsImageRenderer(size: newSize, format: format).image { _ in
            draw(at: .zero)
            image.draw(at: secondaryPosition)
        }
    }
}
