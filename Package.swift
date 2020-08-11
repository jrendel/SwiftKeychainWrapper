// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "SwiftKeychainWrapper",
    products: [
        .library(
            name: "SwiftKeychainWrapper",
            targets: ["SwiftKeychainWrapper"]),
    ],
    targets: [
        .target(
            name: "SwiftKeychainWrapper",
            dependencies: []),
    ]
)
