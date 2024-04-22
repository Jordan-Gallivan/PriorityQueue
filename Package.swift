// swift-tools-version: 5.9
//  Created by Jordan Gallivan on 9/27/23.


import PackageDescription

let package = Package(
    name: "PriorityQueue",
    products: [
        .library(
            name: "PriorityQueue",
            targets: ["PriorityQueue"]),
    ],
    targets: [
        .target(
            name: "PriorityQueue"),
        .testTarget(
            name: "PriorityQueueTests",
            dependencies: ["PriorityQueue"]),
    ]
)
