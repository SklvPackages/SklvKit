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

@Suite("UIImage Trimming Tests")
@MainActor
struct UIImageTrimmingTests {

    // Helper to generate an image with a solid square in the middle of a transparent canvas
    private func createImageWithTransparentBorders(
        canvasSize: CGSize,
        contentRect: CGRect,
        scale: CGFloat = 1.0
    ) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        format.opaque = false

        return UIGraphicsImageRenderer(size: canvasSize, format: format).image { context in
            // Canvas starts fully transparent
            UIColor.red.setFill()
            context.fill(contentRect)
        }
    }

    @Test("Trims completely transparent edges")
    func trimsTransparentEdges() {
        let canvasSize = CGSize(width: 100, height: 100)
        let contentRect = CGRect(x: 20, y: 30, width: 50, height: 40)
        let image = createImageWithTransparentBorders(canvasSize: canvasSize, contentRect: contentRect)

        let trimmed = image.trimmingTransparentEdges()

        #expect(trimmed.size.width == 50)
        #expect(trimmed.size.height == 40)
    }

    @Test("Trims correctly on a retina (2x) scale image")
    func trimsTransparentEdgesWithScale() {
        let canvasSize = CGSize(width: 100, height: 100)
        let contentRect = CGRect(x: 10, y: 10, width: 80, height: 80)
        // Set scale to 2.0. The internal pixels will be 200x200, content 160x160
        let image = createImageWithTransparentBorders(canvasSize: canvasSize, contentRect: contentRect, scale: 2.0)

        let trimmed = image.trimmingTransparentEdges()

        // Result size should still be exactly the content size in points
        #expect(trimmed.size.width == 80)
        #expect(trimmed.size.height == 80)
        #expect(trimmed.scale == 2.0)
    }

    @Test("Fully transparent image returns original image or empty size")
    func trimsFullyTransparentImage() {
        // Draw nothing
        let format = UIGraphicsImageRendererFormat()
        format.opaque = false
        let blankImage = UIGraphicsImageRenderer(size: CGSize(width: 50, height: 50), format: format).image { _ in }

        let trimmed = blankImage.trimmingTransparentEdges()

        // When insets are .zero (due to all pixels being transparent), croppingEdges returns self
        #expect(trimmed === blankImage)
    }
}
