# getrusage() wrapper
- known to work on Linux
- created as my simple "time for x in {1..100}; ..." benchmarks were a lot less pleasant on OpenBSD.

## Zig notes
- this is a Zig translation of the C version at https://github.com/jrfondren/getr
- the translation could be less direct and use Zig's own subprocess and argument-handling code
- the translation might be more comparable to the Ada version, which also recreates the rusage struct and which has similar use of C FFI. The Ada version is at https://github.com/jrfondren/getr-ada
- glibc's sys/resource.h is of a quality that defies Zig's much more convenient cImport() functionality
- Zig has its own build system that could be used instead

## build
```
zig build
```
This will place the binary in `zig-cache/bin`. It can also be run with `zig build run [...remaining args...]`

## usage and examples
```
$ getr 1000 ./fizzbuzz >/dev/null
User time      : 0 s, 282528 us
System time    : 0 s, 129038 us
Time           : 411 ms (0.412 ms/per)
Max RSS        : 1688 kB
Page reclaims  : 65366
Page faults    : 0
Block inputs   : 0
Block outputs  : 0
vol ctx switches   : 998
invol ctx switches : 11

$ getr 100 $(which python3) -c ''
User time      : 1 s, 477650 us
System time    : 0 s, 254884 us
Time           : 732 ms (17.325 ms/per)
Max RSS        : 8704 kB
Page reclaims  : 98409
Page faults    : 0
Block inputs   : 0
Block outputs  : 0
vol ctx switches   : 102
invol ctx switches : 6

$ getr 100 $(which perl) -le ''
User time      : 0 s, 89865 us
System time    : 0 s, 72273 us
Time           : 162 ms (1.621 ms/per)
Max RSS        : 5060 kB
Page reclaims  : 22188
Page faults    : 0
Block inputs   : 0
Block outputs  : 0
vol ctx switches   : 103
invol ctx switches : 5
```

## defects and room for improvement
- no $PATH resolution occurs
- output is in an ad-hoc text format that machine consumers would need to parse manually
- only `posix_spawn` is used, but fork&exec might be preferred for timings more like a fork&exec-using application
- this command lacks a manpage
- 'getr' is probably a poor name
- kB and ms are always used even when number ranges might be easier to understand in MB or s, or GB or min:s
