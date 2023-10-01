// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "BArray",
    products: [
        .library(
            name: "BArray",
            targets: ["BArray"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "BArray",
            dependencies: []),
        .testTarget(
            name: "BArrayTests",
            dependencies: ["BArray"]),
    ]
)
