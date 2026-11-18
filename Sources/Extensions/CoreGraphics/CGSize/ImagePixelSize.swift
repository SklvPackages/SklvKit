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

import Foundation
import ImageIO

extension CGSize {
    /// Returns the physical dimensions of an image at the specified URL without loading the entire image into memory.
    ///
    /// This method parses the image file's metadata to determine its pixel width and height.
    /// It also respects EXIF orientation tags, swapping width and height if the image is rotated 90 or 270 degrees,
    /// mirroring the behavior of `UIImage.size`.
    ///
    /// - Parameter url: The file URL of the image.
    /// - Returns: A `CGSize` representing the image dimensions, or `nil` if the dimensions cannot be read.
    @Sendable
    public static func imagePixelSize(from url: URL) -> CGSize? {
        guard let source = CGImageSourceCreateWithURL(url as CFURL, nil),
              let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [CFString: Any],
              let width = properties[kCGImagePropertyPixelWidth] as? CGFloat,
              let height = properties[kCGImagePropertyPixelHeight] as? CGFloat else {
            return nil
        }

        // UIImage.size applies the EXIF orientation to the final dimensions.
        // Orientations 5 through 8 indicate a 90 or 270 degree rotation,
        // which means the physical width and height must be swapped.
        let orientation = properties[kCGImagePropertyOrientation] as? Int ?? 1

        if orientation >= 5 && orientation <= 8 {
            return CGSize(width: height, height: width)
        }

        return CGSize(width: width, height: height)
    }
}
