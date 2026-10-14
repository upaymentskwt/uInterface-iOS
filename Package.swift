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
        // uInterfaceSDK links against uInterfaceNative at build time.
        .package(url: "https://github.com/upaymentskwt/uinterface-native-ios-public.git", from: "1.0.1")
    ],
    targets: [
        .binaryTarget(
            name: "uInterfaceSDK",
            path: "uInterfaceSDK.xcframework"
        ),
        // Binary targets cannot declare dependencies, so this stub carries
        // the uInterfaceNative dependency into the product.
        .target(
            name: "uInterfaceSDKDependencies",
            dependencies: [
                .product(name: "uInterfaceNative", package: "uinterface-native-ios-public")
            ],
            path: "Sources/uInterfaceSDKDependencies"
        )
    ]
)
