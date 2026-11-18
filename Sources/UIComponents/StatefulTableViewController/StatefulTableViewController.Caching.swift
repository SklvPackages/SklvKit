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
    /// Caches the height and layout metrics for a header.
    private func cacheHeader(metrics: (height: CGFloat, layout: Layout), atSection section: Int) {
        let sectionDiff = section - headerHeights.count + 1
        if sectionDiff == 1 {
            headerHeights.append(metrics.height)
            headerLayouts.append(metrics.layout)
        } else if sectionDiff > 1 {
            headerHeights.append(contentsOf: repeatElement(nil, count: sectionDiff))
            headerLayouts.append(contentsOf: repeatElement(nil, count: sectionDiff))

            headerHeights[section] = metrics.height
            headerLayouts[section] = metrics.layout
        } else {
            headerHeights[section] = metrics.height
            headerLayouts[section] = metrics.layout
        }
    }

    /// Caches the display model for a header.
    private func cacheHeader(model: Model, atSection section: Int) {
        let sectionDiff = section - headerModels.count + 1
        if sectionDiff == 1 {
            headerModels.append(model)
        } else if sectionDiff > 1 {
            headerModels.append(contentsOf: repeatElement(nil, count: sectionDiff))
            headerModels[section] = model
        } else {
            headerModels[section] = model
        }
    }

    /// Retrieves or computes the height for a section header.
    @discardableResult
    func headerHeight(atSection section: Int) -> CGFloat? {
        if section < headerHeights.count, let cached = headerHeights[section] {
            return cached
        } else if let metrics = requestHeaderMetrics(atSection: section) {
            cacheHeader(metrics: metrics, atSection: section)
            return metrics.height
        } else {
            return nil
        }
    }

    /// Retrieves the layout for a section header.
    public func headerLayout(atSection section: Int) -> Layout? {
        guard isInitialLayoutCompleted else { return nil }

        if section < headerLayouts.count, let cached = headerLayouts[section] {
            return cached
        } else if let metrics = requestHeaderMetrics(atSection: section) {
            cacheHeader(metrics: metrics, atSection: section)
            return metrics.layout
        } else {
            return nil
        }
    }

    /// Retrieves the display model for a section header.
    public func headerModel(atSection section: Int) -> Model? {
        guard isInitialLayoutCompleted else { return nil }

        if section < headerModels.count, let cached = headerModels[section] {
            return cached
        } else if let model = requestHeaderModel(atSection: section) {
            cacheHeader(model: model, atSection: section)
            return model
        } else {
            return nil
        }
    }

    /// Caches the height and layout metrics for a footer.
    private func cacheFooter(metrics: (height: CGFloat, layout: Layout), atSection section: Int) {
        let sectionDiff = section - footerHeights.count + 1
        if sectionDiff == 1 {
            footerHeights.append(metrics.height)
            footerLayouts.append(metrics.layout)
        } else if sectionDiff > 1 {
            footerHeights.append(contentsOf: repeatElement(nil, count: sectionDiff))
            footerLayouts.append(contentsOf: repeatElement(nil, count: sectionDiff))

            footerHeights[section] = metrics.height
            footerLayouts[section] = metrics.layout
        } else {
            footerHeights[section] = metrics.height
            footerLayouts[section] = metrics.layout
        }
    }

    /// Caches the display model for a footer.
    private func cacheFooter(model: Model, atSection section: Int) {
        let sectionDiff = section - footerModels.count + 1
        if sectionDiff == 1 {
            footerModels.append(model)
        } else if sectionDiff > 1 {
            footerModels.append(contentsOf: repeatElement(nil, count: sectionDiff))
            footerModels[section] = model
        } else {
            footerModels[section] = model
        }
    }

    /// Retrieves or computes the height for a section footer.
    @discardableResult
    func footerHeight(atSection section: Int) -> CGFloat? {
        if section < footerHeights.count, let cached = footerHeights[section] {
            return cached
        } else if let metrics = requestFooterMetrics(atSection: section) {
            cacheFooter(metrics: metrics, atSection: section)
            return metrics.height
        } else {
            return nil
        }
    }

    /// Retrieves the layout for a section footer.
    public func footerLayout(atSection section: Int) -> Layout? {
        guard isInitialLayoutCompleted else { return nil }

        if section < footerLayouts.count, let cached = footerLayouts[section] {
            return cached
        } else if let metrics = requestFooterMetrics(atSection: section) {
            cacheFooter(metrics: metrics, atSection: section)
            return metrics.layout
        } else {
            return nil
        }
    }

    /// Retrieves the display model for a section footer.
    public func footerModel(atSection section: Int) -> Model? {
        guard isInitialLayoutCompleted else { return nil }

        if section < footerModels.count, let cached = footerModels[section] {
            return cached
        } else if let model = requestFooterModel(atSection: section) {
            cacheFooter(model: model, atSection: section)
            return model
        } else {
            return nil
        }
    }

    /// Caches the height and layout metrics for a cell.
    private func cacheCell(metrics: (height: CGFloat, layout: Layout), at indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row

        let sectionDiff = section - cellHeights.count + 1
        if sectionDiff == 1 {
            cellHeights.append([])
            cellLayouts.append([])
        } else if sectionDiff > 1 {
            cellHeights.append(contentsOf: repeatElement([], count: sectionDiff))
            cellLayouts.append(contentsOf: repeatElement([], count: sectionDiff))
        }

        let rowDiff = row - cellHeights[section].count + 1
        if rowDiff == 1 {
            cellHeights[section].append(metrics.height)
            cellLayouts[section].append(metrics.layout)
        } else if rowDiff > 1 {
            cellHeights[section].append(contentsOf: repeatElement(nil, count: rowDiff))
            cellLayouts[section].append(contentsOf: repeatElement(nil, count: rowDiff))

            cellHeights[section][row] = metrics.height
            cellLayouts[section][row] = metrics.layout
        } else {
            cellHeights[section][row] = metrics.height
            cellLayouts[section][row] = metrics.layout
        }
    }

    /// Caches the display model for a cell.
    private func cacheCell(model: Model, at indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row

        let sectionDiff = section - cellModels.count + 1
        if sectionDiff == 1 {
            cellModels.append([])
        } else if sectionDiff > 1 {
            cellModels.append(contentsOf: repeatElement([], count: sectionDiff))
        }

        let rowDiff = row - cellModels[section].count + 1
        if rowDiff == 1 {
            cellModels[section].append(model)
        } else if rowDiff > 1 {
            cellModels[section].append(contentsOf: repeatElement(nil, count: rowDiff))
            cellModels[section][row] = model
        } else {
            cellModels[section][row] = model
        }
    }

    /// Retrieves or computes the height for a cell.
    @discardableResult
    func cellHeight(at indexPath: IndexPath) -> CGFloat? {
        let isCacheable = cellMetricsAreCacheable(at: indexPath)

        if isCacheable {
            let section = indexPath.section
            if section < cellHeights.count {
                let rowCache = cellHeights[section]
                let row = indexPath.row
                if row < rowCache.count, let cached = rowCache[row] {
                    return cached
                }
            }
        }

        if let metrics = requestCellMetrics(at: indexPath) {
            if isCacheable {
                cacheCell(metrics: metrics, at: indexPath)
            }
            return metrics.height
        }

        return nil
    }

    /// Retrieves the layout for a cell.
    public func cellLayout(at indexPath: IndexPath) -> Layout? {
        guard isInitialLayoutCompleted else { return nil }

        let isCacheable = cellMetricsAreCacheable(at: indexPath)

        if isCacheable {
            let section = indexPath.section
            if section < cellLayouts.count {
                let rowCache = cellLayouts[section]
                let row = indexPath.row
                if row < rowCache.count, let cached = rowCache[row] {
                    return cached
                }
            }
        }

        if let metrics = requestCellMetrics(at: indexPath) {
            if isCacheable {
                cacheCell(metrics: metrics, at: indexPath)
            }
            return metrics.layout
        }

        return nil
    }

    /// Retrieves the display model for a cell.
    public func cellModel(at indexPath: IndexPath) -> Model? {
        guard isInitialLayoutCompleted else { return nil }

        let isCacheable = cellModelsIsCacheable(at: indexPath)

        if isCacheable {
            let section = indexPath.section
            if section < cellModels.count {
                let rowCache = cellModels[section]
                let row = indexPath.row
                if row < rowCache.count, let cached = rowCache[row] {
                    return cached
                }
            }
        }

        if let model = requestCellModel(at: indexPath) {
            if isCacheable {
                cacheCell(model: model, at: indexPath)
            }
            return model
        }

        return nil
    }

    /// Clears the cached height and layout metrics.
    public func clearMetricsCache() {
        headerHeights = []
        headerLayouts = []

        footerHeights = []
        footerLayouts = []

        cellHeights = []
        cellLayouts = []
    }

    /// Clears all cached metrics and models.
    public func clearCache() {
        clearMetricsCache()

        headerModels = []
        footerModels = []
        cellModels = []
    }

    /// Synchronizes the cache with the pending insert and delete operations.
    func updateCache() {
        // Delete rows
        let cellHeightsSectionCount = cellHeights.count
        let cellModelsSectionCount = cellModels.count

        for section in deleteRows.keys.sorted(by: >) {
            if section < cellHeightsSectionCount,
               let rows = deleteRows[section] {
                let cellRowCount = cellHeights[section].count

                for index in rows.sorted(by: >) {
                    guard index < cellRowCount else { continue }
                    cellHeights[section].remove(at: index)
                    cellLayouts[section].remove(at: index)
                }
            }

            if section < cellModelsSectionCount,
               let rows = deleteRows[section] {
                let cellRowCount = cellModels[section].count

                for index in rows.sorted(by: >) {
                    guard index < cellRowCount else { continue }
                    cellModels[section].remove(at: index)
                }
            }
        }

        // Delete sections
        let headerHeightsSectionCount = headerHeights.count
        let headerModelsSectionCount = headerModels.count

        let footerHeightsSectionCount = footerHeights.count
        let footerModelsSectionCount = footerModels.count

        for section in deleteSections.sorted(by: >) {
            if section < headerHeightsSectionCount {
                headerHeights.remove(at: section)
                headerLayouts.remove(at: section)
            }

            if section < headerModelsSectionCount {
                headerModels.remove(at: section)
            }

            if section < footerHeightsSectionCount {
                footerHeights.remove(at: section)
                footerLayouts.remove(at: section)
            }

            if section < footerModelsSectionCount {
                footerModels.remove(at: section)
            }

            if section < cellHeightsSectionCount {
                cellHeights.remove(at: section)
                cellLayouts.remove(at: section)
            }

            if section < cellModelsSectionCount {
                cellModels.remove(at: section)
            }
        }

        // Insert sections
        var newHeaderHeightsSectionCount = headerHeights.count
        var newHeaderModelsSectionCount = headerModels.count

        var newFooterHeightsSectionCount = footerHeights.count
        var newFooterModelsSectionCount = footerModels.count

        var newCellHeightsSectionCount = cellHeights.count
        var newCellModelsSectionCount = cellModels.count

        for section in insertSections.sorted() {
            if section <= newHeaderHeightsSectionCount {
                headerHeights.insert(nil, at: section)
                headerLayouts.insert(nil, at: section)
                newHeaderHeightsSectionCount += 1
            }

            if section <= newHeaderModelsSectionCount {
                headerModels.insert(nil, at: section)
                newHeaderModelsSectionCount += 1
            }

            if section <= newFooterHeightsSectionCount {
                footerHeights.insert(nil, at: section)
                footerLayouts.insert(nil, at: section)
                newFooterHeightsSectionCount += 1
            }

            if section <= newFooterModelsSectionCount {
                footerModels.insert(nil, at: section)
                newFooterModelsSectionCount += 1
            }

            if section <= newCellHeightsSectionCount {
                cellHeights.insert([], at: section)
                cellLayouts.insert([], at: section)
                newCellHeightsSectionCount += 1
            }

            if section <= newCellModelsSectionCount {
                cellModels.insert([], at: section)
                newCellModelsSectionCount += 1
            }
        }

        // Insert rows
        for section in insertRows.keys.sorted() {
            if section < newCellHeightsSectionCount,
               let rows = insertRows[section] {
                var newCellRowCount = cellHeights[section].count

                for index in rows.sorted() {
                    guard index <= newCellRowCount else { continue }
                    cellHeights[section].insert(nil, at: index)
                    cellLayouts[section].insert(nil, at: index)
                    newCellRowCount += 1
                }
            }

            if section < newCellModelsSectionCount,
               let rows = insertRows[section] {
                var newCellRowCount = cellModels[section].count

                for index in rows.sorted() {
                    guard index <= newCellRowCount else { continue }
                    cellModels[section].insert(nil, at: index)
                    newCellRowCount += 1
                }
            }
        }

        // Clear tracking queues
        deleteRows = [:]
        insertRows = [:]
        deleteSections = []
        insertSections = []
    }
}
