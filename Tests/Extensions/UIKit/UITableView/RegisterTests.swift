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

@Suite("UITableView Register Tests")
@MainActor
struct UITableViewRegisterTests {

    private class CustomRegisterCell: UITableViewCell {}
    private class CustomRegisterHeaderFooterView: UITableViewHeaderFooterView {}

    @Test("Register cell using class name as identifier")
    func registerCell() {
        let tableView = UITableView()

        // Use our custom register method
        tableView.register(CustomRegisterCell.self)

        // Verify by attempting to dequeue using standard UIKit API with the expected string
        let expectedIdentifier = String(describing: CustomRegisterCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: expectedIdentifier)

        #expect(cell is CustomRegisterCell)
    }

    @Test("Register header footer view using class name as identifier")
    func registerHeaderFooterView() {
        let tableView = UITableView()

        // Use our custom register method
        tableView.register(CustomRegisterHeaderFooterView.self)

        // Verify by attempting to dequeue using standard UIKit API with the expected string
        let expectedIdentifier = String(describing: CustomRegisterHeaderFooterView.self)
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: expectedIdentifier)

        #expect(view is CustomRegisterHeaderFooterView)
    }
}
