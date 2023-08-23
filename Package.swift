// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Arduino",
    products: [
        .library(
            name: "Arduino",
            targets: ["Arduino"]),
    ],
    targets: [
        .target(
            name: "Arduino",
            path: "microswift",
            sources: ["main.swift"]),
    ]
)
