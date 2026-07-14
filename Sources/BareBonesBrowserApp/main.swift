//
//  main.swift
//  BareBonesBrowser
//
//  Copyright © 2024 DuckDuckGo. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#if os(macOS)

import AppKit
import SwiftUI
import WebKit
import BareBonesBrowserKit

// A tiny macOS host that opens `BareBonesBrowserView` in a window.
// Run it from the command line with `swift run`.
final class AppDelegate: NSObject, NSApplicationDelegate, BareBonesBrowserUIDelegate {

    private let homeURL = URL(string: "https://duckduckgo.com/")!
    private let userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_3) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.2 Safari/605.1.15"

    // One non-persistent configuration shared across all windows, matching the app.
    private static let webViewConfiguration: WKWebViewConfiguration = {
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        configuration.processPool = WKProcessPool()
        return configuration
    }()

    // Retain window controllers so their windows aren't deallocated.
    private var windowControllers: [NSWindowController] = []

    func applicationDidFinishLaunching(_ notification: Notification) {
        openBrowserWindow(url: homeURL)
        NSApp.activate(ignoringOtherApps: true)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }

    func browserDidRequestNewWindow(urlRequest: URLRequest) {
        guard let url = urlRequest.url else { return }
        openBrowserWindow(url: url)
    }

    private func openBrowserWindow(url: URL) {
        let browserView = BareBonesBrowserView(initialURL: url,
                                               homeURL: homeURL,
                                               uiDelegate: self,
                                               configuration: Self.webViewConfiguration,
                                               userAgent: userAgent)

        let hostingView = NSHostingView(rootView: browserView)
        let viewController = NSViewController()
        viewController.view = hostingView

        let window = NSWindow(contentViewController: viewController)
        window.title = "Bare Bones Browser"
        window.setContentSize(NSSize(width: 1024, height: 768))
        window.center()

        let windowController = NSWindowController(window: window)
        windowControllers.append(windowController)
        windowController.showWindow(nil)
        window.makeKeyAndOrderFront(nil)
    }
}

// Minimal main menu so the standard shortcuts (Cmd+Q, Cmd+W) work.
private func makeMainMenu() -> NSMenu {
    let mainMenu = NSMenu()

    let appMenuItem = NSMenuItem()
    mainMenu.addItem(appMenuItem)
    let appMenu = NSMenu()
    appMenu.addItem(withTitle: "Quit Bare Bones Browser", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
    appMenuItem.submenu = appMenu

    let windowMenuItem = NSMenuItem()
    mainMenu.addItem(windowMenuItem)
    let windowMenu = NSMenu(title: "Window")
    windowMenu.addItem(withTitle: "Close", action: #selector(NSWindow.performClose(_:)), keyEquivalent: "w")
    windowMenuItem.submenu = windowMenu

    return mainMenu
}

let application = NSApplication.shared
application.setActivationPolicy(.regular)
application.mainMenu = makeMainMenu()

let delegate = AppDelegate()
application.delegate = delegate
application.run()

#endif
