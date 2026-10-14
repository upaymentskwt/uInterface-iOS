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
            url: "https://github.com/upaymentskwt/uInterface-iOS/releases/download/2.0.1/uInterfaceSDK.xcframework.zip",
            checksum: "4fa42ac5425120b1a3b4da6ee9daf1fdb4b4b67e775176a8ea9ee3f40fd0f7dd"
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
