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

extension TimeInterval {
    /// The default animation duration used throughout the library.
    public static let animation: TimeInterval = 0.28
}

@MainActor
extension UIView {
    /// Animates changes to one or more views using the specified duration, options, and completion handler.
    ///
    /// - Parameters:
    ///   - duration: The total duration of the animations, measured in seconds.
    ///   - immediately: A Boolean value that determines whether the animations should be applied instantly without a transition.
    ///   - options: A mask of options indicating how you want to perform the animations.
    ///   - animations: A block object containing the changes to commit to the views.
    ///   - completion: A block object to be executed when the animation sequence ends.
    public static func animate(
        duration: TimeInterval = .animation,
        immediately: Bool = false,
        options: UIView.AnimationOptions = [.beginFromCurrentState, .allowUserInteraction],
        animations: @escaping @MainActor () -> Void,
        completion: (@MainActor @Sendable (Bool) -> Void)? = nil
    ) {
        if immediately {
            animations()
            completion?(true)
        } else {
            UIView.animate(
                withDuration: duration,
                delay: 0,
                options: options,
                animations: animations,
                completion: completion
            )
        }
    }
}
