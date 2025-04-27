// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Pokespeare",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(
            name: "Pokespeare",
            targets: ["Pokespeare"]
        ),
    ],
    targets: [
        .target(
            name: "Pokespeare",
            resources: [
                .process("Resources/Media.xcassets")
            ]
        ),
        .testTarget(
            name: "PokespeareTests",
            dependencies: ["Pokespeare"]
        ),
    ]
)
