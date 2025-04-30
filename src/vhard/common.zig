const std = @import("std");

pub fn Kilobytes(bytes: u32) u32 {
    return bytes * 1024;
}

pub fn Megabytes(bytes: u32) u32 {
    return Kilobytes(bytes) * 1024;
}

pub fn Gigabytes(bytes: u32) u32 {
    return Megabytes(bytes) * 1024;
}
