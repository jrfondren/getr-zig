const std = @import("std");
const rusage = @import("rusage.zig");
const spawn = @import("spawn.zig");
const warn = std.debug.warn;

const REPORT =
   \\User time      : {} s, {} us
   \\System time    : {} s, {} us
   \\Time           : {} ms ({.3} ms/per)
   \\Max RSS        : {} kB
   \\Page reclaims  : {}
   \\Page faults    : {}
   \\Block inputs   : {}
   \\Block outputs  : {}
   \\vol ctx switches   : {}
   \\invol ctx switches : {}
   \\
;

fn report(count: i32) !void {
   var usage: rusage.Usage = undefined;
   try usage.Get(rusage.Who.CHILDREN);
   const time = @divTrunc((usage.utime.usec + usage.stime.usec), 1000)
      + @divTrunc((usage.utime.sec + usage.stime.sec), 1000);
   const ptime = (@intToFloat(f64, usage.utime.usec + usage.stime.usec)/1000.0
      + (@intToFloat(f64, usage.utime.sec + usage.stime.sec)*1000.0))/@intToFloat(f64, count);
   warn(REPORT,
      usage.utime.sec, usage.utime.usec,
      usage.stime.sec, usage.stime.usec,
      time, ptime,
      usage.maxrss,
      usage.minflt,
      usage.majflt,
      usage.inblock,
      usage.oublock,
      usage.nvcsw,
      usage.nivcsw);
}

pub fn main() !void {
   const argv = std.os.ArgIteratorPosix.raw;
   if (argv.len > 2) {
      const count = try std.fmt.parseInt(i32, std.mem.toSliceConst(u8, argv[1]), 10);
      var i = count;

      while (i > 0) : (i -= 1) {
         try spawn.run(argv[2], &argv[2]);
      }

      try report(count);
   } else {
      warn("usage: {} <n> <command> [<args> ....]\n", std.mem.toSliceConst(u8, argv[0]));
      std.os.exit(1);
   }
}
