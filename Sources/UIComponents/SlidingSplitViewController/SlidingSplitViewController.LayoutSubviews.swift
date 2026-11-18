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

    /// Updates the frames of internal views based on the current drag translation.
    ///
    /// - Parameter isAnimating: A boolean value indicating whether the update is part of an animation block.
    func updateFrames(isAnimating: Bool = false) {
        let size = currentViewSize
        let inset = leadingSafeAreaInset
        let sidebarWidth = sidebarWidth + inset
        let dx = (state == .open) ? sidebarWidth : min(currentTranslationX, sidebarWidth)
        currentTranslationX = dx

        var splitFrame: CGRect

        if isAnimating {
            splitFrame = CGRect(
                x: isRTL ? min(0, inset - dx) : max(inset, dx),
                y: 0,
                width: size.width - inset,
                height: size.height
            )
        } else {
            splitFrame = CGRect(origin: .zero, size: size)

            if dx > inset {
                splitFrame.origin.x = isRTL ? (inset - dx) : dx
                splitFrame.size.width = size.width - inset
            }
        }

        let sidebarFrame = CGRect(
            x: isRTL ? (size.width - dx) : (dx - sidebarWidth),
            y: 0,
            width: sidebarWidth,
            height: size.height
        )

        sidebarNavigationController?.view.update(frame: sidebarFrame)
        internalSplitViewController?.view.update(frame: splitFrame)
        backgroundView.update(frame: splitFrame)
        shadowView.update(size: size)
        shadowView.update(alpha: dx / sidebarWidth)
    }

    /// Automatically completes the sliding transition based on the user's velocity and position.
    ///
    /// - Parameters:
    ///   - hysteresis: A boolean value determining if threshold-based snapping should be evaluated.
    ///   - animated: A boolean value indicating whether the transition to the final state should be animated.
    ///   - completion: An optional closure executed when the state transition finishes.
    func autoEnd(
        hysteresis: Bool,
        animated: Bool,
        completion: (@MainActor @Sendable () -> Void)?
    ) {
        guard state == .closing || state == .opening else {
            completion?()
            return
        }

        let dx = currentTranslationX
        let sidebarWidth = sidebarWidth + leadingSafeAreaInset

        if hysteresis {
            if state == .closing {
                if dx > sidebarWidth - hysteresisWidth {
                    state = .opening
                }
            } else {
                if dx < hysteresisWidth {
                    state = .closing
                }
            }
        }

        let closing = (state == .closing)
        let targetDX = closing ? 0 : sidebarWidth
        let newState: State = closing ? .close : .open

        func finalizeTransition(_ isFinished: Bool) {
            guard isFinished else { return }
            currentTranslationX = targetDX
            state = newState
            updateFrames()
            completion?()
        }

        if animated {
            updateFrames(isAnimating: true)

            UIView.animate(
                withDuration: 0.4,
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: 0,
                options: [.beginFromCurrentState, .allowUserInteraction, .layoutSubviews],
                animations: {
                    self.currentTranslationX = targetDX
                    self.updateFrames(isAnimating: true)
                },
                completion: finalizeTransition
            )
        } else {
            finalizeTransition(true)
        }
    }

    override public func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        let size = view.bounds.size
        let inset = isRTL ? view.safeAreaInsets.right : view.safeAreaInsets.left

        guard size != currentViewSize || inset != leadingSafeAreaInset else {
            return
        }

        currentViewSize = size
        leadingSafeAreaInset = inset

        guard state == .close || state == .open else { return }
        updateFrames()
    }
}
