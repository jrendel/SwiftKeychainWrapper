// swift-tools-version:4.1

import PackageDescription

let package = Package(
    name: "SwiftKeychainWrapper",
    products: [
        .library(name: "SwiftKeychainWrapper", targets: ["SwiftKeychainWrapper"])
    ],
    targets: [
        .target(name: "SwiftKeychainWrapper", path: "SwiftKeychainWrapper"),
        .testTarget(name: "SwiftKeychainWrapperTests", dependencies: ["SwiftKeychainWrapper"], path: "SwiftKeychainWrapperTests")
    ]
)
