// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "SwiftEmail",
  defaultLocalization: "en",
  platforms: [
    .macOS(.v15)
  ],
  products: [
    .library(name: "SwiftEmail", targets: ["SwiftEmail"]),
    .library(name: "SwiftEmailTesting", targets: ["SwiftEmailTesting"]),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.17.7"),
    .package(url: "https://github.com/apple/swift-crypto.git", from: "3.0.0"),
    .package(url: "https://github.com/apple/swift-log.git", from: "1.4.0"),
  ],
  targets: [
    .target(
      name: "SwiftEmail",
      dependencies: [
        .product(name: "Crypto", package: "swift-crypto"),
        .product(name: "Logging", package: "swift-log"),
      ]),
    .target(
      name: "SwiftEmailTesting",
      dependencies: [
        "SwiftEmail",
        .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
      ]),
    .testTarget(
      name: "SwiftEmailTests",
      dependencies: [
        "SwiftEmail",
        "SwiftEmailTesting",
        .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
      ],
      exclude: [
        "__Snapshots__/"
      ],
      resources: [
        .process("Resources/")
      ]
    ),
  ]
)
