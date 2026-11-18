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

/// A custom table view controller designed for layout caching and prefetching.
@MainActor
open class StatefulTableViewController<Layout, Model>: UITableViewController, UITableViewDataSourcePrefetching {
    /// The current width of the table view's content area.
    public private(set) var contentWidth: CGFloat = 0
    /// Indicates whether the current layout change is driven by user interaction.
    public var changeIsUserDriven = false

    /// A flag indicating if the first layout pass has finished.
    var isInitialLayoutCompleted = false
    /// A flag indicating if the no-data background view is currently visible.
    var isNoDataViewVisible = false

    /// Cached heights for section headers.
    var headerHeights = [CGFloat?]()
    /// Cached heights for section footers.
    var footerHeights = [CGFloat?]()
    /// Cached heights for cells.
    var cellHeights = [[CGFloat?]]()

    /// Cached layouts for section headers.
    var headerLayouts = [Layout?]()
    /// Cached layouts for section footers.
    var footerLayouts = [Layout?]()
    /// Cached layouts for cells.
    var cellLayouts = [[Layout?]]()

    /// Cached display models for section headers.
    var headerModels = [Model?]()
    /// Cached display models for section footers.
    var footerModels = [Model?]()
    /// Cached display models for cells.
    var cellModels = [[Model?]]()

    /// Tracks rows to be inserted during batch updates.
    var insertRows = [Int: [Int]]()
    /// Tracks sections to be inserted during batch updates.
    var insertSections = [Int]()

    /// Tracks rows to be deleted during batch updates.
    var deleteRows = [Int: [Int]]()
    /// Tracks sections to be deleted during batch updates.
    var deleteSections = [Int]()

    override open func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedSectionHeaderHeight = 18
        tableView.estimatedSectionFooterHeight = 18
        tableView.estimatedRowHeight = 52

        tableView.prefetchDataSource = self
    }

    /// Requests metrics for a section header.
    /// - Parameter section: The section index.
    /// - Returns: A tuple containing the calculated height and layout, or `nil`.
    open func requestHeaderMetrics(atSection section: Int) -> (height: CGFloat, layout: Layout)? { nil }

    /// Requests metrics for a section footer.
    /// - Parameter section: The section index.
    /// - Returns: A tuple containing the calculated height and layout, or `nil`.
    open func requestFooterMetrics(atSection section: Int) -> (height: CGFloat, layout: Layout)? { nil }

    /// Requests metrics for a specific cell.
    /// - Parameter indexPath: The index path of the cell.
    /// - Returns: A tuple containing the calculated height and layout, or `nil`.
    open func requestCellMetrics(at indexPath: IndexPath) -> (height: CGFloat, layout: Layout)? { nil }

    /// Requests the display model for a section header.
    /// - Parameter section: The section index.
    /// - Returns: The requested model, or `nil`.
    open func requestHeaderModel(atSection section: Int) -> Model? { nil }

    /// Requests the display model for a section footer.
    /// - Parameter section: The section index.
    /// - Returns: The requested model, or `nil`.
    open func requestFooterModel(atSection section: Int) -> Model? { nil }

    /// Requests the display model for a specific cell.
    /// - Parameter indexPath: The index path of the cell.
    /// - Returns: The requested model, or `nil`.
    open func requestCellModel(at indexPath: IndexPath) -> Model? { nil }

    /// Determines if the cell metrics at the given index path can be cached.
    /// - Parameter indexPath: The index path to check.
    /// - Returns: `true` if the cell metrics is cacheable; otherwise, `false`.
    open func cellMetricsAreCacheable(at indexPath: IndexPath) -> Bool { true }

    /// Determines if the cell models at the given index path can be cached.
    /// - Parameter indexPath: The index path to check.
    /// - Returns: `true` if the cell models is cacheable; otherwise, `false`.
    open func cellModelsIsCacheable(at indexPath: IndexPath) -> Bool { true }

    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard isInitialLayoutCompleted else { return }

        var processedSections = Set<Int>()

        for indexPath in indexPaths {
            cellHeight(at: indexPath)

            let section = indexPath.section
            if !processedSections.contains(section) {
                processedSections.insert(section)

                headerHeight(atSection: section)
                footerHeight(atSection: section)
            }
        }
    }

    override open func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        if isInitialLayoutCompleted, let height = headerHeight(atSection: section) {
            return height
        } else {
            return tableView.estimatedSectionHeaderHeight
        }
    }

    override open func tableView(
        _ tableView: UITableView,
        heightForFooterInSection section: Int
    ) -> CGFloat {
        if isInitialLayoutCompleted, let height = footerHeight(atSection: section) {
            return height
        } else {
            return tableView.estimatedSectionFooterHeight
        }
    }

    override open func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        if isInitialLayoutCompleted, let height = cellHeight(at: indexPath) {
            return height
        } else {
            return tableView.estimatedRowHeight
        }
    }

    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        let tableWidth = tableView.bounds.size.width
        let isInsetGrouped = (tableView.style == .insetGrouped)
        let tableInsets = isInsetGrouped ? tableView.layoutMargins : tableView.safeAreaInsets
        let newContentWidth = tableWidth - tableInsets.left - tableInsets.right

        if newContentWidth > 0, newContentWidth != contentWidth {
            contentWidth = newContentWidth
            isInitialLayoutCompleted = true
            reloadMetrics(animated: false)
        }

        if let backgroundView = tableView.backgroundView,
           backgroundView.alpha == 1,
           let noDataView = backgroundView.subviews.first {
            var tableMargins = tableView.layoutMargins
            tableMargins.top = -(tableView.contentOffset.y + tableView.adjustedContentInset.top)
            tableMargins.bottom = 0

            var rect = backgroundView.frame
            rect.origin.x = tableMargins.left
            rect.origin.y = tableMargins.top
            rect.size.width -= tableMargins.left + tableMargins.right
            rect.size.height -= tableMargins.top + tableMargins.bottom

            noDataView.update(frame: rect)
        }
    }
}
