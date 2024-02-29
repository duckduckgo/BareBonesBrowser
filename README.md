# BareBonesBrowser

## We are hiring!

DuckDuckGo is growing fast and we continue to expand our fully distributed team. We embrace diverse perspectives, and seek out passionate, self-motivated people, committed to our shared vision of raising the standard of trust online. If you are a senior software engineer capable in either iOS or Android, visit our [careers](https://duckduckgo.com/hiring/#open) page to find out more about our openings!

## What is it?

The BareBonesBrowser is a SwiftUI vanilla browser for testing and triaging purposes.

#### Minimum requirements:
- iOS 16
- macOS 14

#### Cookies and website data management
The app uses the same non-persistent `WKWebsiteDataStore` and `WKProcessPool` for all windows.

### BareBonesBrowserKit
The browser core code is available as a Swift Package

#### Minimum requirements:
- iOS 14
- macOS 11

#### Cookies and website data management
The `WKWebViewConfiguration` is provided by the app, so the BareBonesBrowserKit is not in control of cookies or websites' data.

### AppKit Example
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
	let browserView = NSHostingView(rootView: BareBonesBrowserView(initialURL: url,
                                                                      homeURL: url,
                                                                   uiDelegate: self,
                                                                configuration: Self.webViewConfiguration,
                                                                    userAgent: "Your UA"))
	browserView.translatesAutoresizingMaskIntoConstraints = false
	browserView.widthAnchor.constraint(greaterThanOrEqualToConstant: 640).isActive = true
	browserView.heightAnchor.constraint(greaterThanOrEqualToConstant: 480).isActive = true
	let viewController = NSViewController()
	viewController.view = browserView
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

### SwiftUI Example

See [BareBonesBrowserApp.swift](BareBonesBrowser/BareBonesBrowserApp.swift)

## Contribute

Please refer to [contributing](CONTRIBUTING.md).

## Discuss

Contact us at https://duckduckgo.com/feedback if you have feedback, questions or want to chat.

## License
DuckDuckGo is distributed under the Apache 2.0 [license](https://github.com/duckduckgo/ios/blob/master/LICENSE.md).
