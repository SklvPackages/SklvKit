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
extension UIViewController {
    /// Executes a completion handler after ensuring a minimum duration has passed since a starting time.
    ///
    /// - Parameters:
    ///   - startTime: The reference time when the operation began, typically obtained via `CACurrentMediaTime()`.
    ///   - minDuration: The minimum required duration in seconds. Defaults to `0.3`.
    ///   - completion: The closure to execute on the main actor after the duration is met.
    public func handleCompletion(
        from startTime: CFTimeInterval,
        minDuration: Double = 0.3,
        completion: (@MainActor @Sendable () -> Void)?
    ) {
        let delay = minDuration - (CACurrentMediaTime() - startTime)

        if delay > 0 {
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                completion?()
            }
        } else {
            completion?()
        }
    }
}

@MainActor
extension UINavigationController {
    /// Pushes a view controller onto the receiver’s stack and executes a completion handler.
    ///
    /// - Parameters:
    ///   - viewController: The view controller to push onto the stack.
    ///   - animated: Specify `true` to animate the transition or `false` if you do not want the transition to be animated.
    ///   - completion: A closure to execute after the push animation finishes.
    public func pushViewController(
        _ viewController: UIViewController,
        animated: Bool,
        completion: (@MainActor @Sendable () -> Void)?
    ) {
        if animated {
            let start = CACurrentMediaTime()
            CATransaction.begin()
            pushViewController(viewController, animated: true)
            CATransaction.setCompletionBlock {
                self.handleCompletion(from: start, completion: completion)
            }
            CATransaction.commit()
        } else {
            pushViewController(viewController, animated: false)
            completion?()
        }
    }

    /// Pops the top view controller from the navigation stack and executes a completion handler.
    ///
    /// - Parameters:
    ///   - animated: Set this value to `true` to animate the transition.
    ///   - completion: A closure to execute after the pop animation finishes.
    /// - Returns: The view controller that was popped from the stack.
    @discardableResult
    public func popViewController(
        animated: Bool,
        completion: (@MainActor @Sendable () -> Void)?
    ) -> UIViewController? {
        let result: UIViewController?

        if animated {
            let start = CACurrentMediaTime()
            CATransaction.begin()
            result = popViewController(animated: true)
            CATransaction.setCompletionBlock {
                self.handleCompletion(from: start, completion: completion)
            }
            CATransaction.commit()
        } else {
            result = popViewController(animated: false)
            completion?()
        }

        return result
    }

    /// Pops view controllers until the specified view controller is at the top of the navigation stack.
    ///
    /// - Parameters:
    ///   - viewController: The view controller that you want to be at the top of the stack.
    ///   - animated: Set this value to `true` to animate the transition.
    ///   - completion: A closure to execute after the pop animation finishes.
    /// - Returns: An array of view controllers that were popped from the stack.
    @discardableResult
    public func popToViewController(
        _ viewController: UIViewController,
        animated: Bool,
        completion: (@MainActor @Sendable () -> Void)?
    ) -> [UIViewController]? {
        let result: [UIViewController]?

        if animated {
            let start = CACurrentMediaTime()
            CATransaction.begin()
            result = popToViewController(viewController, animated: true)
            CATransaction.setCompletionBlock {
                self.handleCompletion(from: start, completion: completion)
            }
            CATransaction.commit()
        } else {
            result = popToViewController(viewController, animated: false)
            completion?()
        }

        return result
    }

    /// Pops all the view controllers on the stack except the root view controller.
    ///
    /// - Parameters:
    ///   - animated: Set this value to `true` to animate the transition.
    ///   - completion: A closure to execute after the pop animation finishes.
    /// - Returns: An array of view controllers that were popped from the stack.
    @discardableResult
    public func popToRootViewController(
        animated: Bool,
        completion: (@MainActor @Sendable () -> Void)?
    ) -> [UIViewController]? {
        let result: [UIViewController]?

        if animated {
            let start = CACurrentMediaTime()
            CATransaction.begin()
            result = popToRootViewController(animated: true)
            CATransaction.setCompletionBlock {
                self.handleCompletion(from: start, completion: completion)
            }
            CATransaction.commit()
        } else {
            result = popToRootViewController(animated: false)
            completion?()
        }

        return result
    }

