// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "daemon-swift",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "daemon-swift",
            targets: ["daemon-swift"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.6.1"),
        .package(url: "https://github.com/apple/swift-testing", from: "0.99.0")
    ],
    targets: [
        .executableTarget(
            name: "daemon-swift",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ],
            path: "Sources/daemon-swift"
        ),
        .testTarget(
            name: "daemon-swift-tests",
            dependencies: [
                "daemon-swift",
                .product(name: "Testing", package: "swift-testing")
            ],
            path: "Tests/daemon-swift-tests"
        )
    ]
)
