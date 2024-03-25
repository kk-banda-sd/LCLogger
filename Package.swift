// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LCLogger",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v12),
        .watchOS(.v9)
    ],
    products: [
        .library(
            name: "LCLogger",
            targets: ["LCLogger"]
        )
    ],
    targets: [
        .target(
            name: "LCLogger"
        )
    ]
)
