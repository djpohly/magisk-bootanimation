module.zip: customize.sh module.prop
	zip -r - META-INF/ $^ > $@
