.PHONY: build

build: base base-fv base-ra base-ra-bp

base:       base/base-kompiled
base-fv:    base-fv/base-kompiled
base-ra:    base-ra/base-kompiled
base-ra-bp: base-ra-bp/base-kompiled

%/base-kompiled: %/base.md
	cd $(@D) && kompile --gen-bison-parser base.md
