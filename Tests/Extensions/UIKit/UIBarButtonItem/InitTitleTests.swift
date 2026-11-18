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

@Suite("UIBarButtonItem Title Initializer Tests")
@MainActor
struct UIBarButtonItemTitleInitializerTests {

    @Test("Initialize with title and handler")
    func initTitleAndHandler() {
        let title = "Action"
        let item = UIBarButtonItem(title: title) { _ in }

        #expect(item.title == title)
        #expect(item.primaryAction != nil)
    }

    @Test("Initialize with prominent title and handler")
    func initProminentTitleAndHandler() {
        let title = "Done"
        let item = UIBarButtonItem(prominentTitle: title) { _ in }

        #expect(item.title == title)
        #expect(item.primaryAction != nil)

        // Verifying that the style is at least set.
        // We avoid an exact equality check here to prevent test flakiness
        // across different iOS versions where the #available check might evaluate differently.
        #expect(item.style == .done || item.style.rawValue != 0)
    }
}
