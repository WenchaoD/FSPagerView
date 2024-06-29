// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "FSPagerView",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "FSPagerView", targets: ["FSPagerView"]),
    ],
    targets: [
        .target(name: "FSPagerView", path: "Sources", exclude: ["FSPagerViewObjcCompat.h", "FSPagerViewObjcCompat.m"]),
    ],
    swiftLanguageVersions: [.version("5.0")]
)
