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
extension UITableView {
    /// Dequeues a reusable table view cell using its class name as the reuse identifier.
    ///
    /// Note: The cell must be registered with the table view using a reuse identifier
    /// that perfectly matches the class name.
    ///
    /// - Parameter cellClass: The class type of the cell to dequeue.
    /// - Returns: A dequeued cell of the specified type, or `nil` if the cell could not be dequeued or cast.
    public func dequeueReusable<T: UITableViewCell>(_ cellClass: T.Type) -> T? {
        dequeueReusableCell(withIdentifier: String(describing: cellClass)) as? T
    }

    /// Dequeues a reusable header or footer view using its class name as the reuse identifier.
    ///
    /// Note: The view must be registered with the table view using a reuse identifier
    /// that perfectly matches the class name.
    ///
    /// - Parameter viewClass: The class type of the header or footer view to dequeue.
    /// - Returns: A dequeued view of the specified type, or `nil` if the view could not be dequeued or cast.
    public func dequeueReusable<T: UITableViewHeaderFooterView>(_ viewClass: T.Type) -> T? {
        dequeueReusableHeaderFooterView(withIdentifier: String(describing: viewClass)) as? T
    }
}
