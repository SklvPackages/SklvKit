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

    /// Updates the view's layout margins, avoiding redundant assignments.
    public func update(layoutMargins newValue: UIEdgeInsets) {
        guard newValue != layoutMargins else { return }
        layoutMargins = newValue
    }

    /// Updates the view's frame, avoiding redundant assignments.
    public func update(frame newValue: CGRect) {
        guard newValue != frame else { return }
        frame = newValue
    }

    /// Updates the view's frame origin, avoiding redundant assignments.
    public func update(origin newValue: CGPoint) {
        guard newValue != frame.origin else { return }
        frame.origin = newValue
    }

    /// Updates the view's frame size, avoiding redundant assignments.
    public func update(size newValue: CGSize) {
        guard newValue != frame.size else { return }
        frame.size = newValue
    }

    /// Updates the view's frame origin x-coordinate, avoiding redundant assignments.
    public func update(x newValue: CGFloat) {
        guard newValue != frame.origin.x else { return }
        frame.origin.x = newValue
    }

    /// Updates the view's frame origin y-coordinate, avoiding redundant assignments.
    public func update(y newValue: CGFloat) {
        guard newValue != frame.origin.y else { return }
        frame.origin.y = newValue
    }

    /// Updates the view's frame width, avoiding redundant assignments.
    public func update(width newValue: CGFloat) {
        guard newValue != frame.size.width else { return }
        frame.size.width = newValue
    }

    /// Updates the view's frame height, avoiding redundant assignments.
    public func update(height newValue: CGFloat) {
        guard newValue != frame.size.height else { return }
        frame.size.height = newValue
    }

    /// Updates the view's background color, avoiding redundant assignments.
    public func update(backgroundColor newValue: UIColor?) {
        guard newValue !== backgroundColor else { return }
        backgroundColor = newValue
    }

    /// Updates the view's tint color, avoiding redundant assignments.
    public func update(tintColor newValue: UIColor?) {
        guard newValue !== tintColor else { return }
        tintColor = newValue
    }

    /// Updates the view's alpha value, avoiding redundant assignments.
    public func update(alpha newValue: CGFloat) {
        guard newValue != alpha else { return }
        alpha = newValue
    }

    /// Updates the view's hidden state, avoiding redundant assignments.
    public func update(isHidden newValue: Bool) {
        guard newValue != isHidden else { return }
        isHidden = newValue
    }

    /// Updates the view's user interaction enabled state, avoiding redundant assignments.
    public func update(isUserInteractionEnabled newValue: Bool) {
        guard newValue != isUserInteractionEnabled else { return }
        isUserInteractionEnabled = newValue
    }
}
