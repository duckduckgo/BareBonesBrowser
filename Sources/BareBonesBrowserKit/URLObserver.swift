//
//  URLObserver.swift
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

import Foundation
import WebKit

class URLObserver: NSObject {

    typealias ChangesHandler = (String) -> Void
    private var changesHandler:  ChangesHandler?

    func observeURLChanges(handler: @escaping ChangesHandler) {
        self.changesHandler = handler
    }

    open override func observeValue(forKeyPath keyPath: String?,
                                    of object: Any?,
                                    change: [NSKeyValueChangeKey: Any]?,
                                    context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath else { return }
        switch keyPath {
        case #keyPath(WKWebView.url):
            guard let webView = object as? WKWebView,
            let urlString = webView.url?.absoluteString else {
                return
            }
            changesHandler?(urlString)
        default: break
        }
    }
}
