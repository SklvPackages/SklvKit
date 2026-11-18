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
extension SlidingSplitViewController {
    /// Sets the root view controller for the sidebar navigation.
    ///
    /// - Parameters:
    ///   - vc: The view controller to configure as the root of the sidebar.
    ///   - completion: An optional closure to execute after the sidebar view controller is set.
    public func setSidebarViewController(
        _ vc: UIViewController?,
        completion: (@MainActor @Sendable () -> Void)? = nil
    ) {
        guard let sidebarNavigationController else {
            completion?()
            return
        }

        sidebarNavigationController.setViewControllers(
            [vc ?? makeDefaultViewController()],
            completion: completion
        )
    }

    /// Sets the view controller for the primary column.
    ///
    /// - Parameters:
    ///   - vc: The view controller to display in the primary column.
    ///   - completion: An optional closure to execute after the primary view controller is set.
    public func setPrimaryViewController(
        _ vc: UIViewController?,
        completion: (@MainActor @Sendable () -> Void)? = nil
    ) {
        isShowingPlaceholder = false
        preferredTopColumn = .primary

        setOrMakePrimaryViewController(vc, completion: completion)
        setPlaceholderViewController()
    }

    /// Sets the view controller for the secondary column.
    ///
    /// - Parameters:
    ///   - vc: The view controller to display in the secondary column.
    ///   - completion: An optional closure to execute after the secondary view controller is set.
    public func setSecondaryViewController(
        _ vc: UIViewController?,
        completion: (@MainActor @Sendable () -> Void)? = nil
    ) {
        isShowingPlaceholder = false
        preferredTopColumn = .secondary

        setOrMakeSecondaryViewController(vc, completion: completion)
        internalSplitViewController?.show(.secondary)
    }

    /// Configures and sets a placeholder view controller for the secondary column.
    public func setPlaceholderViewController() {
        guard !isShowingPlaceholder else { return }
        isShowingPlaceholder = true
        preferredTopColumn = .primary

        if let primaryNC = primaryNavigationController,
           primaryNC.viewControllers.count > 1 {
            primaryNC.popToRootViewController(animated: true)
        }

        setOrMakeSecondaryViewController(makePlaceholderViewController?())
    }

    private func makeDefaultViewController() -> UIViewController {
        let controller = UIViewController()
        controller.view.backgroundColor = .systemBackground
        return controller
    }

    private func setOrMakePrimaryViewController(
        _ vc: UIViewController?,
        completion: (@MainActor @Sendable () -> Void)? = nil
    ) {
        let controller = vc ?? makeDefaultViewController()

        if let primaryNavigationController {
            primaryNavigationController.setViewControllers(
                [controller],
                completion: completion
            )
        } else if let internalSplitViewController {
            let navigationController = UINavigationController(rootViewController: controller)
            navigationController.navigationBar.prefersLargeTitles = true
            navigationController.delegate = self
            primaryNavigationController = navigationController

            internalSplitViewController.setViewController(
                navigationController,
                for: .primary,
                completion: completion
            )
        } else {
            completion?()
        }
    }

    private func setOrMakeSecondaryViewController(
        _ vc: UIViewController?,
        completion: (@MainActor @Sendable () -> Void)? = nil
    ) {
        let controller = vc ?? makeDefaultViewController()

        if let secondaryNavigationController {
            secondaryNavigationController.setViewControllers(
                [controller],
                completion: completion
            )
        } else if let internalSplitViewController {
            let navigationController = UINavigationController(rootViewController: controller)
            navigationController.navigationBar.prefersLargeTitles = true
            secondaryNavigationController = navigationController

            internalSplitViewController.setViewController(
                navigationController,
                for: .secondary,
                completion: completion
            )
        } else {
            completion?()
        }
    }
}
