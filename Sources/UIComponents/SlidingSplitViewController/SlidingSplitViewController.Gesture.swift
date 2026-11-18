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

    /// Handles the pan gesture for dragging the sidebar.
    ///
    /// - Parameter gesture: The pan gesture recognizer capturing the user's touch events.
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard isGestureEnabled else {
            currentTouchX = nil
            return
        }

        switch gesture.state {
        case .began:
            guard state == .close || state == .open else { return }

            let x = gesture.location(in: view).x
            let width = currentViewSize.width
            let inset = zoneInsensitivityGesture + leadingSafeAreaInset
            let range: ClosedRange<CGFloat>

            if state == .close {
                if isRTL {
                    range = (width - inset)...width
                } else {
                    range = 0...inset
                }

                if range.contains(x) {
                    state = .opening
                } else {
                    return
                }
            } else {
                if isRTL {
                    range = 0...(width - sidebarWidth + inset)
                } else {
                    range = (sidebarWidth - inset)...width
                }

                if range.contains(x) {
                    state = .closing
                } else {
                    return
                }
            }

            currentTouchX = x

        case .changed:
            guard let previousX = currentTouchX else { return }

            let x = gesture.location(in: view).x
            currentTouchX = x

            var dx = x - previousX
            dx = currentTranslationX + (isRTL ? -dx : dx)
            dx = max(dx, 0)
            currentTranslationX = dx

            updateFrames()

        case .ended, .cancelled, .failed:
            guard currentTouchX != nil else { return }
            currentTouchX = nil
            autoEnd(hysteresis: true, animated: true, completion: nil)

        default: return
        }
    }

    /// Handles the tap gesture on the shadow view to close the sidebar.
    ///
    /// - Parameter gesture: The tap gesture recognizer triggering the action.
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        guard isGestureEnabled else { return }
        setSidebarOpen(false, animated: true)
    }
}
