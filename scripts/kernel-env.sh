#!/bin/bash
set -euo pipefail
blueline_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
blueline_clang=${BLUELINE_CLANG_ROOT:-$blueline_root/build/toolchains/clang-r416183b}
if [[ ! -x $blueline_clang/bin/clang ]]; then
    echo "AOSP Clang r416183b is required in $blueline_clang" >&2
    return 1 2>/dev/null || exit 1
fi
blueline_gcc=${BLUELINE_GCC_ROOT:-$blueline_root/build/toolchains/gcc/linux-x86}
export PATH=$blueline_clang/bin:$blueline_gcc/aarch64/aarch64-linux-android-4.9/bin:$blueline_gcc/arm/arm-linux-androideabi-4.9/bin:$PATH
export LD_LIBRARY_PATH=$blueline_clang/lib64${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
export ARCH=arm64
export CC=clang
export CLANG_TRIPLE=aarch64-linux-gnu-
export CROSS_COMPILE=aarch64-linux-android-
export CROSS_COMPILE_ARM32=arm-linux-androideabi-
export CROSS_COMPILE32=arm-linux-androideabi-
export LOCALVERSION=-halium-blueline
export KBUILD_BUILD_USER=sailfish
export KBUILD_BUILD_HOST=blueline
export KBUILD_BUILD_VERSION=1
export DTC_EXT=dtc
export MKBOOTIMG_PATH=$blueline_root/mkbootimg
export AVB_PATH=$blueline_root/avb
export HALIUM_RAMDISK=$blueline_root/ramdisk-blueline.img
unset CFLAGS CXXFLAGS LDFLAGS
