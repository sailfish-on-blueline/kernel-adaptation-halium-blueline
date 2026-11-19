%define device halium-blueline
%define kernel_arch arm64
%define device_target_cpu aarch64
%define kcflags "KCFLAGS="
%define makeopts CC=clang HOSTCC=gcc AR=llvm-ar NM=llvm-nm CROSS_COMPILE_ARM32=arm-linux-androideabi-
%if 0%{!?extra_modules_makeopts:1}
%define extra_modules_makeopts CONFIG_QCA_CLD_WLAN=m CONFIG_QCA_WIFI_ISOC=0 CONFIG_QCA_WIFI_2_0=1 MODNAME=wlan WLAN_ROOT=$PWD/wlan/qcacld-3.0
%endif
%define clangtriple aarch64-linux-gnu-
%define crosscompile aarch64-linux-android-
%define crosscompile32 arm-linux-androideabi-
%define hostldflags %{nil}
%if 0%{!?source_directory:1}
%define source_directory linux
%endif
%define kernel_image Image.lz4
# Built by scripts/build-kernel.sh, including Google's external WLAN module.
%define build_Image 0
%define build_modules 1
%if 0%{!?extra_modules:1}
%define extra_modules wlan/qcacld-3.0
%endif
%define ramdisk ramdisk-blueline.img
%define bootimg_name boot.img
%define deviceinfo_bootimg_prebuilt_dtb stock.dtb
%define deviceinfo_dtb qcom/sdm845-v2.1.dtb
%define deviceinfo_flash_pagesize 4096
%define deviceinfo_flash_offset_base 0x00000000
%define deviceinfo_flash_offset_kernel 0x00008000
%define deviceinfo_flash_offset_ramdisk 0x01000000
%define deviceinfo_flash_offset_second 0x00000000
%define deviceinfo_flash_offset_tags 0x00000100
%define deviceinfo_flash_offset_dtb 0x01f00000
%define deviceinfo_bootimg_header_version 2
%define deviceinfo_bootimg_os_version 12.0.0
%define deviceinfo_bootimg_os_patch_level 2021-10
%define deviceinfo_bootimg_partition_size 67108864
%define deviceinfo_kernel_cmdline console=ttyMSM0,115200n8 androidboot.console=ttyMSM0 printk.devkmsg=on msm_rtb.filter=0x237 ehci-hcd.park=3 service_locator.enable=1 cgroup.memory=nokmem lpm_levels.sleep_disabled=1 usbcore.autosuspend=7 loop.max_part=7 androidboot.boot_devices=soc/1d84000.ufshc systempart=/dev/disk/by-partlabel/userdata datapart=/dev/disk/by-partlabel/userdata boot=halium init=/init security=smack androidboot.selinux=permissive systemd.unified_cgroup_hierarchy=0 systemd.legacy_systemd_cgroup_controller=1
Version: 4.9.270
Release: 5
%include build/kernel-adaptation-simplified.inc
