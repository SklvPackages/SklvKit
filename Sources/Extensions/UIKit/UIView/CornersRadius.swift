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
    /// Defines predefined styles for view corner radii.
    public enum CornerStyle {
        case rectangular
        case rounded
        case circular

        /// The multiplier applied to the view's height to calculate the corner radius.
        public var radiusMul: CGFloat {
            switch self {
            case .rectangular: 0
            case .rounded:     if #available(iOS 26.0, *) { 0.3 } else { 0.22 }
            case .circular:    0.5
            }
        }
    }

    /// Sets the corner radius, curve, and masked corners of the view's layer, avoiding redundant updates.
    ///
    /// - Parameters:
    ///   - value: An explicit radius value in points. If `nil`, the radius is calculated dynamically based on the view's height and the provided `style`.
    ///   - style: The visual style of the corners (rectangular, rounded, or circular). Defaults to `.rounded`.
    ///   - maskedCorners: The specific corners to apply the radius to. Defaults to all four corners.
    public func setCornersRadius(
        _ value: CGFloat? = nil,
        style: CornerStyle = .rounded,
        maskedCorners: CACornerMask = [
            .layerMinXMinYCorner, .layerMaxXMinYCorner,
            .layerMinXMaxYCorner, .layerMaxXMaxYCorner
        ]
    ) {
        let radius = value ?? (bounds.size.height * style.radiusMul)
        let curve: CALayerCornerCurve = (style == .circular) ? .circular : .continuous
        let clips = (radius > 0)

        let currentLayer = layer

        if radius != currentLayer.cornerRadius {
            currentLayer.cornerRadius = radius
        }

        if curve != currentLayer.cornerCurve {
            currentLayer.cornerCurve = curve
        }

        if maskedCorners != currentLayer.maskedCorners {
            currentLayer.maskedCorners = maskedCorners
        }

        if clips != clipsToBounds {
            clipsToBounds = clips
        }
    }

    /// Sets the hover style of the view using the specified corner radius and style.
    ///
    /// This method is only effective on iOS 17.0 and newer.
    ///
    /// - Parameters:
    ///   - value: An explicit radius value in points for the hover effect.
    ///   - style: The visual style of the hover corners.
    public func setHoverCornersRadius(_ value: CGFloat? = nil, style: CornerStyle? = nil) {
        if #available(iOS 17.0, *) {
            let targetHoverStyle: UIHoverStyle

            switch style {
            case .circular:
                targetHoverStyle = UIHoverStyle(shape: .capsule)
            case .rectangular:
                targetHoverStyle = UIHoverStyle(shape: .rect)
            case .rounded:
                let radiusValue = value ?? (bounds.size.height * CornerStyle.rounded.radiusMul)
                targetHoverStyle = UIHoverStyle(shape: .rect(cornerRadius: radiusValue))
            default:
                targetHoverStyle = UIHoverStyle(shape: .rect(cornerRadius: value ?? 10))
            }

            if targetHoverStyle != self.hoverStyle {
                self.hoverStyle = targetHoverStyle
            }
        }
    }

    /// Disables the active hover style on the view.
    ///
    /// This method is only effective on iOS 17.0 and newer.
    public func hoverStyleOff() {
        if #available(iOS 17.0, *) {
            guard let hoverStyle, hoverStyle.isEnabled else { return }
            hoverStyle.isEnabled = false
        }
    }
}
