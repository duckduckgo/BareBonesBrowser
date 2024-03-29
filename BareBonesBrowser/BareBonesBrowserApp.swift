//
//  BareBonesBrowserApp.swift
//  BareBonesBrowser
//
//  Created by Federico Cappelli on 06/02/2024.
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

import SwiftUI
import WebKit

enum UserAgent: String {
    case macOS = "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_3) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.2 Safari/605.1.15"
    case iOS = "Mozilla/5.0 (iPhone; CPU iPhone OS 17_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.2 Mobile/15E148 Safari/604."
}

@main
struct BareBonesBrowserApp: App {
    @Environment(\.openWindow) private var openWindow
    let homeURL = URL(string: "https://duckduckgo.com")!

    static var webViewConfiguration: WKWebViewConfiguration = {
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        configuration.processPool = WKProcessPool() //Need to reuse the same process pool to achieve cross-window cookie sharing
        return configuration
    }()

#if os(macOS)
    var body: some Scene {
        WindowGroup("Bare Bones Browser", for: URL.self) { $url in
            BareBonesBrowserView(initialURL: homeURL, 
                                 homeURL: homeURL,
                                 uiDelegate: self,
                                 configuration: Self.webViewConfiguration,
                                 userAgent: UserAgent.macOS.rawValue)
                .frame(minWidth: 640, maxWidth: .infinity, minHeight: 480, maxHeight: .infinity)
        }//.windowResizability(.contentSize)
    }
#else
    var body: some Scene {
        WindowGroup("Bare Bones Browser", for: URL.self) { $url in
            BareBonesBrowserView(initialURL: url ?? homeURL,
                                 homeURL: homeURL,
                                 configuration: Self.webViewConfiguration,
                                 userAgent: UserAgent.iOS.rawValue)
        }
    }
#endif
}

#if os(macOS)
extension BareBonesBrowserApp: BareBonesBrowserUIDelegate {
    
    @MainActor func browserDidRequestNewWindow(urlRequest: URLRequest) {
        guard let url = urlRequest.url else {
            return
        }
        openWindow(value: url)
    }
}
#endif
