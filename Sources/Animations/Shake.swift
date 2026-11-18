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
extension UIView {
    private static let shakeTransitionKey = "sklv.andrew.view.shake"
    private static let shakeOffsets: [CGFloat] = [-50, 50, -30, 30, -10, 10, 0]

    /// Triggers a horizontal shake animation on the view.
    ///
    /// - Parameter stepDuration: The duration of a single shake movement.
    public func shake(stepDuration: TimeInterval = 0.05) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.values = Self.shakeOffsets
        animation.duration = stepDuration * TimeInterval(Self.shakeOffsets.count)

        animation.isAdditive = true

        layer.removeAnimation(forKey: Self.shakeTransitionKey)
        layer.add(animation, forKey: Self.shakeTransitionKey)
    }
}
