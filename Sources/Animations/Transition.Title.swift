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
extension UIViewController {
    /// Updates the view controller's title with an optional transition animation.
    ///
    /// If the view controller is embedded in a navigation controller and animation is requested,
    /// the navigation bar will animate the title change. Otherwise, the title updates instantly.
    ///
    /// - Parameters:
    ///   - newValue: The new title string.
    ///   - animated: A Boolean value indicating whether the change should be animated.
    ///   - completion: A block object to be executed when the title update completes.
    public func update(
        title newValue: String?,
        animated: Bool,
        completion: (@MainActor @Sendable (Bool) -> Void)? = nil
    ) {
        if animated, let navigationBar = navigationController?.navigationBar {
            navigationBar.transition(
                immediately: false,
                animations: { self.title = newValue },
                completion: completion
            )
        } else {
            title = newValue
            completion?(true)
        }
    }
}
