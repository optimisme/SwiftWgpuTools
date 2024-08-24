// swift-tools-version: 5.10
import PackageDescription

#if os(macOS)
let wgpuPath = "Sources/Libs/Wgpu/wgpu-macos-aarch64-release"
#elseif os(Linux)
let wgpuPath = "Sources/Libs/Wgpu/wgpu-linux-x86_64-release"
let vulkanPath = "Sources/Libs/Vulkan/Linux"
#endif

var dependencies: [Target.Dependency] = ["Wgpu"]
var linkedLibraries: [LinkerSetting] = []

var swiftSettings: [SwiftSetting] = []
var linkerSettings: [LinkerSetting] = []

#if os(macOS)
swiftSettings.append(.unsafeFlags(["-I" + wgpuPath]))
linkerSettings.append(contentsOf: [
    .unsafeFlags(["-L/opt/homebrew/lib"]),
    .unsafeFlags(["-L" + wgpuPath]),
    .unsafeFlags(["-Xlinker", "-rpath", "-Xlinker", wgpuPath])
])
#endif

#if os(Linux)
swiftSettings.append(.unsafeFlags(["-I/usr/include/vulkan"]))
swiftSettings.append(.unsafeFlags(["-I" + wgpuPath]))
linkerSettings.append(contentsOf: [
    .unsafeFlags(["-L/usr/lib"]),
    .unsafeFlags(["-L/usr/lib/x86_64-linux-gnu"]),
    .unsafeFlags(["-L" + wgpuPath]),
    .unsafeFlags(["-Xlinker", "-rpath", "-Xlinker", wgpuPath])
])
dependencies.append("Vulkan")
dependencies.append("X11")
linkedLibraries.append(.linkedLibrary("vulkan"))
linkedLibraries.append(.linkedLibrary("X11"))
#endif

// Define the targets array
let targets: [Target] = [
    .target(
        name: "SwiftWgpuTools",
        path: wgpuPath,
        cSettings: [
            .headerSearchPath(wgpuPath),
            .define("USE_WGPU")
        ],
        linkerSettings: [
            .linkedLibrary("wgpu_native") // Linka amb la llibreria
        ]
    )
]

// Conditionally add Vulkan target for Linux
#if os(Linux)
let vulkanTarget = Target.systemLibrary(
    name: "Vulkan",
    path: vulkanPath!,
    pkgConfig: "vulkan",
    providers: [
        .apt(["libvulkan-dev", "libvulkan1"])
    ]
)
let x11Target = Target.systemLibrary(
    name: "X11",
    path: "Sources/Libs/X11/Linux",
    pkgConfig: "x11",
    providers: [
        .apt(["libx11-dev"])
    ]
)
let finalTargets = targets + [vulkanTarget, x11Target]
#else
let finalTargets = targets
#endif

let package = Package(
    name: "SwiftWgpuTools",
    products: [
        .library(
            name: "SwiftWgpuTools",
            targets: ["SwiftWgpuTools"]
        )
    ],
    dependencies: [],
    targets: finalTargets
)
