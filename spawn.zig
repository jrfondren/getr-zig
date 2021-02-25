const os = @import("std").os;

pub extern fn posix_spawn(pid: *i32, path: [*]const u8, posix_spawn_file_actions_t: ?[*]const u8, posix_spawnattr_t: ?[*]const u8, argv: *[*]u8, envp: *[*]u8) c_int;

pub fn spawn(pid: *i32, path: [*]const u8, argv: *[*]u8) !void {
    if (0 == posix_spawn(pid, path, null, null, argv, &os.environ[0])) return;
    return error.SpawnError;
}

pub fn run(path: [*]const u8, argv: *[*]u8) !void {
    var pid: i32 = undefined;
    try spawn(&pid, path, argv);
    _ = os.waitpid(pid, 0);
}
