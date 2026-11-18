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

@Suite("Completion Tests")
@MainActor
struct CompletionTests {

    // MARK: - UINavigationController

    @Test("pushViewController executes completion")
    func pushViewControllerCompletion() async {
        let nav = UINavigationController(rootViewController: UIViewController())
        let vc = UIViewController()

        await withCheckedContinuation { continuation in
            nav.pushViewController(vc, animated: false) {
                continuation.resume()
            }
        }

        #expect(nav.viewControllers.count == 2)
    }

    @Test("popViewController executes completion")
    func popViewControllerCompletion() async {
        let root = UIViewController()
        let vc = UIViewController()
        let nav = UINavigationController(rootViewController: root)
        nav.pushViewController(vc, animated: false)

        await withCheckedContinuation { continuation in
            nav.popViewController(animated: false) {
                continuation.resume()
            }
        }

        #expect(nav.viewControllers.count == 1)
        #expect(nav.viewControllers.first === root)
    }

    // MARK: - UITabBarController

    @Test("setSelectedIndex executes completion and guards bounds")
    func setSelectedIndexCompletion() async {
        let tab = UITabBarController()
        let vc1 = UIViewController()
        let vc2 = UIViewController()
        tab.viewControllers = [vc1, vc2]

        await withCheckedContinuation { continuation in
            tab.setSelectedIndex(1) {
                continuation.resume()
            }
        }

        #expect(tab.selectedIndex == 1)

        // Test out of bounds guard
        await withCheckedContinuation { continuation in
            tab.setSelectedIndex(99) {
                continuation.resume()
            }
        }

        // Should remain 1 because 99 is invalid
        #expect(tab.selectedIndex == 1)
    }

    @Test("setSelectedViewController executes completion")
    func setSelectedViewControllerCompletion() async {
        let tab = UITabBarController()
        let vc1 = UIViewController()
        let vc2 = UIViewController()
        tab.viewControllers = [vc1, vc2]

        await withCheckedContinuation { continuation in
            tab.setSelectedViewController(vc2) {
                continuation.resume()
            }
        }

        #expect(tab.selectedViewController === vc2)
    }
}
