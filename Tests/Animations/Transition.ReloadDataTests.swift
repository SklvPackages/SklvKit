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

@Suite("UITableView Reload Data Tests")
@MainActor
struct UITableViewReloadDataTests {

    @Test("Reload data immediately without animation")
    func reloadDataImmediately() {
        let tableView = UITableView()

        var isCompletionCalled = false

        tableView.reloadData(animated: false) { finished in
            isCompletionCalled = true
        }

        #expect(isCompletionCalled)
    }

    @Test("Reload data with animation")
    func reloadDataAnimated() async {
        let tableView = UITableView()

        await withCheckedContinuation { continuation in
            tableView.reloadData(animated: true) { _ in
                continuation.resume()
            }
        }

        // The test succeeds if the continuation resumes properly
        #expect(true)
    }
}
