#!/bin/bash
set -euo pipefail
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
kernel=${BLUELINE_KERNEL_SOURCE:-$root/linux}
patch_file=$root/patches/pixel3-halium12-kernel.patch
if ! git -C "$kernel" apply --reverse --check "$patch_file" 2>/dev/null; then
    git -C "$kernel" apply "$patch_file"
fi
# AOSP stores the built-in audio sources in a separate repository.
if [[ ! -f $kernel/techpack/audio/Makefile ]]; then
    mkdir -p "$kernel/techpack/audio"
    git -C "$root/audio" archive HEAD | tar -x -C "$kernel/techpack/audio"
fi
mkdir -p "$root/build"
cp "$root/kernel-adaptation-simplified/kernel-adaptation-simplified.inc" "$root/build/"
patch --batch --silent -p1 -d "$root/build" -i "$root/patches/kernel-packaging.patch"
