#!/bin/bash
curr_d=$(pwd)
ZIG_VERSION="0.12.0-dev.1604+caae40c21"
BUILD_MACHINE_ARCH=$(arch)
platform=$(uname -s)
case $platform in
    Linux*)     platform="linux" ;;
    Darwin*)    platform="macos" ;;
    *)          platform="Unknown" ;;
esac
if [[ $BUILD_MACHINE_ARCH == *arm* ]]; then
    BUILD_MACHINE_ARCH=x86_64
fi
ZIG_FOLDERNAME="zig-${platform}-${BUILD_MACHINE_ARCH}-${ZIG_VERSION}"
ZIG_FILENAME="${ZIG_FOLDERNAME}.tar.xz"
ZIG_URL="https://ziglang.org/builds/${ZIG_FILENAME}"

if ! command -v zig &> /dev/null || "$(zig version)" != $ZIG_VERSION; then
    # download and extract Zig
    TEMP=$(mktemp -d)
    mkdir $TEMP && cd $TEMP
    echo "Fetching zig from: $ZIG_URL"
    wget "$ZIG_URL"
    tar xf "$ZIG_FILENAME"
    # install Zig
    mv "${ZIG_FOLDERNAME}/lib" /usr/lib/zig
    mv "${ZIG_FOLDERNAME}/zig" /usr/bin/zig
    # clean up downloaded files
    rm -rf $TEMP
    cd $curr_d
else
    echo "zig is installed."
fi
