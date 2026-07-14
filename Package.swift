// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BareBonesBrowserKit",
    platforms: [
        .macOS(.v11),
        .iOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "BareBonesBrowserKit",
            targets: ["BareBonesBrowserKit"]
        ),
        // A tiny macOS app that opens BareBonesBrowserView, runnable via `swift run`.
        .executable(
            name: "BareBonesBrowserApp",
            targets: ["BareBonesBrowserApp"]
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "BareBonesBrowserKit"
        ),
        .executableTarget(
            name: "BareBonesBrowserApp",
            dependencies: ["BareBonesBrowserKit"]
        )
    ]
)
