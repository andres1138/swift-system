// swift-tools-version:5.8

/*
 This source file is part of the Swift System open source project

 Copyright (c) 2020-2024 Apple Inc. and the Swift System project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See https://swift.org/LICENSE.txt for license information
*/

import PackageDescription

let DarwinPlatforms: [Platform]
#if swift(<5.9)
DarwinPlatforms = [.macOS, .macCatalyst, .iOS, .watchOS, .tvOS]
#else
DarwinPlatforms = [.macOS, .macCatalyst, .iOS, .watchOS, .tvOS, .visionOS]
#endif

let package = Package(
    name: "swift-system",
    products: [
      .library(name: "SystemPackage", targets: ["SystemPackage"])
    ],
    dependencies: [
      .package(url: "https://github.com/apple/swift-atomics", from: "1.1.0")
    ],
    targets: [
      .target(
        name: "CSystem",
        dependencies: [],
        exclude: ["CMakeLists.txt"]),
      .target(
        name: "SystemPackage",
        dependencies: [
          "CSystem",
          .product(name: "Atomics", package: "swift-atomics")
        ],
        path: "Sources/System",
        exclude: ["CMakeLists.txt"],
        cSettings: [
          .define("_CRT_SECURE_NO_WARNINGS", .when(platforms: [.windows]))
        ],
        swiftSettings: [
          .define("SYSTEM_PACKAGE"),
          .define("SYSTEM_PACKAGE_DARWIN", .when(platforms: DarwinPlatforms)),
          .define("ENABLE_MOCKING", .when(configuration: .debug))
        ]),
      .testTarget(
        name: "SystemTests",
        dependencies: ["SystemPackage"],
        swiftSettings: [
          .define("SYSTEM_PACKAGE"),
          .define("SYSTEM_PACKAGE_DARWIN", .when(platforms: DarwinPlatforms)),
        ]),
    ]
)
