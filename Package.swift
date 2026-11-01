// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Kiko",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "Kiko",
            targets: ["Kiko"]
        )
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "Kiko",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "KikoTests",
            dependencies: ["Kiko"],
            path: "Tests"
        )
    ]
)
