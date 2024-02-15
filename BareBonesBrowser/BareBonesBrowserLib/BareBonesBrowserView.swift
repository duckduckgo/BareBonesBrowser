//
//  BareBonesBrowserView.swift
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

import Foundation
import WebKit
import SwiftUI

public protocol BareBonesBrowserUIDelegate {

    func browserDidRequestNewWindow(urlRequest: URLRequest)
}

struct BareBonesBrowserView: View {

    private let homeURL: URL
    private let initialURL: URL
    private let urlObserver = URLObserver()
    private var webview: WebView = WebView()
    public var uiDelegate: BareBonesBrowserUIDelegate?

    @State private var addressText: String = ""

    public init(initialURL: URL, homeURL: URL, uiDelegate: BareBonesBrowserUIDelegate? = nil) {
        self.initialURL = initialURL
        self.homeURL = homeURL
        self.uiDelegate = uiDelegate
        self.webview.wkWebView.addObserver(urlObserver, forKeyPath: #keyPath(WKWebView.url), options: .new, context: nil)
        self.webview.webViewUIDelegate = self
    }

    var body: some View {
        VStack {
            HStack {
                Button(action: { webview.goBack() }) { Image(systemName: "arrowshape.backward") }
                Button(action: { webview.goForward() }) { Image(systemName: "arrowshape.forward") }
                Button(action: { webview.reload() }) { Image(systemName: "arrow.circlepath") }
                TextField("Exact address (including HTTP, WWW, ...)", text: $addressText).onSubmit {
                    guard addressText.isEmpty == false,
                          let finalURL = URL(string: addressText) else {
                        return
                    }
                    webview.load(url: finalURL)
                }
                .autocorrectionDisabled()
                Button(action: { webview.load(url: homeURL) }) { Image(systemName: "house") }
            }.padding(8)
            webview
        }.onAppear(perform: {
//            webview.webViewUIDelegate = self
            addressText = initialURL.absoluteString
            urlObserver.observeURLChanges { address in
                addressText = address
            }
            webview.load(url: initialURL)
        })
    }
}

//MARK: - WebViewUIDelegate

extension BareBonesBrowserView: WebViewUIDelegate {
    
    func webViewRequestNewWindow(with webView: WKWebView,
                                 createWebViewWith configuration: WKWebViewConfiguration,
                                 for navigationAction: WKNavigationAction,
                                 windowFeatures: WKWindowFeatures) -> WKWebView? {

        //This is an over-simplification, we just open a new app window instead than properly managing a multi-webview environmen
        if let delegate = uiDelegate {
            delegate.browserDidRequestNewWindow(urlRequest: navigationAction.request)
        } else {
            // If the platform doesn't implements the uiDelegate then we just load the request in the current webview
            self.webview.load(navigationAction.request)
        }
        return nil
    }
}

#Preview {
    let url = URL(string: "https://duckduckgo.com")!
    return BareBonesBrowserView(initialURL: url,homeURL: url, uiDelegate: nil)
}
