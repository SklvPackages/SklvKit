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

@Suite("UIImage Expanding Tests")
@MainActor
struct UIImageExpandingTests {

    // Helper to generate a test image
    private func createTestImage(size: CGSize) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1.0
        return UIGraphicsImageRenderer(size: size, format: format).image { context in
            UIColor.blue.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }

    @Test("Expand by positive insets increases size correctly")
    func expandByPositiveInsets() {
        let originalImage = createTestImage(size: CGSize(width: 100, height: 100))
        let insets = UIEdgeInsets(top: 10, left: 20, bottom: 30, right: 40)

        let expanded = originalImage.expandingEdges(insets)

        #expect(expanded.size.width == 160)  // 100 + 20 + 40
        #expect(expanded.size.height == 140) // 100 + 10 + 30
    }

    @Test("Zero insets return original image")
    func zeroInsetsReturnSelf() {
        let originalImage = createTestImage(size: CGSize(width: 100, height: 100))

        let expanded = originalImage.expandingEdges(.zero)

        #expect(expanded === originalImage)
    }

    @Test("Negative insets that result in zero or negative size return original image")
    func negativeInsetsResultingInInvalidSizeReturnSelf() {
        let originalImage = createTestImage(size: CGSize(width: 50, height: 50))
        // Shrinking by 30 on all sides makes width/height negative (-10)
        let insets = UIEdgeInsets(top: -30, left: -30, bottom: -30, right: -30)

        let result = originalImage.expandingEdges(insets)

        #expect(result === originalImage)
    }
}
