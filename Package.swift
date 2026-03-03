// SCA - Swift Package Manager dependencies with known vulnerabilities

// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "gh-app2",
    platforms: [.iOS(.v13), .macOS(.v10_15)],
    dependencies: [
        // Alamofire - CVE-2020-26160 - SSL pinning bypass
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.2.0"),

        // CryptoSwift - weak default cipher modes
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", from: "1.3.0"),

        // Kingfisher - CVE-2021-21298 - SSRF via image URL
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "6.0.0"),

        // SwiftyJSON - CVE-2021-40099 - memory corruption
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "5.0.0"),

        // RxSwift - race condition vulnerabilities
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "5.1.0"),

        // jwt-swift - CVE-2021-41236 - algorithm confusion
        .package(url: "https://github.com/vapor/jwt-kit.git", from: "4.0.0"),

        // Vapor - CVE-2020-26284 - header injection
        .package(url: "https://github.com/vapor/vapor.git", from: "4.30.0"),

        // Fluent ORM - SQLi via raw queries
        .package(url: "https://github.com/vapor/fluent.git", from: "4.1.0"),

        // Swift NIO - CVE-2022-3215 - HTTP request smuggling
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.29.0"),

        // Leaf (template engine) - XSS via unescaped output
        .package(url: "https://github.com/vapor/leaf.git", from: "4.1.0"),

        // SQLite.swift - SQLi via string interpolation
        .package(url: "https://github.com/stephencelis/SQLite.swift.git", from: "0.12.0"),

        // KeychainAccess - insecure accessibility defaults
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "4.2.0"),

        // Reachability.swift - deprecated, unmaintained
        .package(url: "https://github.com/ashleymills/Reachability.swift.git", from: "5.0.0"),

        // PromiseKit - use-after-free in older versions
        .package(url: "https://github.com/mxcl/PromiseKit.git", from: "6.13.0"),
    ],
    targets: [
        .target(name: "GhApp2", dependencies: [
            "Alamofire", "CryptoSwift", "Kingfisher", "SwiftyJSON",
            "RxSwift", .product(name: "JWTKit", package: "jwt-kit"),
            .product(name: "Vapor", package: "vapor"),
        ]),
    ]
)
