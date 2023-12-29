// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AExampleLibrary",
    platforms: [
      .iOS(.v16)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AExampleLibrary",
            targets: ["AExampleLibrary"]),
    ],
    dependencies: [
//      .package(url: "https://github.com/pointfreeco/swift-composable-architecture", branch: "observable-beta"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AExampleLibrary",
            dependencies: [
//                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .testTarget(
            name: "AExampleLibraryTests",
            dependencies: ["AExampleLibrary"]),
    ]
)
