// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GitStrip",
    products: [
        .executable(name: "git-strip", targets: ["GitStrip"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.0.3")
    ],
    targets: [
        .executableTarget(
            name: "GitStrip",
            dependencies: [.product(name: "ArgumentParser", package: "swift-argument-parser")]),
        .testTarget(
            name: "GitStripTests",
            dependencies: ["GitStrip"]),
    ]
)
