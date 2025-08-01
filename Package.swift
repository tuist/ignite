// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ignite-swift",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "ignite-swift",
            targets: ["ignite-swift"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0")
    ],
    targets: [
        .executableTarget(
            name: "ignite-swift",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ],
            path: "swift/Sources/ignite-swift"
        )
    ]
)
