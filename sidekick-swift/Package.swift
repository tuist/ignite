// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "sidekick-swift",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "sidekick-swift",
            targets: ["sidekick-swift"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.6.1")
    ],
    targets: [
        .executableTarget(
            name: "sidekick-swift",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ],
            path: "Sources/sidekick-swift"
        )
    ]
)
