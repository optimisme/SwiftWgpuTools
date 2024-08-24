#!/bin/bash

export RUST_BACKTRACE=1

# Reset the terminal
reset

# Clean the Swift build environment
swift package clean


# Build the project with Swift

swift build --target WgpuTools
swift build --configuration release --target WgpuTools


