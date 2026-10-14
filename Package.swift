// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "uInterfaceSDK",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "uInterfaceSDK",
            targets: ["uInterfaceSDK", "uInterfaceSDKDependencies"]
        )
    ],
    dependencies: [
        // Links against uinterface-native-ios-public (1.0.1)
        .package(url: "https://github.com/upaymentskwt/uinterface-native-ios-public.git", from: "1.0.1")
    ],
    targets: [
        .binaryTarget(
            name: "uInterfaceSDK",
            url: "https://github.com/upaymentskwt/uInterface-iOS/releases/download/2.0.0/uInterfaceSDK.xcframework.zip",
            checksum: "0dc212bedca39d853750761049a68802796768050de7c4818e4f1cd18a0d806f"
        ),
        // Stub to carry the transitive uInterfaceNative dependency
        .target(
            name: "uInterfaceSDKDependencies",
            dependencies: [
                .product(name: "uInterfaceNative", package: "uinterface-native-ios-public")
            ],
            path: "Sources/uInterfaceSDKDependencies"
        )
    ]
)
