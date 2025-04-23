// swift-tools-version: 6.1

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
            name: "Pokespeare"),
        .testTarget(
            name: "PokespeareTests",
            dependencies: ["Pokespeare"]
        ),
    ]
)
