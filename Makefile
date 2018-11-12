OPT=--release-fast

all:: getr

clean::
	rm -fv getr
	rm -rf zig-cache

getr: getr.zig rusage.zig
	zig build-exe $< --library c $(OPT)

