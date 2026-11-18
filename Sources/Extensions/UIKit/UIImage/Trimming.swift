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
extension CGBitmapInfo {
    fileprivate enum ComponentLayout {
        case abgr, argb, bgr, bgra, rgb, rgba
    }

    fileprivate var componentLayout: ComponentLayout? {
        let value = rawValue & Self.alphaInfoMask.rawValue

        guard let info = CGImageAlphaInfo(rawValue: value) else {
            return nil
        }

        let little = contains(.byteOrder32Little)

        if info == .none {
            return little ? .bgr : .rgb
        }

        if info == .premultipliedFirst || info == .first || info == .noneSkipFirst {
            return little ? .bgra : .argb
        } else {
            return little ? .abgr : .rgba
        }
    }
}

@MainActor
extension UIImage {

    private func alphaInsets(tolerance: UInt8) -> UIEdgeInsets {
        guard let cgImage, cgImage.bitsPerPixel == 32 else { return .zero }

        let width = cgImage.width
        let height = cgImage.height

        guard width > 0 && height > 0 else { return .zero }
        guard cgImage.colorSpace?.model == .rgb else { return .zero }

        guard let componentLayout = cgImage.bitmapInfo.componentLayout else { return .zero }

        // Determine the byte offset for the alpha channel (0 or 3)
        let alphaOffset: Int
        switch componentLayout {
        case .bgra, .rgba: alphaOffset = 3
        case .abgr, .argb: alphaOffset = 0
        default: return .zero // .bgr and .rgb have no alpha channel
        }

        guard let data = cgImage.dataProvider?.data,
              let bytePtr = CFDataGetBytePtr(data) else {
            return .zero
        }

        // Hoist constant calculations outside the hot loops
        let bytesPerRow = cgImage.bytesPerRow
        let bytesPerPixel = cgImage.bitsPerPixel / 8

        @inline(__always)
        func hasColor(x: Int, y: Int) -> Bool {
            let pixelOffset = y * bytesPerRow + x * bytesPerPixel
            return bytePtr[pixelOffset + alphaOffset] > tolerance
        }

        var top = 0
        topLoop: for y in 0..<height {
            for x in 0..<width {
                if hasColor(x: x, y: y) { break topLoop }
            }
            top += 1
        }

        // If the entire image is transparent, return immediately
        if top == height { return .zero }

        var bottom = 0
        bottomLoop: for y in (0..<height).reversed() {
            for x in 0..<width {
                if hasColor(x: x, y: y) { break bottomLoop }
            }
            bottom += 1
        }

        var left = 0
        leftLoop: for x in 0..<width {
            // Optimization: Only scan rows that are not entirely transparent
            for y in top..<(height - bottom) {
                if hasColor(x: x, y: y) { break leftLoop }
            }
            left += 1
        }

        var right = 0
        rightLoop: for x in (0..<width).reversed() {
            for y in top..<(height - bottom) {
                if hasColor(x: x, y: y) { break rightLoop }
            }
            right += 1
        }

        // Convert pixel counts to points based on the image's scale
        let pointMultiplier = 1.0 / scale
        return UIEdgeInsets(
            top: CGFloat(top) * pointMultiplier,
            left: CGFloat(left) * pointMultiplier,
            bottom: CGFloat(bottom) * pointMultiplier,
            right: CGFloat(right) * pointMultiplier
        )
    }

    /// Trims the transparent (or nearly transparent) edges of the image.
    ///
    /// - Parameter alphaTolerance: The alpha channel threshold (0-255). Pixels with an alpha
    ///   value less than or equal to this threshold are considered transparent. Defaults to 0.
    /// - Returns: A new cropped image with the transparent edges removed.
    public func trimmingTransparentEdges(alphaTolerance: UInt8 = 0) -> UIImage {
        let insets = alphaInsets(tolerance: alphaTolerance)
        return croppingEdges(by: insets)
    }
}
