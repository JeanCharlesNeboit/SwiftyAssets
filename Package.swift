// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyAssets",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(name: "SwiftyAssetsCLI", targets: ["SwiftyAssetsCLI"]),
        .library(name: "SwiftyAssets", targets: ["SwiftyAssets"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/apple/swift-tools-support-core.git", from: "0.1.10"),
        .package(url: "https://github.com/swiftcsv/SwiftCSV.git", from: "0.5.5"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "3.0.0"),
        .package(url: "https://github.com/stencilproject/Stencil", from: "0.14.0"),
        .package(url: "git@github.com:JeanCharlesNeboit/SwiftyKit.git", .revision("c3cb0b1"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "SwiftyAssets",
            dependencies: [
                "SwiftToolsSupport-auto",
                "SwiftCSV",
                "Yams",
                "Stencil",
                "SwiftyKit"
            ]
        ),
        .target(
            name: "SwiftyAssetsCLI",
            dependencies: ["SwiftyAssets"]
        ),
        .testTarget(
            name: "SwiftyAssetsTests",
            dependencies: ["SwiftyAssets"]
        )
    ]
)
