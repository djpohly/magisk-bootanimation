custompath=
realpath=

set_custompath() {
	ui_print "- Loading custom boot animation:"
	for dir in /sdcard /sdcard/Documents /sdcard/Download; do
		for filename in .bootanimation.zip bootanimation.zip; do
			filepath="$dir/$filename"
			if [ -f "$filepath" ]; then
				custompath="$filepath"
				ui_print "    * $filepath found!"
				return 0
			fi
			ui_print "    - $filepath not found"
		done
	done
	return 1
}

search_bootanimation() {
	find /system -type f -maxdepth 3 -name bootanimation.zip 2>/dev/null | while read -r path; do
		[ -r "$path" ] || continue
		echo "$path"
		return 0
	done
	return 1
}

set_realpath() {
	ui_print "- Locating system boot animation:"
	for path in /system/product/media /system/media; do
		if [ -f "$path/bootanimation.zip" ]; then
			realpath="$path/bootanimation.zip"
			ui_print "    * $path/bootanimation.zip found!"
			return 0
		fi
		ui_print "    - $path/bootanimation.zip not found"
	done

	ui_print "    - Searching /system..."
	path=$(search_bootanimation)
	[ -z "$path" ] && return 1

	ui_print "        * $path... found!"
	realpath=$path
	return 0
}

set_custompath || abort "! No custom boot animation found"
set_realpath || abort "! Unable to locate system boot animation"

ui_print "- Installing systemless overlay"
install -Dm644 "$custompath" "$MODPATH/$realpath" || abort "! Install failed"
