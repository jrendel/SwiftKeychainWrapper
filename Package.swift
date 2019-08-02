// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "SwiftKeychainWrapper",
    platforms: [
        .iOS(.v8),
    ],
    products: [
        .library(
            name: "SwiftKeychainWrapper",
            targets: ["SwiftKeychainWrapper"]),
    ],
    targets: [
        .target(
            name: "SwiftKeychainWrapper",
            dependencies: [],
            path: ".",
            sources: ["SwiftKeychainWrapper"]),
        .testTarget(
            name: "SwiftKeychainWrapperTests",
            dependencies: ["SwiftKeychainWrapper"]),
    ]
)
