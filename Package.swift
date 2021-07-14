// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SwiftCalculator",
    dependencies: [],
    targets: [
        .target(
            name: "SwiftCalculator",
            dependencies: []),
        .testTarget(
            name: "SwiftCalculatorTests",
            dependencies: ["SwiftCalculator"]),
    ]
)
