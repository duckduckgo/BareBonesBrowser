//
//  WebView.swift
//  BareBonesBrowser
//
//  Created by Federico Cappelli on 06/02/2024.
//

import Foundation
import WebKit
import SwiftUI

public protocol WebViewUIDelegate {

    func webViewRequestNewWindow(with webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView?
}

public struct WebView {

    public typealias View = WKWebView
    public var uiDelegate: WebViewUIDelegate?

//    private let url: URL
    let wkWebView: View

    public init() {
//        self.url = url
        self.wkWebView = View()
        self.wkWebView.allowsBackForwardNavigationGestures = true
    }

    func updateView(_ view: View) {
//        let req = URLRequest(url: url)
//        view.load(req)
    }

    public func load(url: URL) {
        DispatchQueue.main.async {
            let req = URLRequest(url: url)
            wkWebView.load(req)
        }
    }

    public func load(_ urlRequest: URLRequest) {
        DispatchQueue.main.async {
            wkWebView.load(urlRequest)
        }
    }

    func goBack() -> Void {
        wkWebView.goBack()
    }

    func goForward() {
        wkWebView.goForward()
    }

    @MainActor func reloadFromOrigin() {
        wkWebView.reloadFromOrigin()
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
                let newWebView = parent.uiDelegate?.webViewRequestNewWindow(with: webView, createWebViewWith: configuration, for: navigationAction, windowFeatures: windowFeatures)
                return newWebView
            }
            return nil
        }
    }
}

#if os(macOS)
extension WebView: NSViewRepresentable {
    
    public func makeNSView(context: Context) -> View {
        wkWebView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_3) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.2 Safari/605.1.15"
        wkWebView.isInspectable = true
        wkWebView.navigationDelegate = context.coordinator
        wkWebView.uiDelegate = context.coordinator
        return wkWebView
    }

    public func updateNSView(_ nsView: View, context: Context) {
        updateView(nsView)
    }
}
#elseif os(iOS)
extension WebView: UIViewRepresentable {
    
    public func makeUIView(context: Context) -> View {
        wkWebView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 17_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.2 Mobile/15E148 Safari/604."
        wkWebView.navigationDelegate = context.coordinator
        wkWebView.uiDelegate = context.coordinator
        return wkWebView
    }

    public func updateUIView(_ uiView: View, context: Context) {
        updateView(uiView)
    }
}
#endif