    /// Replaces the view controllers currently managed by the navigation controller with the specified items and executes a completion handler.
    ///
    /// - Parameters:
    ///   - viewControllers: The view controllers to place in the stack. The order of the array specifies the hierarchy, where the first item is the root view controller and the last item is the top view controller.
    ///   - animated: Specify `true` to animate the transition or `false` if you do not want the transition to be animated.
    ///   - completion: A closure to execute after the transition finishes.
    public func setViewControllers(
        _ viewControllers: [UIViewController],
        animated: Bool,
        completion: (@MainActor @Sendable () -> Void)?
    ) {
        if animated {
            let start = CACurrentMediaTime()
            CATransaction.begin()
            setViewControllers(viewControllers, animated: true)
            CATransaction.setCompletionBlock {
                self.handleCompletion(from: start, completion: completion)
            }
            CATransaction.commit()
        } else {
            setViewControllers(viewControllers, animated: false)
            completion?()
        }
    }

    /// Replaces the view controllers currently managed by the navigation controller with the specified items without animation and executes a completion handler.
    ///
    /// - Parameters:
    ///   - viewControllers: The view controllers to place in the stack. The order of the array specifies the hierarchy, where the first item is the root view controller and the last item is the top view controller.
    ///   - completion: A closure to execute after the update completes.
    public func setViewControllers(
        _ viewControllers: [UIViewController],
        completion: (@MainActor @Sendable () -> Void)?
    ) {
        if completion != nil {
            let start = CACurrentMediaTime()
            CATransaction.begin()
            setViewControllers(viewControllers, animated: false)
            CATransaction.setCompletionBlock {
                self.handleCompletion(from: start, completion: completion)
            }
            CATransaction.commit()
        } else {
            setViewControllers(viewControllers, animated: false)
        }
    }
}

@MainActor
extension UISplitViewController {
    /// Sets the view controller for a specific column and executes a completion handler.
    ///
    /// - Parameters:
    ///   - vc: The view controller to display in the specified column.
    ///   - column: The column in which to display the view controller.
    ///   - completion: A closure to execute after the transition finishes.
    public func setViewController(
        _ vc: UIViewController?,
        for column: UISplitViewController.Column,
        completion: (@MainActor @Sendable () -> Void)?
    ) {
        if completion != nil {
            let start = CACurrentMediaTime()
            CATransaction.begin()
            setViewController(vc, for: column)
            CATransaction.setCompletionBlock {
                self.handleCompletion(from: start, completion: completion)
            }
            CATransaction.commit()
        } else {
            setViewController(vc, for: column)
        }
    }
}

@MainActor
extension UITabBarController {
    /// Sets the currently selected tab by index and executes a completion handler.
    ///
    /// - Parameters:
    ///   - index: The index of the view controller to select.
    ///   - completion: A closure to execute after the selection transition finishes.
    public func setSelectedIndex(
        _ index: Int,
        completion: (@MainActor @Sendable () -> Void)?
    ) {
        guard let count = viewControllers?.count,
              index >= 0 && index < count else {
            completion?()
            return
        }

        if completion != nil {
            let start = CACurrentMediaTime()
            CATransaction.begin()
            selectedIndex = index
            CATransaction.setCompletionBlock {
                self.handleCompletion(from: start, completion: completion)
            }
            CATransaction.commit()
        } else {
            selectedIndex = index
        }
    }

    /// Sets the currently selected view controller and executes a completion handler.
    ///
    /// - Parameters:
    ///   - vc: The view controller to select.
    ///   - completion: A closure to execute after the selection transition finishes.
    public func setSelectedViewController(
        _ vc: UIViewController?,
        completion: (@MainActor @Sendable () -> Void)?
    ) {
        if completion != nil {
            let start = CACurrentMediaTime()
            CATransaction.begin()
            selectedViewController = vc
            CATransaction.setCompletionBlock {
                self.handleCompletion(from: start, completion: completion)
            }
            CATransaction.commit()
        } else {
            selectedViewController = vc
        }
    }
}
