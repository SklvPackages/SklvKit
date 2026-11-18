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
extension SlidingSplitViewController: UISplitViewControllerDelegate {

    /// Determines the column to show when the split view controller collapses.
    ///
    /// - Parameters:
    ///   - svc: The split view controller that is collapsing.
    ///   - proposedTopColumn: The column proposed by the split view controller.
    /// - Returns: The column that should be displayed on top after collapsing.
    public func splitViewController(
        _ svc: UISplitViewController,
        topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column
    ) -> UISplitViewController.Column {
        preferredTopColumn
    }

    /// Tells the delegate that the split view controller collapsed its columns.
    ///
    /// - Parameter svc: The split view controller that collapsed.
    public func splitViewControllerDidCollapse(_ svc: UISplitViewController) {
        isCollapsed = true
        collapseDelegate?.collapsedDidChange(to: true)
    }

    /// Tells the delegate that the split view controller expanded its columns.
    ///
    /// - Parameter svc: The split view controller that expanded.
    public func splitViewControllerDidExpand(_ svc: UISplitViewController) {
        isCollapsed = false
        collapseDelegate?.collapsedDidChange(to: false)
    }
}

@MainActor
extension SlidingSplitViewController: UIGestureRecognizerDelegate {

    /// Asks the delegate if a gesture recognizer should begin interpreting touches.
    ///
    /// - Parameter gestureRecognizer: An instance of a subclass of `UIGestureRecognizer`.
    /// - Returns: A boolean value indicating whether the gesture recognizer should begin.
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }

    /// Asks the delegate if two gesture recognizers should be allowed to recognize gestures simultaneously.
    ///
    /// - Parameters:
    ///   - gestureRecognizer: The first gesture recognizer.
    ///   - otherGestureRecognizer: The second gesture recognizer.
    /// - Returns: A boolean value indicating whether both gesture recognizers should be allowed to recognize gestures simultaneously.
    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        switch otherGestureRecognizer.state {
        case .possible, .began, .changed, .ended:
            let text = "\(otherGestureRecognizer)".lowercased()
            return text.contains("swipe") && (state == .close)
        default:
            return false
        }
    }
}

@MainActor
extension SlidingSplitViewController: UINavigationControllerDelegate {

    /// Called just before the navigation controller displays a view controller’s view and navigation item properties.
    ///
    /// - Parameters:
    ///   - navigationController: The navigation controller whose view and navigation item properties are being shown.
    ///   - viewController: The view controller whose view and navigation item properties are being shown.
    ///   - animated: A boolean value indicating whether the transition is animated.
    public func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController, animated: Bool
    ) {
        if navigationController.viewControllers.count > 1 {
            placeholderTask?.cancel()
            placeholderTask = nil

            isGestureEnabled = false
            setSidebarOpen(false, animated: false)
        } else {
            isGestureEnabled = true
        }

        guard !isShowingPlaceholder, isCollapsed,
              let coordinator = navigationController.transitionCoordinator,
              let fromVC = coordinator.viewController(forKey: .from),
              fromVC !== viewController else {
            return
        }

        coordinator.animate(alongsideTransition: nil) { [weak self, weak navigationController] context in
            guard !context.isCancelled,
                  let self, let navigationController,
                  navigationController.viewControllers.count == 1 else {
                return
            }

            self.placeholderTask?.cancel()
            self.placeholderTask = Task { @MainActor [weak self] in
                guard !Task.isCancelled, let self else { return }

                self.setPlaceholderViewController()
                self.dismissDelegate?.didDismissSecondary()
            }
        }
    }
}
