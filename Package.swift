// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "SwiftKeychainWrapper",
    products: [
        .library(
            name: "SwiftKeychainWrapper",
            targets: ["SwiftKeychainWrapper"]
        )
    ],
    targets: [
        .target(
            name: "SwiftKeychainWrapper",
            path: "SwiftKeychainWrapper"
        )
    ],
    swiftLanguageVersions: [.v5]
)
