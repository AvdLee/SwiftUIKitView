// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUIKitView",
    platforms: [
        .iOS(.v14),
        .macOS(.v10_15),
        .tvOS(.v14),
        .watchOS(.v6)
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
