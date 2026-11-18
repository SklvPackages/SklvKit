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
extension UITextField {
    /// Updates the text field's placeholder with an optional transition animation.
    ///
    /// The animation only occurs if requested and the text field is currently empty.
    /// If the text field contains text, the placeholder updates instantly to save resources.
    ///
    /// - Parameters:
    ///   - newValue: The new placeholder string to display.
    ///   - animated: A Boolean value indicating whether the change should be animated.
    ///   - completion: A block object to be executed when the update completes.
    public func update(
        placeholder newValue: String?,
        animated: Bool,
        completion: (@MainActor @Sendable (Bool) -> Void)? = nil
    ) {
        let isTextEmpty = (text?.isEmpty ?? true) && (attributedText?.string.isEmpty ?? true)

        transition(
            immediately: !(animated && isTextEmpty),
            animations: { self.placeholder = newValue },
            completion: completion
        )
    }
}
