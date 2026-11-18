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
extension UITableViewCell {
    /// Configures the selection appearance of the table view cell.
    ///
    /// This method simplifies the creation of a custom selected background view.
    /// If a color is provided, it creates a background view, optionally applies a corner radius,
    /// and enables the selection style. If `nil` is passed, it removes the custom background
    /// and disables selection styling.
    ///
    /// - Parameters:
    ///   - color: The background color to display when the cell is selected. Pass `nil` to disable selection styling.
    ///   - cornersRadius: An optional corner radius to apply to the selected background view.
    public func configureSelection(
        withColor color: UIColor?,
        cornersRadius: CGFloat? = nil
    ) {
        if let color {
            let backgroundView = UIView()
            backgroundView.backgroundColor = color

            if let cornersRadius {
                backgroundView.setCornersRadius(cornersRadius)
            }

            selectionStyle = .gray
            selectedBackgroundView = backgroundView
        } else {
            selectionStyle = .none
            selectedBackgroundView = nil
        }
    }
}
