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

@Suite("UITableViewCell Selection Configuration Tests")
@MainActor
struct UITableViewCellSelectionTests {

    @Test("Configuring with color creates a background view and sets selection style")
    func configureWithColor() {
        let cell = UITableViewCell()
        let selectionColor = UIColor.red

        cell.configureSelection(withColor: selectionColor)

        #expect(cell.selectionStyle == .gray)
        #expect(cell.selectedBackgroundView != nil)
        #expect(cell.selectedBackgroundView?.backgroundColor == selectionColor)
    }

    @Test("Configuring with color and radius applies corner radius to the background view")
    func configureWithColorAndRadius() {
        let cell = UITableViewCell()
        let radius: CGFloat = 12.0

        cell.configureSelection(withColor: .blue, cornersRadius: radius)

        // Relies on the `setCornersRadius` UIView extension we added earlier
        #expect(cell.selectedBackgroundView?.layer.cornerRadius == radius)
    }

    @Test("Configuring with nil color clears the background view and disables selection")
    func configureWithNilColor() {
        let cell = UITableViewCell()

        // Setup initial state
        cell.configureSelection(withColor: .green)
        #expect(cell.selectedBackgroundView != nil)

        // Clear selection
        cell.configureSelection(withColor: nil)

        #expect(cell.selectionStyle == .none)
        #expect(cell.selectedBackgroundView == nil)
    }
}
