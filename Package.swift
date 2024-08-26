// swift-tools-version: 5.10
import PackageDescription

#if os(macOS)
let wgpuPath = "Sources/Libs/Wgpu/wgpu-macos-aarch64-release"
#elseif os(Linux)
let wgpuPath = "Sources/Libs/Wgpu/wgpu-linux-x86_64-release"
let vulkanPath = "Sources/Libs/Vulkan/Linux"
#endif

var dependencies: [Target.Dependency] = []
#if os(Linux)
dependencies.append("Vulkan")
#endif

var linkedLibraries: [LinkerSetting] = []
#if os(Linux)
linkedLibraries.append(.linkedLibrary("vulkan"))
#endif

var linkerSettings: [LinkerSetting] = []
#if os(macOS)
linkerSettings.append(contentsOf: [
    .unsafeFlags(["-L" + wgpuPath]),
    .unsafeFlags(["-Xlinker", "-rpath", "-Xlinker", wgpuPath])
])
#endif

// Define the targets array
var targets: [Target] = [
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

#if os(Linux)
targets.append(Target.systemLibrary(
    name: "Vulkan",
    path: vulkanPath,
    pkgConfig: "vulkan",
    providers: [
        .apt(["libvulkan-dev", "libvulkan1"])
    ]
))
targets.append(Target.systemLibrary(
    name: "X11",
    path: "Sources/Libs/X11/Linux",
    pkgConfig: "x11",
    providers: [
        .apt(["libx11-dev"])
    ]
))
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
    targets: targets
)
