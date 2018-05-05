// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PennyDiscord",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/loganwright/Sword", from: "0.9.1"),
    ],
    targets: [
        .target(
            name: "PennyDiscord",
            dependencies: ["Sword"]
        ),
    ]
)
