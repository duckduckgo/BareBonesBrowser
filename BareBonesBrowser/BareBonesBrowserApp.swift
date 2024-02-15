//
//  BareBonesBrowserApp.swift
//  BareBonesBrowser
//
//  Created by Federico Cappelli on 06/02/2024.
//

import SwiftUI

@main
struct BareBonesBrowserApp: App {
    @Environment(\.openWindow) private var openWindow
    @Environment(\.supportsMultipleWindows) var supportsMultipleWindows
    let homeURL = URL(string: "https://duckduckgo.com")!

#if os(macOS)
    var body: some Scene {
        WindowGroup("Bare Bones Browser", for: URL.self) { $url in
            BareBonesBrowserView(initialURL: url ?? homeURL, homeURL: homeURL, uiDelegate: self)
                .frame(minWidth: 640, maxWidth: .infinity, minHeight: 480, maxHeight: .infinity)
        }.windowResizability(.contentSize)
    }
#else
    var body: some Scene {
        WindowGroup("Bare Bones Browser", for: URL.self) { $url in
            BareBonesBrowserView(initialURL: url ?? homeURL, homeURL: homeURL, uiDelegate: supportsMultipleWindows ? self : nil)
        }
    }
#endif
}

extension BareBonesBrowserApp: BareBonesBrowserUIDelegate {
    
    @MainActor func browserDidRequestNewWindow(urlRequest: URLRequest) {
        guard let url = urlRequest.url else {
            return
        }
        openWindow(value: url)
    }
}
