// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "TesoroSDK",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "TesoroSDK",
            targets: ["TesoroSDK"]
        ),
    ],
    targets: [
        .target(
            name: "TesoroSDK",
            dependencies: [],
            path: "Sources/TesoroSDK"
        ),
        .testTarget(
            name: "TesoroSDKTests",
            dependencies: ["TesoroSDK"],
            path: "Tests/TesoroSDKTests"
        ),
    ]
)
