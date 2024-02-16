# BareBonesBrowser

SwiftUI Universal browser for testing and triaging purposes. The main project is a minimalistic browser ([feature list](https://app.asana.com/0/0/1206524485561895/f))

Minimum os requirements:
- iOS 16
- macOS 14

## BareBonesBrowserKit
The core code is available as a Swift Package

Minimum os requirements:
- iOS 14
- macOS 11

### AppKit Usage
```
@objc func openVanillaBrowser(_ sender: Any?) {
	openVanillaBrowser(url: URL(string: "https://duckduckgo.com/")!)
}

private func openVanillaBrowser(url: URL) {
	let myView = NSHostingView(rootView: BareBonesBrowserView(initialURL: url, homeURL: url, uiDelegate: self))
	myView.translatesAutoresizingMaskIntoConstraints = false
	myView.widthAnchor.constraint(greaterThanOrEqualToConstant: 640).isActive = true
	myView.heightAnchor.constraint(greaterThanOrEqualToConstant: 480).isActive = true
	let viewController = NSViewController()
	viewController.view = myView
	let window = NSWindow(contentViewController: viewController)
	window.contentViewController = viewController
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