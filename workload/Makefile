charts:
	git submodule init
	git submodule update

%.yaml: %.sh charts
	./$^ > $@
