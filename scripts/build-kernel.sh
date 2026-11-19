#!/bin/bash
set -euo pipefail
ulimit -c 0
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
source "$root/scripts/kernel-env.sh"
"$root/scripts/prepare-sources.sh"
jobs=${BLUELINE_BUILD_JOBS:-6}
kernel=${BLUELINE_KERNEL_SOURCE:-$root/linux}
output=$kernel/out
mkdir -p "$output" "$root/logs"
make -C "$kernel" O="$output" CC=clang HOSTCC=gcc b1c1_defconfig
bash "$kernel/scripts/kconfig/merge_config.sh" -m -O "$output" "$output/.config" "$root/configs/halium-blueline.config"
make -C "$kernel" O="$output" CC=clang HOSTCC=gcc olddefconfig
if [[ ${1:-} == --configure-only ]]; then
    exit 0
fi
make -C "$kernel" O="$output" CC=clang HOSTCC=gcc AR=llvm-ar NM=llvm-nm -j"$jobs" Image.lz4 modules dtbs
# WLAN is kept outside kernel/msm in Google's Android 12 manifest.
make -C "$kernel" O="$output" CC=clang HOSTCC=gcc AR=llvm-ar NM=llvm-nm -j"$jobs" M="$root/wlan/qcacld-3.0" WLAN_ROOT="$root/wlan/qcacld-3.0" CONFIG_QCA_CLD_WLAN=m CONFIG_QCA_WIFI_ISOC=0 CONFIG_QCA_WIFI_2_0=1 MODNAME=wlan modules
make -C "$kernel" O="$output" CC=clang HOSTCC=gcc AR=llvm-ar NM=llvm-nm INSTALL_MOD_STRIP=1 INSTALL_MOD_PATH="$root/build/kernel-install" modules_install
make -C "$kernel" O="$output" CC=clang HOSTCC=gcc AR=llvm-ar NM=llvm-nm M="$root/wlan/qcacld-3.0" WLAN_ROOT="$root/wlan/qcacld-3.0" CONFIG_QCA_CLD_WLAN=m CONFIG_QCA_WIFI_ISOC=0 CONFIG_QCA_WIFI_2_0=1 MODNAME=wlan INSTALL_MOD_STRIP=1 INSTALL_MOD_PATH="$root/build/kernel-install" modules_install
release=$(make -s -C "$kernel" O="$output" CC=clang kernelrelease)
depmod -b "$root/build/kernel-install" "$release"
printf '%s\n' "$release" > "$root/build/kernel-release"
