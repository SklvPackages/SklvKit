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

import Foundation

@MainActor
extension StatefulTableViewController {
    /// Moves a row from one location to another.
    /// - Parameters:
    ///   - indexPath: The starting index path of the row.
    ///   - newIndexPath: The destination index path of the row.
    public func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath) {
        deleteRow(append: indexPath)
        insertRow(append: newIndexPath)

        if changeIsUserDriven {
            updateCache()
        } else {
            tableView.moveRow(at: indexPath, to: newIndexPath)
        }
    }
}
