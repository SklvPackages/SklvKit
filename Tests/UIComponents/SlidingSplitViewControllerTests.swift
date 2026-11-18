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

/// A test suite for verifying the behavior and state management of `SlidingSplitViewController`.
@Suite("SlidingSplitViewController Tests")
@MainActor
struct SlidingSplitViewControllerTests {

    /// Verifies that the view controller initializes with the correct default state and components.
    @Test
    func testInitialization() {
        let sut = SlidingSplitViewController()

        #expect(sut.internalSplitViewController != nil)
        #expect(sut.sidebarNavigationController != nil)
        #expect(sut.state == .close)
        #expect(sut.ignoresGestures == false)
    }

    /// Verifies that the sidebar transitions between open and closed states correctly without animation.
    @Test
    func testOpenAndClose() {
        let sut = SlidingSplitViewController()

        sut.setSidebarOpen(true, animated: false)
        #expect(sut.state == .open)

        sut.setSidebarOpen(false, animated: false)
        #expect(sut.state == .close)
    }

    /// Verifies that setting the primary view controller correctly updates the navigation stack and activates the placeholder.
    @Test
    func testSetPrimaryViewController() {
        let sut = SlidingSplitViewController()
        let vc = UIViewController()

        sut.setPrimaryViewController(vc)

        #expect(sut.primaryNavigationController?.viewControllers.first === vc)
        #expect(sut.isShowingPlaceholder == true)
    }

    /// Verifies that setting the secondary view controller updates its navigation stack and disables the placeholder.
    @Test
    func testSetSecondaryViewController() {
        let sut = SlidingSplitViewController()
        let vc = UIViewController()

        sut.setSecondaryViewController(vc)

        #expect(sut.secondaryNavigationController?.viewControllers.first === vc)
        #expect(sut.isShowingPlaceholder == false)
    }

    /// Verifies that the sidebar view controller is correctly assigned to the sidebar's internal navigation stack.
    @Test
    func testSetSidebarViewController() {
        let sut = SlidingSplitViewController()
        let vc = UIViewController()

        sut.setSidebarViewController(vc)

        #expect(sut.sidebarNavigationController?.viewControllers.first === vc)
    }

    /// Verifies that pushing a view controller correctly appends it to the secondary navigation stack.
    @Test
    func testPushViewController() {
        let sut = SlidingSplitViewController()
        let primaryVC = UIViewController()
        let secondaryVC = UIViewController()
        let pushedVC = UIViewController()

        sut.setPrimaryViewController(primaryVC)
        sut.setSecondaryViewController(secondaryVC)
        sut.pushViewController(pushedVC)

        #expect(sut.secondaryNavigationController?.viewControllers.contains(pushedVC) == true)
    }

    /// Verifies that updating the `ignoresGestures` property correctly enables or disables the underlying gesture recognizers.
    @Test
    func testIgnoresGestures() {
        let sut = SlidingSplitViewController()

        sut.ignoresGestures = true

        #expect(sut.panGesture.isEnabled == false)
        #expect(sut.tapGesture.isEnabled == false)
    }
}
