#!/bin/bash
set -euo pipefail
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
source "$root/scripts/kernel-env.sh"
"$root/scripts/prepare-sources.sh"
kernel=${BLUELINE_KERNEL_SOURCE:-$root/linux}
wlan_root=${BLUELINE_WLAN_ROOT:-$root/wlan}
test -s "$kernel/out/arch/arm64/boot/Image.lz4"
topdir=${BLUELINE_RPM_TOPDIR:-$root/build/rpmbuild}
mkdir -p "$topdir"/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS,tmp} "$root/logs"
cd "$root"
rpmbuild --build-in-place --nodeps --target aarch64 \
    --define "_topdir $topdir" --define "_tmppath $topdir/tmp" \
    --define "source_directory $kernel" --define "extra_modules $wlan_root/qcacld-3.0" \
    --define "extra_modules_makeopts CONFIG_QCA_CLD_WLAN=m CONFIG_QCA_WIFI_ISOC=0 CONFIG_QCA_WIFI_2_0=1 MODNAME=wlan WLAN_ROOT=$wlan_root/qcacld-3.0" \
    --define '_buildshell /bin/bash' --define '__os_install_post %{nil}' \
    --define 'debug_package %{nil}' --define '_binary_payload w6.xzdio' \
    -bb rpm/kernel-adaptation-halium-blueline.spec > "$root/logs/kernel-rpm.log" 2>&1
edition=$(rpmspec -q --qf '%{VERSION}-%{RELEASE}' rpm/kernel-adaptation-halium-blueline.spec)
package="$topdir/RPMS/aarch64/kernel-adaptation-halium-blueline-$edition.aarch64.rpm"
release=$(make -s -C "$kernel" O=out CC=clang kernelrelease)
rpm -qlp "$package" | grep -Fxq "/lib/modules/$release/extra/wlan.ko"
printf 'Built kernel RPM in %s\n' "$topdir/RPMS"
