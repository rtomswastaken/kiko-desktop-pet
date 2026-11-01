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
        ),
        .executable(
            name: "KikoTestRunner",
            targets: ["KikoTestRunner"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "KikoCore",
            dependencies: [],
            path: "Sources/KikoCore"
        ),
        .executableTarget(
            name: "Kiko",
            dependencies: ["KikoCore"],
            path: "Sources/Kiko"
        ),
        .executableTarget(
            name: "KikoTestRunner",
            dependencies: ["KikoCore"],
            path: "Tests"
        )
    ]
)
