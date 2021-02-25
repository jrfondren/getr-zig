pub const Timeval = extern struct {
    sec: u64,
    usec: u64,
};

pub const Who = extern enum {
    SELF = 0,
    CHILDREN = -1,
};

pub const Usage = extern struct {
    utime: Timeval,
    stime: Timeval,
    maxrss: u64,
    ixrss: u64,
    idrss: u64,
    isrss: u64,
    minflt: u64,
    majflt: u64,
    nswap: u64,
    inblock: u64,
    oublock: u64,
    msgsnd: u64,
    msgrcv: u64,
    nsignals: u64,
    nvcsw: u64,
    nivcsw: u64,

    pub fn Get(self: *Usage, who: Who) !void {
        if (0 == getrusage(who, self)) return;
        return error.GetrusageError;
    }
};

pub extern fn getrusage(who: Who, usage: *Usage) c_int;
