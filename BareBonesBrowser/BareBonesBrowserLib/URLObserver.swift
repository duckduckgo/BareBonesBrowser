//
//  URLObserver.swift
//  BareBonesBrowser
//
//  Created by Federico Cappelli on 06/02/2024.
//

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
