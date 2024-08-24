# Swift WGPU HelloWorld

This library allows the easily use WGPU in Swift projects.

It is simply a Swift project that links the WGPU release binaries and makes them easily available for other Swift projects.

WGPU uses Metal on macOS and Vulkan on Linux, so it works on both macOS and Linux.

Once the library is added as a dependency, the WGPU binaries are located at the 'checkout' folder. And must be configured at the package that uses the library. See the example [here](https://github.com/optimisme/Swift-WGPU-HelloWorld/).

Location of WGPU binaries:

```bash
.build/checkouts/SwiftWgpuTools/Sources/Libs/Wgpu/
```

## Install dependencies

### macOS

macOS does not require any dependencies

### Linux
```bash
sudo apt-get install \
  libx11-dev \
  libvulkan-dev \
  libvulkan1
```

## Example using this library

[Swift-WGPU-HelloWorld](https://github.com/optimisme/Swift-WGPU-HelloWorld/)

## About WGPU binaries 

WGPU has a 'Mozilla Public License Version 2.0,' which requires including the original code or an easy way to access the original code. The binaries distributed by this project are from the official project:

[WGPU GitHub project](https://github.com/gfx-rs/wgpu)

WGPU binaries are found in the **WGPU** folder and have been downloaded from:

[WGPU v0.19.4.1](https://github.com/gfx-rs/wgpu-native/releases)

