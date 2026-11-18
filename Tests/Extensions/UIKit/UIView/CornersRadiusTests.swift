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

import Testing
import UIKit
@testable import SklvKit

@Suite("UIView Corner Radius Tests")
@MainActor
struct UIViewCornersTests {

    @Test("Radius multiplier calculates correct values based on style")
    func radiusMultiplierValues() {
        #expect(UIView.CornerStyle.rectangular.radiusMul == 0)
        #expect(UIView.CornerStyle.circular.radiusMul == 0.5)

        let roundedMul = UIView.CornerStyle.rounded.radiusMul
        // Can be 0.3 on iOS 26+ or 0.22 on older versions
        #expect(roundedMul == 0.3 || roundedMul == 0.22)
    }

    @Test("Set rectangular corners applies zero radius and no clipping")
    func setRectangularCorners() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.layer.cornerRadius = 10
        view.clipsToBounds = true

        view.setCornersRadius(style: .rectangular)

        #expect(view.layer.cornerRadius == 0)
        #expect(view.layer.cornerCurve == .continuous)
        #expect(view.clipsToBounds == false)
    }

    @Test("Set circular corners applies dynamic radius and circular curve")
    func setCircularCorners() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

        view.setCornersRadius(style: .circular)

        #expect(view.layer.cornerRadius == 50) // 100 * 0.5
        #expect(view.layer.cornerCurve == .circular)
        #expect(view.clipsToBounds == true)
    }

    @Test("Set corners with explicit value overrides dynamic calculation")
    func setCornersWithExplicitValue() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

        view.setCornersRadius(12, style: .circular)

        #expect(view.layer.cornerRadius == 12)
        #expect(view.layer.cornerCurve == .circular)
    }

    @Test("Set specific masked corners applies correctly")
    func setMaskedCorners() {
        let view = UIView()
        let customMask: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]

        view.setCornersRadius(10, maskedCorners: customMask)

        #expect(view.layer.maskedCorners == customMask)
    }

    @Test("Hover style updates correctly on iOS 17+")
    func hoverStyleUpdates() {
        guard #available(iOS 17.0, *) else { return }
        let view = UIView()

        view.setHoverCornersRadius(style: .rectangular)
        #expect(view.hoverStyle != nil)

        view.hoverStyleOff()
        #expect(view.hoverStyle?.isEnabled == false)
    }
}
