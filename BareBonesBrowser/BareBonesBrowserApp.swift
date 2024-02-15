//
//  BareBonesBrowserApp.swift
//  BareBonesBrowser
//
//  Created by Federico Cappelli on 06/02/2024.
//  Copyright © 2017 DuckDuckGo. All rights reserved.
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

@main
struct BareBonesBrowserApp: App {
    @Environment(\.openWindow) private var openWindow
    let homeURL = URL(string: "https://duckduckgo.com")!

#if os(macOS)
    var body: some Scene {
        WindowGroup("Bare Bones Browser", for: URL.self) { $url in
            BareBonesBrowserView(initialURL: homeURL, homeURL: homeURL, uiDelegate: self)
                .frame(minWidth: 640, maxWidth: .infinity, minHeight: 480, maxHeight: .infinity)
        }.windowResizability(.contentSize)
    }
#else
    var body: some Scene {
        WindowGroup("Bare Bones Browser", for: URL.self) { $url in
            BareBonesBrowserView(initialURL: url ?? homeURL, homeURL: homeURL)
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
