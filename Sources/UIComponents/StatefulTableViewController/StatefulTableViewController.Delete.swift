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
    /// Tracks a row deletion to keep the cache synchronized.
    /// - Parameter indexPath: The index path of the row to delete.
    func deleteRow(append indexPath: IndexPath) {
        let section = indexPath.section

        if deleteRows[section] == nil {
            deleteRows[section] = [indexPath.row]
        } else {
            deleteRows[section]!.append(indexPath.row)
        }
    }

    /// Deletes a row from the table view and schedules a cache update.
    /// - Parameters:
    ///   - indexPath: The index path of the row to delete.
    ///   - animation: The animation style to use. Defaults to `.fade`.
    public func deleteRow(
        at indexPath: IndexPath,
        with animation: UITableView.RowAnimation = .fade
    ) {
        deleteRow(append: indexPath)
        tableView.deleteRows(at: [indexPath], with: animation)
    }

    /// Deletes a section from the table view and schedules a cache update.
    /// - Parameters:
    ///   - section: The section index to delete.
    ///   - animation: The animation style to use. Defaults to `.fade`.
    public func deleteSection(
        _ section: Int,
        with animation: UITableView.RowAnimation = .fade
    ) {
        deleteSections.append(section)
        tableView.deleteSections(IndexSet(integer: section), with: animation)
    }
}
