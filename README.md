# Google Pixel 3 Halium 12 kernel adaptation

Google AOSP Android 12 kernel for Pixel 3, based on `862f51bac900c4b8a6e31792369e588bb395b8a3`, producing `4.9.270-halium-blueline`. Release 7 includes the Smack/ext4 compatibility, Internet socket permissions, CS40L20 vibrator firmware and MNH thermal retry fixes verified on the device. Its package contains all fifteen modules, including WLAN, with matching kernel symbol versions. External module builds accept relative and absolute source paths, and RPM validation checks the WLAN payload.

```sh
git clone --recurse-submodules https://github.com/sailfish-on-blueline/kernel-adaptation-halium-blueline.git
cd kernel-adaptation-halium-blueline
export BLUELINE_CLANG_ROOT=/path/to/clang-r416183b
export BLUELINE_GCC_ROOT=/path/to/prebuilts/gcc/linux-x86
scripts/build-kernel.sh
scripts/build-rpm.sh
```

Use AOSP Clang 12.0.5/r416183b and the AOSP Android 4.9 GCC/binutils prebuilts for aarch64 and arm. `configs/aosp-kernel-manifest.xml` records their upstream locations. Host dependencies include GNU make, GCC, flex, bison, bc, dtc, lz4, openssl, Python 3, patch, tar, kmod and rpmbuild. `BLUELINE_BUILD_JOBS` defaults to 6. LLVM LTO requires sufficient RAM for linking.

`linux`, `audio`, `wlan/fw-api`, `wlan/qca-wifi-host-cmn`, `wlan/qcacld-3.0`, `kernel-adaptation-simplified`, `mkbootimg` and `avb` are pinned Git submodules hosted under `sailfish-on-blueline`. The dependency repositories import the fixed upstream source trees. Their original URLs, commits and tree hashes are recorded in `configs/upstream-revisions.json`. `scripts/prepare-sources.sh` applies the local kernel patch, copies the separate AOSP audio sources into `linux/techpack/audio`, and creates the patched packaging include in `build`. Builds use `linux/out`. The RPM build consumes the compiled kernel and modules.

`configs/halium-blueline.config` is merged over Google's `b1c1_defconfig`. It enables Smack and the Sailfish container/device interfaces, disables Qualcomm PFK and Android paranoid networking, and builds the external WLAN module.

`ramdisk-blueline.img` is the Halium boot ramdisk prepared for userdata root mounting, filesystem expansion, Pixel 3 USB panic handling and early CS40L20 firmware loading. `stock.dtb` comes from the SP1A.210812.016.C1 stock boot image. The boot image uses header version 2 and an unsigned AVB hash footer for an unlocked bootloader.
