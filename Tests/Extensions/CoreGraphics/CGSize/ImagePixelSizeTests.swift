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

@Suite("CGSize ImagePixelSize Tests")
struct CGSizeImagePixelSizeTests {

    @Test("Extracts correct size from image file URL")
    func extractsCorrectSize() throws {
        // Create a test image using UIGraphicsImageRenderer
        let expectedSize = CGSize(width: 100, height: 50)
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1.0 // Ensure scale is 1.0 so points match pixels
        let renderer = UIGraphicsImageRenderer(size: expectedSize, format: format)
        let image = renderer.image { context in
            UIColor.red.setFill()
            context.fill(CGRect(origin: .zero, size: expectedSize))
        }

        // Save as JPEG to a temporary directory
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            Issue.record("Failed to generate JPEG data")
            return
        }

        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".jpg")
        try data.write(to: fileURL)

        // Cleanup after test
        defer {
            try? FileManager.default.removeItem(at: fileURL)
        }

        // Test our function
        let size = CGSize.imagePixelSize(from: fileURL)

        #expect(size == expectedSize)
    }

    @Test("Returns nil for an invalid URL or non-image file")
    func returnsNilForInvalidFile() {
        let invalidURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".txt")
        let size = CGSize.imagePixelSize(from: invalidURL)

        #expect(size == nil)
    }
}
