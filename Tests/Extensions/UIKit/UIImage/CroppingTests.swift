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

@Suite("UIImage Cropping Tests")
@MainActor
struct UIImageCroppingTests {

    // Helper to generate a test image
    private func createTestImage(size: CGSize) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1.0
        return UIGraphicsImageRenderer(size: size, format: format).image { context in
            UIColor.blue.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }

    @Test("Crop by absolute insets reduces size correctly")
    func cropByAbsoluteInsets() {
        let originalImage = createTestImage(size: CGSize(width: 100, height: 100))
        let insets = UIEdgeInsets(top: 10, left: 15, bottom: 20, right: 25)

        let cropped = originalImage.croppingEdges(by: insets)

        #expect(cropped.size.width == 60)  // 100 - 15 - 25
        #expect(cropped.size.height == 70) // 100 - 10 - 20
    }

    @Test("Crop by relative insets reduces size correctly")
    func cropByRelativeInsets() {
        let originalImage = createTestImage(size: CGSize(width: 200, height: 100))
        // Crop 10% from top/bottom, 25% from left/right
        let insets = UIEdgeInsets(top: 0.1, left: 0.25, bottom: 0.1, right: 0.25)

        let cropped = originalImage.croppingEdges(relativeTo: insets)

        #expect(cropped.size.width == 100) // 200 - (200*0.25) - (200*0.25) = 200 - 50 - 50
        #expect(cropped.size.height == 80) // 100 - (100*0.1) - (100*0.1) = 100 - 10 - 10
    }

    @Test("Zero insets return original image")
    func zeroInsetsReturnSelf() {
        let originalImage = createTestImage(size: CGSize(width: 100, height: 100))

        let croppedAbsolute = originalImage.croppingEdges(by: .zero)
        let croppedRelative = originalImage.croppingEdges(relativeTo: .zero)

        // Should return the exact same instance in memory
        #expect(croppedAbsolute === originalImage)
        #expect(croppedRelative === originalImage)
    }

    @Test("Invalid crop sizes return original image")
    func invalidCropSizesReturnSelf() {
        let originalImage = createTestImage(size: CGSize(width: 50, height: 50))
        let hugeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30) // Would result in negative size

        let cropped = originalImage.croppingEdges(by: hugeInsets)

        #expect(cropped === originalImage)
    }
}
