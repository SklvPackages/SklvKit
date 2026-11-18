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

/// An image view that remembers the identifier of its currently displayed image
/// to avoid redundant rendering, decoding, and I/O operations.
@MainActor
public final class StatefulImageView: UIImageView {
    private var imageLoadTask: Task<Void, Never>?

    /// The unique identifier of the currently displayed image.
    public private(set) var currentImageID: String?

    /// The configuration of the currently displayed image.
    public private(set) var currentImageConfiguration: UIImage.SymbolConfiguration?

    /// Initializes the image view with a system symbol name.
    ///
    /// - Parameters:
    ///   - name: The name of the SF Symbol.
    ///   - configuration: The symbol configuration for the image.
    public convenience init(
        systemImage name: String,
        withConfiguration configuration: UIImage.SymbolConfiguration? = nil
    ) {
        self.init()
        self.update(systemImage: name, withConfiguration: configuration)
    }

    /// Initializes the image view by loading an image asynchronously from a local file URL.
    ///
    /// - Parameter localURL: The local file URL containing the image data.
    public convenience init(localURL: URL) {
        self.init()
        self.update(localURL: localURL)
    }

    /// Updates the image using a system symbol name, avoiding redundant assignments.
    ///
    /// - Parameters:
    ///   - name: The name of the SF Symbol.
    ///   - configuration: The symbol configuration for the image.
    public func update(
        systemImage name: String,
        withConfiguration configuration: UIImage.SymbolConfiguration? = nil
    ) {
        guard name != currentImageID || configuration != currentImageConfiguration else { return }
        currentImageID = name
        currentImageConfiguration = configuration
        image = UIImage(systemName: name, withConfiguration: configuration)
    }

    /// Updates the image from a local file URL asynchronously.
    ///
    /// - Parameter localURL: The local file URL containing the image data.
    public func update(localURL: URL) {
        let id = localURL.absoluteString
        guard id != currentImageID else { return }
        currentImageID = id

        imageLoadTask?.cancel()
        image = nil

        imageLoadTask = Task { [weak self] in
            guard !Task.isCancelled else { return }

            let loadedImage: UIImage?

            do {
                let (data, _) = try await URLSession.shared.data(from: localURL)

                loadedImage = try await Task.detached {
                    try Task.checkCancellation()
                    return UIImage(data: data)
                }.value
            } catch is CancellationError {
                return
            } catch {
                print("[StatefulImageView] Error reading file: \(error.localizedDescription)")
                loadedImage = nil
            }

            guard let self, self.currentImageID == id else { return }

            if let loadedImage {
                self.image = loadedImage
            } else {
                self.currentImageID = nil
            }
        }
    }

    /// Resets the image view to its initial state.
    ///
    /// This method cancels any pending asynchronous image loading tasks, clears
    /// the currently displayed image to free up memory, and resets the internal
    /// image identifier.
    public func reset() {
        imageLoadTask?.cancel()
        imageLoadTask = nil
        currentImageID = nil
        image = nil
    }
}
