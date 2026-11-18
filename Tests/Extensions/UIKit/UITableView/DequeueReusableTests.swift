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

import Testing
import UIKit
@testable import SklvKit

@Suite("UITableView Dequeue Tests")
@MainActor
struct UITableViewDequeueTests {

    // Custom subclasses for testing
    private class CustomTestCell: UITableViewCell {}
    private class CustomTestHeaderFooterView: UITableViewHeaderFooterView {}

    @Test("Dequeue registered cell successfully")
    func dequeueRegisteredCell() {
        let tableView = UITableView()
        tableView.register(CustomTestCell.self, forCellReuseIdentifier: String(describing: CustomTestCell.self))

        let cell = tableView.dequeueReusable(CustomTestCell.self)

        #expect(cell != nil)
    }

    @Test("Dequeue unregistered cell returns nil")
    func dequeueUnregisteredCell() {
        let tableView = UITableView()

        let cell = tableView.dequeueReusable(CustomTestCell.self)

        #expect(cell == nil)
    }

    @Test("Dequeue registered header footer view successfully")
    func dequeueRegisteredHeaderFooterView() {
        let tableView = UITableView()
        tableView.register(CustomTestHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: String(describing: CustomTestHeaderFooterView.self))

        let view = tableView.dequeueReusable(CustomTestHeaderFooterView.self)

        #expect(view != nil)
    }
}
