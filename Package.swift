// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "SpotHeroEmailValidator",
    products: [
        .library(name: "SpotHeroEmailValidator", targets: ["SpotHeroEmailValidator"]),
    ],
    targets: [
        .target(
            name: "SpotHeroEmailValidator",
            dependencies: []
        ),
        .testTarget(
            name: "SpotHeroEmailValidatorTests",
            dependencies: [
                .target(name: "SpotHeroEmailValidator"),
            ]
        ),
    ]
)
