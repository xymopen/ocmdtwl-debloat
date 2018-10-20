#!/system/bin/sh
# Please don't hardcode /magisk/modname/... ; instead, please use $MODDIR/...
# This will make your scripts compatible even if Magisk change its mount point in the future
MODDIR=${0%/*}

# This script will be executed in post-fs-data mode
# More info in the main Magisk thread

# exec >"/cache/mod.log"
# exec 2>&1

REMOVE_FILES="
/preload/SougouSearch.apk
/preload/HTCCN_Gamehall.apk
/preload/HTCCN_Dynamic_Wallpaper.apk
/preload/DianPing.apk
/preload/qqpim.apk
/preload/HTCCN_TodayNews.apk
/preload/HTCCN_Sogou_Zhuyin_IME.apk
/preload/HTCCN_JingDong.apk
/preload/amap.apk
/preload/HTCCN_Weibo.apk
/preload/News_Republic.apk
/preload/HTCCN_Multiple_Accounts.apk
/preload/AiReader.apk
/preload/HTCCN_WangyiyunMusic.apk
/preload/Alipay.apk
/preload/HTCCN_Baidu_VoiceAssistant.apk
/preload/WPSOffice.apk
"

PRESERVE_FILES=""

for filename in /preload/*; do
	[ "$filename" = "/preload/*" ] && continue

	for target in $REMOVE_FILES; do
		[ "$filename" = "$target" ] && continue 2
	done

	PRESERVE_FILES="$filename
	$PRESERVE_FILES"
done

# Simpified `magic_mount()` for `/preload` partition
mount -o bind "/preload" "$MODDIR/preload"
umount -l "/preload"
mount -t tmpfs tmpfs "/preload"

for target in $PRESERVE_FILES; do
	if [ -L "$MODDIR$target" ]; then
		cp --preserve=all -af "$MODDIR$target" "$target"
	elif [ -d "$MODDIR$target" ]; then
		mkdir "$target"
		mount -o bind "$MODDIR$target" "$target"
	elif [ -f "$MODDIR$target" ]; then
		touch "$target"
		mount -o bind "$MODDIR$target" "$target"
	fi
done
