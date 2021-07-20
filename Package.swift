// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUIKitView",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "SwiftUIKitView",
            targets: ["SwiftUIKitView"]),
    ],
    targets: [
        .target(
            name: "SwiftUIKitView",
            dependencies: []),
        .testTarget(
            name: "SwiftUIKitViewTests",
            dependencies: ["SwiftUIKitView"]),
    ]
)
