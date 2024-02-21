//
//  WebView.swift
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
import SwiftUI

public protocol WebViewUIDelegate {

    func webDidViewRequestNewWindow(with webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView?
}

public struct WebView {

    public typealias View = WKWebView
    let wkWebView: View

    public var webViewUIDelegate: WebViewUIDelegate?

    public init(configuration: WKWebViewConfiguration) {
        self.wkWebView = View(frame: .zero, configuration: configuration)
        self.wkWebView.allowsBackForwardNavigationGestures = true
    }

    func updateView(_ view: View) {
        wkWebView.reload()
    }

    public func load(url: URL) {
        let req = URLRequest(url: url)
        load(req)
    }

    public func load(_ urlRequest: URLRequest) {
        wkWebView.load(urlRequest)
    }

    func goBack() -> Void {
        wkWebView.goBack()
    }

    func goForward() {
        wkWebView.goForward()
    }

    func reload() {
        wkWebView.reload()
    }

}

//MARK: - Coordinator

extension WebView {

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        let parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }

        //MARK: - WKNavigationDelegate

        public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            print("Webview did commit navigation.")
        }

        public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            print("Webview started loading.")
        }

        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("Webview finished loading.")
        }

        public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("Webview failed with error: \(error.localizedDescription)")
        }

        public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print("Webview failed provisional navigation with error: \(error.localizedDescription)")
            webView.reload()
        }

        public func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
            print("Webview did receive redirect.")
        }

        //MARK: - WKUIDelegate

        public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {

            if navigationAction.targetFrame == nil {
                let newWebView = parent.webViewUIDelegate?.webDidViewRequestNewWindow(with: webView, createWebViewWith: configuration, for: navigationAction, windowFeatures: windowFeatures)
                return newWebView
            }
            return nil
        }
    }
}

#if os(macOS)
extension WebView: NSViewRepresentable {
    
    public func makeNSView(context: Context) -> View {
        if #available(macOS 13.3, *) {
            wkWebView.isInspectable = true
        }
        wkWebView.navigationDelegate = context.coordinator
        wkWebView.uiDelegate = context.coordinator
        return wkWebView
    }

    public func updateNSView(_ nsView: View, context: Context) {
        updateView(nsView)
    }
}
#else
extension WebView: UIViewRepresentable {
    
    public func makeUIView(context: Context) -> View {
        wkWebView.navigationDelegate = context.coordinator
        wkWebView.uiDelegate = context.coordinator
        return wkWebView
    }

    public func updateUIView(_ uiView: View, context: Context) {
        updateView(uiView)
    }
}
#endif
