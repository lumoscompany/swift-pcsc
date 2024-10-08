// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-pcsc",
    platforms: [
        .macOS("13.3"),
    ],
    products: [
        .library(name: "PCSCKit", targets: ["PCSCKit"]),
        .library(name: "PCSC", targets: ["PCSC"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-log",
            .upToNextMajor(from: "1.6.1")
        ),
        .package(
            url: "https://github.com/lumoscompany/swift-essentials.git",
            .upToNextMajor(from: "0.0.17")
        ),
        .package(
            url: "https://github.com/lumoscompany/swift-essentials-nfc.git",
            .upToNextMajor(from: "0.0.2")
        ),
    ],
    targets: [
        .target(
            name: "PCSCKit",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                .product(name: "Essentials", package: "swift-essentials"),
                .product(name: "EssentialsNFC", package: "swift-essentials-nfc"),
                .byName(name: "PCSC", condition: .when(platforms: [.macOS, .linux])),
            ],
            path: "Sources/PCSCKit"
        ),
        .target(
            name: "PCSC",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                .product(name: "Essentials", package: "swift-essentials"),
                .byName(name: "Clibpcsclite", condition: .when(platforms: [.macOS, .linux])),
            ],
            path: "Sources/PCSC"
        ),
        .target(
            name: "Clibpcsclite",
            dependencies: [
                .byNameItem(name: "libpcsclite_macos", condition: .when(platforms: [.macOS])),
                .byNameItem(name: "libpcsclite_linux", condition: .when(platforms: [.linux])),
            ],
            path: "Sources/Clibpcsclite"
        ),
        .target(
            name: "libpcsclite_macos",
            dependencies: [],
            path: "Sources/libpcsclite_macos",
            linkerSettings: [
                .linkedFramework("PCSC", .when(platforms: [.macOS])),
            ]
        ),
        .target(
            name: "libpcsclite_linux",
            dependencies: [],
            path: "Sources/libpcsclite_linux",
            linkerSettings: [
                .linkedLibrary("pcsclite", .when(platforms: [.linux])),
            ]
        ),
    ]
)
