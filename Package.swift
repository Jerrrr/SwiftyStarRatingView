// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "SwiftyStarRatingView",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "SwiftyStarRatingView",
            targets: ["SwiftyStarRatingView"]
        )
    ],
    targets: [
        .target(
            name: "SwiftyStarRatingView",
            path: "Source"
        )
    ],
    swiftLanguageVersions: [.v5]
)
