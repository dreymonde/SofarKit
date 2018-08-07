// swift-tools-version:4.0
// Managed by ice

import PackageDescription

let package = Package(
    name: "SofarKit",
    products: [
        .library(name: "SofarKit", targets: ["SofarKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/scinfu/SwiftSoup", from: "1.7.2"),
        .package(url: "https://github.com/onevcat/Rainbow", from: "3.1.4"),
        .package(url: "https://github.com/scottrhoyt/SwiftyTextTable", from: "0.8.0"),
        .package(url: "https://github.com/dreymonde/Light", from: "0.0.3"),
    ],
    targets: [
        .target(name: "SofarKit", dependencies: ["SwiftSoup", "Rainbow", "SwiftyTextTable"]),
        .testTarget(name: "SofarKitTests", dependencies: ["SofarKit", "SofarManager", "Light"]),
        .target(name: "SofarManager", dependencies: ["Light", "SofarKit"]),
    ]
)
