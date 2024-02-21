# BareBonesBrowser

SwiftUI Universal browser for testing and triaging purposes. The main project is a minimalistic browser ([feature list](https://app.asana.com/0/0/1206524485561895/f))

Minimum os requirements:
- iOS 16
- macOS 14

#### Cookies and website data management
The app uses the same non-persistent `WKWebsiteDataStore` and `WKProcessPool` for all windows.

## BareBonesBrowserKit
The core code is available as a Swift Package

Minimum os requirements:
- iOS 14
- macOS 11

#### Cookies and website data management
The `WKWebViewConfiguration` is provided by the app, so the BareBonesBrowserKit is not in control of cookies or websites' data.

### AppKit Usage
```
static var webViewConfiguration: WKWebViewConfiguration = {
    let configuration = WKWebViewConfiguration()
    configuration.websiteDataStore = WKWebsiteDataStore.nonPersistent()
    configuration.processPool = WKProcessPool()
    return configuration
}()

@objc func openVanillaBrowser(_ sender: Any?) {
	openVanillaBrowser(url: URL(string: "https://duckduckgo.com/")!)
}

private func openVanillaBrowser(url: URL) {
	        let myView = NSHostingView(rootView: BareBonesBrowserView(initialURL: url,
                                                                  homeURL: url,
                                                                  uiDelegate: self,
                                                                  configuration: Self.webViewConfiguration,
                                                                  userAgent: "Your UA"))
	myView.translatesAutoresizingMaskIntoConstraints = false
	myView.widthAnchor.constraint(greaterThanOrEqualToConstant: 640).isActive = true
	myView.heightAnchor.constraint(greaterThanOrEqualToConstant: 480).isActive = true
	let viewController = NSViewController()
	viewController.view = myView
	let window = NSWindow(contentViewController: viewController)
	window.center()
	let wc = NSWindowController(window: window)
	wc.showWindow(nil)
}

func browserDidRequestNewWindow(urlRequest: URLRequest) {
	if let url = urlRequest.url {
		openVanillaBrowser(url: url)
	}
}
```
