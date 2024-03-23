// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "FSPagerView",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(name: "FSPagerView", targets: ["FSPagerView"]),
    ],
    targets: [
        .target(name: "FSPagerView", path: "Sources", exclude: ["FSPagerViewObjcCompat.h", "FSPagerViewObjcCompat.m"]),
    ],
    swiftLanguageVersions: [.v5]
)
