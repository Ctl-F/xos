const std = @import("std");

pub const Disk = struct {
    capacity: usize,
    label: []const u8,
    __host_filename: []const u8,
};

pub const DiskIOController = struct {};
