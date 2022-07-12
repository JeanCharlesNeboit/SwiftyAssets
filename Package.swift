// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "SwiftyAssets",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(name: "SwiftyAssetsCLI", targets: ["SwiftyAssetsCLI"]),
        .library(name: "SwiftyAssets", targets: ["SwiftyAssets"]),
        .plugin(name: "GeneratePlugin", targets: ["GeneratePlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.0.0"),
        .package(url: "https://github.com/swiftcsv/SwiftCSV.git", exact: "0.5.5"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "3.0.0"),
        .package(url: "https://github.com/stencilproject/Stencil", from: "0.14.0"),
        .package(url: "git@github.com:JeanCharlesNeboit/SwiftyKit.git", branch: "main")
    ],
    targets: [
        .target(
            name: "SwiftyAssets",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "SwiftCSV",
                "Yams",
                "Stencil",
                "SwiftyKit"
            ]
        ),
        .executableTarget(
            name: "SwiftyAssetsCLI",
            dependencies: ["SwiftyAssets"]
        ),
        .plugin(
            name: "GeneratePlugin",
            capability: .buildTool(),
            dependencies: ["SwiftyAssetsCLI"]
        ),
        .testTarget(
            name: "SwiftyAssetsTests",
            dependencies: ["SwiftyAssets"]
        )
    ]
)
