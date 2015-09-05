#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 9269248 358de6160526298f31e02d9a4f9909a2a85cb92b 5607424 42410a9eebd84242876a21b65e0b8f437c763696
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p13:9269248:358de6160526298f31e02d9a4f9909a2a85cb92b; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p12:5607424:42410a9eebd84242876a21b65e0b8f437c763696 EMMC:/dev/block/mmcblk0p13 358de6160526298f31e02d9a4f9909a2a85cb92b 9269248 42410a9eebd84242876a21b65e0b8f437c763696:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
