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
extension StatefulTableViewController {
    /// Reloads a specific row, clearing its cache beforehand.
    /// - Parameters:
    ///   - indexPath: The index path of the row to reload.
    ///   - animation: The animation style to use. Defaults to `.none`.
    public func reloadRow(
        at indexPath: IndexPath,
        with animation: UITableView.RowAnimation = .none
    ) {
        let section = indexPath.section

        if section < cellHeights.count {
            let row = indexPath.row
            if row < cellHeights[section].count {
                cellHeights[section][row] = nil
                cellLayouts[section][row] = nil
            }
        }

        if section < cellModels.count {
            let row = indexPath.row
            if row < cellModels[section].count {
                cellModels[section][row] = nil
            }
        }

        tableView.reloadRows(at: [indexPath], with: animation)
    }

    /// Reloads a specific section, maintaining cache sync by tracking delete/insert operations.
    /// - Parameters:
    ///   - section: The section index to reload.
    ///   - animation: The animation style to use. Defaults to `.fade`.
    public func reloadSection(
        _ section: Int,
        with animation: UITableView.RowAnimation = .fade
    ) {
        if section < headerHeights.count {
            headerHeights[section] = nil
            headerLayouts[section] = nil
        }

        if section < headerModels.count {
            headerModels[section] = nil
        }

        if section < footerHeights.count {
            footerHeights[section] = nil
            footerLayouts[section] = nil
        }

        if section < footerModels.count {
            footerModels[section] = nil
        }

        if section < cellHeights.count {
            cellHeights[section] = []
            cellLayouts[section] = []
        }

        if section < cellModels.count {
            cellModels[section] = []
        }

        tableView.reloadSections(IndexSet(integer: section), with: animation)
    }

    /// Clears the cached height and layout metrics, and reloads all table view data.
    /// - Parameter animated: Whether the reload should be animated.
    public func reloadMetrics(animated: Bool) {
        clearMetricsCache()

        let selectedRow = tableView.indexPathForSelectedRow
        let selectedRows = tableView.indexPathsForSelectedRows

        tableView.reloadData(animated: animated)

        if let selectedRow {
            tableView.selectRow(at: selectedRow, animated: false, scrollPosition: .none)
        } else {
            selectedRows?.forEach {
                tableView.selectRow(at: $0, animated: false, scrollPosition: .none)
            }
        }
    }

    /// Clears the entire cache and reloads all table view data.
    /// - Parameter animated: Whether the reload should be animated.
    public func reloadData(animated: Bool) {
        clearCache()
        tableView.reloadData(animated: animated)
    }
}
