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
extension UIApplication {
    private func openAppStore(
        path: String,
        items: [URLQueryItem] = [],
        completion: (@MainActor @Sendable (Bool) -> Void)? = nil
    ) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "apps.apple.com"
        components.path = path
        components.queryItems = items.isEmpty ? nil : items

        guard let url = components.url else {
            completion?(false)
            return
        }

        open(url, options: [:], completionHandler: completion)
    }

    /// Opens the App Store page for the specified app ID.
    ///
    /// - Parameters:
    ///   - id: The Apple ID of the application.
    ///   - completion: A block to execute with the result of the attempt to open the App Store.
    public func openAppStore(
        id: String,
        completion: (@MainActor @Sendable (Bool) -> Void)? = nil
    ) {
        openAppStore(path: "/app/id" + id, completion: completion)
    }

    /// Opens the App Store page for the specified app ID and directly presents the review composer.
    ///
    /// - Parameters:
    ///   - id: The Apple ID of the application.
    ///   - completion: A block to execute with the result of the attempt to open the App Store.
    public func openAppStoreWriteReview(
        id: String,
        completion: (@MainActor @Sendable (Bool) -> Void)? = nil
    ) {
        openAppStore(
            path: "/app/id" + id,
            items: [URLQueryItem(name: "action", value: "write-review")],
            completion: completion
        )
    }

    /// Opens the App Store developer page for the specified developer ID.
    ///
    /// - Parameters:
    ///   - id: The Apple ID of the developer.
    ///   - completion: A block to execute with the result of the attempt to open the App Store.
    public func openAppStoreDeveloper(
        id: String,
        completion: (@MainActor @Sendable (Bool) -> Void)? = nil
    ) {
        openAppStore(path: "/developer/id" + id, completion: completion)
    }
}
