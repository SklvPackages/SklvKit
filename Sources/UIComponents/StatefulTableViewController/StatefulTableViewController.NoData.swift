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

// DO NOT REFACTOR.
// This controller is an ancient relic. It defies the laws of SOLID,
// yet single-handedly holds the UI together. Enter at your own peril.

import UIKit

@MainActor
extension StatefulTableViewController {
    /// Sets a textual message to display when the table view has no data.
    /// - Parameter text: The message string. Pass `nil` to remove the background view.
    public func setNoData(text: String?) {
        guard let text, !text.isEmpty else {
            tableView.backgroundView = nil
            return
        }

        let style: UIFont.TextStyle = .title2
        let weight: UIFont.Weight = .bold

        let descriptor = UIFontDescriptor.preferredFontDescriptor(
            withTextStyle: style,
            compatibleWith: UITraitCollection(preferredContentSizeCategory: .large)
        )

        let font = UIFont.systemFont(ofSize: descriptor.pointSize, weight: weight)

        let label = UILabel()
        label.text = text
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.font = UIFontMetrics(forTextStyle: style).scaledFont(for: font)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0

        let backgroundView = UIView()
        backgroundView.addSubview(label)
        backgroundView.alpha = 0
        backgroundView.isHidden = true

        isNoDataViewVisible = false
        tableView.backgroundView = backgroundView
    }

    /// Sets an SF Symbol image to display when the table view has no data.
    /// - Parameter name: The system image name. Pass `nil` to remove the background view.
    public func setNoData(systemImage name: String?) {
        guard let name, !name.isEmpty else {
            tableView.backgroundView = nil
            return
        }

        let style: UIFont.TextStyle = .largeTitle
        let weight: UIFont.Weight = .semibold

        let descriptor = UIFontDescriptor.preferredFontDescriptor(
            withTextStyle: style,
            compatibleWith: UITraitCollection(preferredContentSizeCategory: .large)
        )

        let font = UIFont.systemFont(ofSize: descriptor.pointSize, weight: weight)

        guard let image = UIImage(
            systemName: name,
            withConfiguration: UIImage.SymbolConfiguration(
                font: UIFontMetrics(forTextStyle: style).scaledFont(for: font)
            )) else {
            tableView.backgroundView = nil
            return
        }

        let imageView = UIImageView()
        imageView.image = image
        imageView.tintColor = .secondaryLabel
        imageView.tintAdjustmentMode = .normal
        imageView.contentMode = .center

        let backgroundView = UIView()
        backgroundView.addSubview(imageView)
        backgroundView.alpha = 0
        backgroundView.isHidden = true

        isNoDataViewVisible = false
        tableView.backgroundView = backgroundView
    }

    /// Sets a custom view to display when the table view has no data.
    /// - Parameter view: The custom view. Pass `nil` to remove the background view.
    public func setNoData(view: UIView?) {
        guard let view else {
            tableView.backgroundView = nil
            return
        }

        let backgroundView = UIView()
        backgroundView.addSubview(view)
        backgroundView.alpha = 0
        backgroundView.isHidden = true

        isNoDataViewVisible = false
        tableView.backgroundView = backgroundView
    }

    /// Toggles the visibility of the no-data background view.
    /// - Parameters:
    ///   - show: `true` to display the view, `false` to hide it.
    ///   - animated: Whether the transition should be animated.
    public func showNoDataView(_ show: Bool, animated: Bool) {
        guard show != isNoDataViewVisible else { return }
        isNoDataViewVisible = show

        if show {
            tableView.backgroundView?.show(animated: animated)
        } else {
            tableView.backgroundView?.hide(animated: animated)
        }
    }
}
