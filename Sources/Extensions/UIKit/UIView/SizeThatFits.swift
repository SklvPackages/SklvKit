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
    /// The optimal size of the view without any size constraints.
    ///
    /// This property calculates the unconstrained size that best fits the view's content,
    /// rounding up the width and height to the nearest whole point to prevent sub-pixel rendering artifacts.
    public var sizeThatFits: CGSize {
        let max: CGFloat = .greatestFiniteMagnitude
        let rawSize = sizeThatFits(CGSize(width: max, height: max))
        return CGSize(width: rawSize.width.rounded(.up), height: rawSize.height.rounded(.up))
    }

    /// Calculates the optimal width for the view given a constrained height.
    ///
    /// The calculated width is rounded up to the nearest whole point.
    ///
    /// - Parameter height: The maximum available height.
    /// - Returns: The calculated optimal width.
    public func width(for height: CGFloat) -> CGFloat {
        sizeThatFits(CGSize(width: .greatestFiniteMagnitude, height: height)).width.rounded(.up)
    }

    /// Calculates the optimal height for the view given a constrained width.
    ///
    /// The calculated height is rounded up to the nearest whole point.
    ///
    /// - Parameter width: The maximum available width.
    /// - Returns: The calculated optimal height.
    public func height(for width: CGFloat) -> CGFloat {
        sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude)).height.rounded(.up)
    }
}
