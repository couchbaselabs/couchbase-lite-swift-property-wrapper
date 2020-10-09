// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CouchbaseLiteSwiftPropertyWrapper",
    platforms: [
        .iOS(.v9), .macOS(.v10_11)
    ],
    products: [
        .library(
            name: "CouchbaseLiteSwiftPropertyWrapper",
            targets: ["CouchbaseLiteSwiftPropertyWrapper"]),
    ],
    dependencies: [
        .package(
            path: "./Libs/CouchbaseLiteSwift")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "CouchbaseLiteSwiftPropertyWrapper",
            dependencies: ["CouchbaseLiteSwift"]),
        .testTarget(
            name: "CouchbaseLiteSwiftPropertyWrapperTests",
            dependencies: ["CouchbaseLiteSwiftPropertyWrapper", "CouchbaseLiteSwift"]),
    ]
)
