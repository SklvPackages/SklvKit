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

/// A protocol for monitoring changes to the split view controller's collapsed state.
public protocol SlidingSplitViewCollapseDelegate: AnyObject {
    /// Called when the split view controller's collapsed state changes.
    /// - Parameter isCollapsed: A boolean value indicating whether the split view controller is currently collapsed.
    func collapsedDidChange(to isCollapsed: Bool)
}

/// A protocol for detecting when the secondary view controller is dismissed.
public protocol SlidingSplitViewDismissDelegate: AnyObject {
    /// Called when the secondary view controller is dismissed and only the primary remains visible.
    func didDismissSecondary()
}

/// A view controller that manages a sliding sidebar alongside an internal split view controller.
///
/// This controller provides a custom navigation experience, combining a sliding sidebar menu
/// with a standard double-column `UISplitViewController`. It supports both tap and pan gestures
/// for interaction.
@MainActor
public final class SlidingSplitViewController: UIViewController {

    /// The internal split view controller managing the primary and secondary columns.
    private(set) weak var internalSplitViewController: UISplitViewController?

    /// The navigation controller responsible for managing the sidebar content.
    private(set) weak var sidebarNavigationController: UINavigationController?

    /// The navigation controller for the primary column.
    var primaryNavigationController: UINavigationController?

    /// The navigation controller for the secondary column.
    public internal(set) var secondaryNavigationController: UINavigationController?

    let backgroundView = UIView()
    let shadowView = UIView()

    private(set) lazy var panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
    private(set) lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))

    /// Creates a new instance of `SlidingSplitViewController`.
    public init() {
        super.init(nibName: nil, bundle: nil)

        view.backgroundColor = .secondarySystemGroupedBackground

        backgroundView.isUserInteractionEnabled = false
        backgroundView.backgroundColor = .systemBackground
        view.addSubview(backgroundView)

        let splitViewController = UISplitViewController(style: .doubleColumn)
        splitViewController.preferredDisplayMode = .oneBesideSecondary
        splitViewController.preferredSplitBehavior = .displace
        splitViewController.primaryBackgroundStyle = .none
        splitViewController.displayModeButtonVisibility = .never
        splitViewController.presentsWithGesture = false
        splitViewController.delegate = self
        addSubcontroller(splitViewController)
        self.internalSplitViewController = splitViewController

        shadowView.isUserInteractionEnabled = false
        shadowView.isHidden = true
        shadowView.alpha = 0
        shadowView.backgroundColor = UIColor.init(dynamicProvider: {
            if $0.userInterfaceStyle == .dark {
                .black.withAlphaComponent(0.46)
            } else {
                .black.withAlphaComponent(0.2)
            }
        })
        view.addSubview(shadowView)

        let sidebarNavigationController = UINavigationController()
        sidebarNavigationController.navigationBar.prefersLargeTitles = true
        sidebarNavigationController.view.isUserInteractionEnabled = false
        sidebarNavigationController.view.isHidden = true
        addSubcontroller(sidebarNavigationController)
        self.sidebarNavigationController = sidebarNavigationController

        panGesture.maximumNumberOfTouches = 1
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)

        shadowView.addGestureRecognizer(tapGesture)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// A closure executed the first time the view appears on the screen.
    public var onFirstAppear: (@MainActor () -> Void)?

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        onFirstAppear?()
        onFirstAppear = nil
    }

    /// A boolean value indicating whether the internal split view controller is currently collapsed.
    public internal(set) var isCollapsed = false

    /// The color of the separator between the split view columns.
    public var separatorColor: UIColor? {
        get {
            internalSplitViewController?.view.backgroundColor
        }
        set {
            internalSplitViewController?.view.update(backgroundColor: newValue)
        }
    }

    /// A boolean value that determines whether the sliding view ignores user interaction gestures.
    public var ignoresGestures = false {
        didSet {
            panGesture.update(isEnabled: !ignoresGestures)
            tapGesture.update(isEnabled: !ignoresGestures)
        }
    }

    /// A closure that provides a placeholder view controller for the secondary column when collapsed.
    public var makePlaceholderViewController: (@MainActor () -> UIViewController?)? {
        didSet {
            isShowingPlaceholder = false
        }
    }

    /// The delegate responsible for handling collapse state changes.
    public weak var collapseDelegate: (any SlidingSplitViewCollapseDelegate)?

    /// The delegate responsible for handling secondary view controller dismissals.
    public weak var dismissDelegate: (any SlidingSplitViewDismissDelegate)?

    let sidebarWidth: CGFloat = 320
    let hysteresisWidth: CGFloat = 20
    let zoneInsensitivityGesture: CGFloat = 60

    var isShowingPlaceholder = false
    var preferredTopColumn: UISplitViewController.Column = .primary
    var isGestureEnabled = true
    var currentTouchX: CGFloat?
    var currentTranslationX: CGFloat = 0
    var currentViewSize: CGSize = .zero
    var leadingSafeAreaInset: CGFloat = 0

    var placeholderTask: Task<Void, Never>?

    private(set) lazy var isRTL = view.rightToLeftDirection

    /// Represents the visibility state of the sidebar.
    enum State {
        case close, closing, open, opening
    }

    /// The current state of the sidebar, which updates view properties and interaction states upon change.
    var state: State = .close {
        didSet {
            switch state {
            case .close:
                internalSplitViewController?.view.update(isUserInteractionEnabled: true)

                sidebarNavigationController?.view.update(isUserInteractionEnabled: false)
                sidebarNavigationController?.view.update(isHidden: true)

                shadowView.update(isUserInteractionEnabled: false)
                shadowView.update(isHidden: true)

            case .open:
                internalSplitViewController?.view.update(isUserInteractionEnabled: false)

                sidebarNavigationController?.view.update(isUserInteractionEnabled: true)
                sidebarNavigationController?.view.update(isHidden: false)

                shadowView.update(isUserInteractionEnabled: true)
                shadowView.update(isHidden: false)

            case .closing, .opening:
                internalSplitViewController?.view.update(isUserInteractionEnabled: false)

                sidebarNavigationController?.view.update(isUserInteractionEnabled: false)
                sidebarNavigationController?.view.update(isHidden: false)

                shadowView.update(isUserInteractionEnabled: false)
                shadowView.update(isHidden: false)

                guard state == .closing else { return }
                sidebarNavigationController?.viewControllers.first?.update(isEditing: false)
            }
        }
    }
}
