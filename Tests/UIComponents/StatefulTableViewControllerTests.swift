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

/// A mock subclass of `StatefulTableViewController` to provide predictable metrics for testing.
@MainActor
final class MockTableViewController: StatefulTableViewController<String, Int> {
    override func requestCellMetrics(at indexPath: IndexPath) -> (height: CGFloat, layout: String)? {
        return (height: 50.0, layout: "CellLayout-\(indexPath.section)-\(indexPath.row)")
    }

    override func requestHeaderMetrics(atSection section: Int) -> (height: CGFloat, layout: String)? {
        return (height: 20.0, layout: "HeaderLayout-\(section)")
    }
}

@Suite("StatefulTableViewController Caching and Updates Tests")
@MainActor
struct TableViewControllerTests {

    @Test("Caches cell metrics on first request and retrieves them subsequently")
    func cachesCellMetrics() {
        let sut = MockTableViewController()
        sut.isInitialLayoutCompleted = true // Bypass initial layout guard

        let indexPath = IndexPath(row: 0, section: 0)
        let height = sut.cellHeight(at: indexPath)

        // Expect height to be calculated and cached
        #expect(height == 50.0)
        #expect(sut.cellHeights.count == 1)
        #expect(sut.cellHeights[0].count == 1)
        #expect(sut.cellHeights[0][0] == 50.0)
        #expect(sut.cellLayouts[0][0] == "CellLayout-0-0")
    }

    @Test("Clears all metric caches correctly")
    func clearsCache() {
        let sut = MockTableViewController()
        sut.isInitialLayoutCompleted = true

        // Populate cache
        sut.cellHeight(at: IndexPath(row: 0, section: 0))
        sut.headerHeight(atSection: 0)

        #expect(!sut.cellHeights.isEmpty)
        #expect(!sut.headerHeights.isEmpty)

        sut.clearCache()

        // Expect cache arrays to be completely empty
        #expect(sut.cellHeights.isEmpty)
        #expect(sut.headerHeights.isEmpty)
    }

    @Test("Updates cache correctly after simulating row insertion and deletion")
    func updatesCacheForRows() {
        let sut = MockTableViewController()
        sut.isInitialLayoutCompleted = true

        // Populate initial cache with two rows
        sut.cellHeight(at: IndexPath(row: 0, section: 0))
        sut.cellHeight(at: IndexPath(row: 1, section: 0))

        // Schedule deletion of row 0 and insertion of a new row at 0
        sut.deleteRow(append: IndexPath(row: 0, section: 0))
        sut.insertRow(append: IndexPath(row: 0, section: 0))

        sut.updateCache()

        // Row 0 was deleted (removing the cached 50.0), then a new row was inserted (putting nil)
        #expect(sut.cellHeights[0][0] == nil)
        // Row 1 shifted to row 0, then shifted back to row 1, retaining its value
        #expect(sut.cellHeights[0][1] == 50.0)
    }

    @Test("Sets background view correctly for no-data text state")
    func configuresNoDataViewText() {
        let sut = MockTableViewController()
        sut.setNoData(text: "No Data Available")

        let backgroundView = sut.tableView.backgroundView

        // Expect background view to be initialized but hidden by default
        #expect(backgroundView != nil)
        #expect(backgroundView?.isHidden == true)
        #expect(backgroundView?.alpha == 0)
        #expect(sut.isNoDataViewVisible == false)

        // Verify label was added
        let label = backgroundView?.subviews.compactMap { $0 as? UILabel }.first
        #expect(label?.text == "No Data Available")
    }

    @Test("Clears specific cell cache when reloadRow is called")
    func reloadsRowClearsCache() {
        let sut = MockTableViewController()
        sut.isInitialLayoutCompleted = true

        let indexPath = IndexPath(row: 0, section: 0)
        sut.cellHeight(at: indexPath)

        #expect(sut.cellHeights[0][0] == 50.0)

        // Reload should nullify the specific cached value
        sut.reloadRow(at: indexPath, with: .none)

        #expect(sut.cellHeights[0][0] == nil)
        #expect(sut.cellLayouts[0][0] == nil)
    }
}
