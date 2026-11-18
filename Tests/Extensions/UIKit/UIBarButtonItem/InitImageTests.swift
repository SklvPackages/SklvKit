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

@Suite("UIBarButtonItem Initializer Tests")
@MainActor
struct UIBarButtonItemInitializerTests {

    @Test("Initialize with image and handler")
    func initImageAndHandler() {
        let image = UIImage(systemName: "star")

        let item = UIBarButtonItem(image: image) { _ in }

        #expect(item.image == image)
        #expect(item.primaryAction != nil)
    }

    @Test("Initialize with system image name and handler")
    func initSystemImageAndHandler() {
        let symbolName = "heart.fill"

        let item = UIBarButtonItem(systemImage: symbolName) { _ in }

        // systemName isn't directly exposed as a String on UIImage,
        // but we can verify the image is not nil and the action exists.
        #expect(item.image != nil)
        #expect(item.primaryAction != nil)
    }

    @Test("Initialize with system image name and menu")
    func initSystemImageAndMenu() {
        let symbolName = "gear"
        let action = UIAction(title: "Settings") { _ in }
        let menu = UIMenu(title: "Menu", children: [action])

        let item = UIBarButtonItem(systemImage: symbolName, menu: menu)

        #expect(item.image != nil)
        #expect(item.menu?.identifier == menu.identifier)
        #expect(item.menu?.title == menu.title)
    }
}
