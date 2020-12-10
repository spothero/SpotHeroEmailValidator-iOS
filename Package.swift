// swift-tools-version:5.3

//  Copyright © 2020 SpotHero, Inc. All rights reserved.

import PackageDescription

let package = Package(
    name: "SpotHeroEmailValidator",
    platforms: [
        .iOS(.v9),          // minimum supported version via SPM
        .macOS(.v10_10),    // minimum supported version via SPM
        .tvOS(.v9),         // minimum supported version via SPM
        // watchOS is unsupported
    ],
    products: [
        .library(name: "SpotHeroEmailValidator", targets: ["SpotHeroEmailValidator"]),
    ],
    targets: [
        .target(
            name: "SpotHeroEmailValidator",
            dependencies: [],
            resources: [
                .copy("Data/DomainData.plist"),
            ]
        ),
        .testTarget(
            name: "SpotHeroEmailValidatorTests",
            dependencies: [
                .target(name: "SpotHeroEmailValidator"),
            ]
        ),
    ]
)
