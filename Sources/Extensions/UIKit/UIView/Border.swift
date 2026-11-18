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
    /// Updates the border width of the view's layer, avoiding redundant assignments.
    ///
    /// This method checks if the new width is different from the current `borderWidth`
    /// before applying it, preventing unnecessary Core Animation render cycles.
    ///
    /// - Parameter width: The new border width to apply.
    public func setBorder(width: CGFloat) {
        guard width != layer.borderWidth else { return }
        layer.borderWidth = width
    }

    /// Updates the border color of the view's layer, avoiding redundant assignments.
    ///
    /// This method checks if the new color's `cgColor` is different from the current `borderColor`
    /// before applying it, preventing unnecessary Core Animation render cycles.
    ///
    /// - Parameter color: The new border color to apply.
    public func setBorder(color: UIColor) {
        let cgColor = color.cgColor
        guard cgColor != layer.borderColor else { return }
        layer.borderColor = cgColor
    }

    /// Updates both the border width and color of the view's layer.
    ///
    /// This method leverages equality checks to ensure properties are only updated
    /// if their values have actually changed.
    ///
    /// - Parameters:
    ///   - width: The new border width to apply.
    ///   - color: The new border color to apply.
    public func setBorder(width: CGFloat, color: UIColor) {
        setBorder(width: width)
        setBorder(color: color)
    }
}
