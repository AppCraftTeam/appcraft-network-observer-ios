// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ACNetworkObserver",
    platforms: [.iOS(.v13), .watchOS(.v5)],
    products: [
        .library(
            name: "ACNetworkObserver",
            targets: ["ACNetworkObserver"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ACNetworkObserver",
            dependencies: []),
        .testTarget(
            name: "ACNetworkObserverTests",
            dependencies: ["ACNetworkObserver"]),
    ]
)
