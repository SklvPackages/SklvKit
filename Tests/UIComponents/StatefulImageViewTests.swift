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

@Suite("StatefulImageView Update Tests")
@MainActor
struct StatefulImageViewUpdateTests {

    // MARK: - Helpers

    /// Generates valid image data (1x1 red pixel) to ensure `UIImage(data:)` doesn't fail silently.
    private func generateDummyImageData() -> Data {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1))
        return renderer.pngData { context in
            UIColor.red.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        }
    }

    // MARK: - System Name Tests

    @Test("Update changes image and ID when a new systemName is provided")
    func updateSystemNameWhenDifferent() {
        let imageView = StatefulImageView()
        let newName = "star"

        imageView.update(systemImage: newName)

        // The ID and image should reflect the new systemName assignment.
        #expect(imageView.currentImageID == newName)
        #expect(imageView.image != nil)
    }

    @Test("Update maintains state when the same systemName is provided")
    func updateSystemNameIgnoresSame() {
        let imageView = StatefulImageView()
        imageView.update(systemImage: "star")

        // Capture the exact image reference to ensure it isn't recreated.
        let initialImage = imageView.image

        imageView.update(systemImage: "star")

        // The value should remain unchanged, avoiding redundant allocations.
        #expect(imageView.currentImageID == "star")
        #expect(imageView.image === initialImage)
    }

    // MARK: - Local URL Tests

    @Test("Update clears image and sets ID synchronously when a new URL is provided")
    func updateURLSynchronousBehavior() {
        let imageView = StatefulImageView()
        imageView.update(systemImage: "star") // Setup an initial image to be cleared

        let url = URL(fileURLWithPath: "/tmp/dummy.png")
        imageView.update(localURL: url)

        // The image must be cleared synchronously to prevent flickering, and the new ID must be set.
        #expect(imageView.currentImageID == url.absoluteString)
        #expect(imageView.image == nil)
    }

    @Test("Update ignores the same URL to prevent redundant loads")
    func updateURLIgnoresSame() {
        let imageView = StatefulImageView()
        let url = URL(fileURLWithPath: "/tmp/dummy.png")

        imageView.update(localURL: url)

        // Set a dummy image manually to simulate a completed load
        let dummyImage = UIImage()
        imageView.image = dummyImage

        // Call update again with the same URL
        imageView.update(localURL: url)

        // The guard should prevent the image from being cleared.
        #expect(imageView.currentImageID == url.absoluteString)
        #expect(imageView.image === dummyImage)
    }

    @Test("Update asynchronously loads image from a valid local URL")
    func updateURLAsynchronousLoad() async throws {
        let imageView = StatefulImageView()
        let dummyData = generateDummyImageData()

        // 1. Write dummy data to a temporary file
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".png")
        try dummyData.write(to: tempURL)

        // Ensure cleanup happens automatically when the test finishes
        defer { try? FileManager.default.removeItem(at: tempURL) }

        // 2. Trigger the asynchronous update
        imageView.update(localURL: tempURL)

        // 3. Yield execution to allow the detached Task inside the method to complete.
        // Since the method fires a fire-and-forget Task, we sleep briefly (0.1s) to await the result.
        try await Task.sleep(nanoseconds: 100_000_000)

        // The image should be successfully loaded and applied.
        #expect(imageView.currentImageID == tempURL.absoluteString)
        #expect(imageView.image != nil)
    }

    // MARK: - Reset Tests

    @Test("Reset clears the current image and internal ID")
    func resetClearsState() {
        let imageView = StatefulImageView()

        // 1. Setup an initial state
        imageView.update(systemImage: "star")

        // Sanity check to ensure the state was actually applied
        #expect(imageView.currentImageID == "star")
        #expect(imageView.image != nil)

        // 2. Trigger the reset
        imageView.reset()

        // 3. Verify the state is completely cleared to prevent reuse artifacts
        #expect(imageView.currentImageID == nil)
        #expect(imageView.image == nil)
    }

    @Test("Reset cancels pending asynchronous loads and maintains a cleared state")
    func resetCancelsPendingLoad() async throws {
        let imageView = StatefulImageView()
        let dummyData = generateDummyImageData()

        // 1. Write dummy data to a temporary file
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".png")
        try dummyData.write(to: tempURL)

        // Ensure cleanup happens automatically when the test finishes
        defer { try? FileManager.default.removeItem(at: tempURL) }

        // 2. Trigger the asynchronous update
        imageView.update(localURL: tempURL)

        // 3. Immediately reset the image view before the background task has a chance to complete
        imageView.reset()

        // 4. Yield execution to allow the detached Task to process the cancellation.
        try await Task.sleep(nanoseconds: 100_000_000)

        // The image view must remain completely cleared, proving the task was canceled
        // and did not overwrite the reset state.
        #expect(imageView.currentImageID == nil)
        #expect(imageView.image == nil)
    }
}
