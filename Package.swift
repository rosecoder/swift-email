// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "SwiftEmail",
    platforms: [
       .macOS("12.0"),
    ],
    products: [
        .library(name: "SwiftEmail", targets: ["SwiftEmail"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.16.0"),
        .package(url: "https://github.com/apple/swift-crypto.git", from: "3.0.0"),
    ],
    targets: [
        .target(name: "SwiftEmail", dependencies: [
            .product(name: "Crypto", package: "swift-crypto"),
        ]),
        .target(name: "SwiftEmailTesting", dependencies: [
            "SwiftEmail",
            .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
        ]),
        .testTarget(name: "SwiftEmailTests", dependencies: [
            "SwiftEmail",
            "SwiftEmailTesting",
            .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
        ]),
    ]
)
