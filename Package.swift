// swift-tools-version:5.0
//
//  Package.swift
//

import PackageDescription

let package = Package(
    name: "SwiftKeychainWrapper",
    platforms: [
        // .macOS(.v10_12),
        .iOS(.v8),
        // .tvOS(.v10),
        // .watchOS(.v3)
    ],
    products: [
        .library(
            name: "SwiftKeychainWrapper",
            targets: ["SwiftKeychainWrapper"])
    ],
    targets: [
        .target(
            name: "SwiftKeychainWrapper",
            path: "SwiftKeychainWrapper")
    ],
    swiftLanguageVersions: [.v5]
)

