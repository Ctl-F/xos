const std = @import("std");
const common = @import("common.zig");

pub const PAGE_SIZE = common.Kilobytes(4);
pub const NUM_PAGES = common.Gigabytes(1) / PAGE_SIZE;

pub const RamError = error{
    UnableToAllocate,
};

const Ram = @This();

allocator: std.mem.Allocator,
pages: [NUM_PAGES][]u8,

pub fn init(baseAllocator: std.mem.Allocator) RamError!Ram {

    var ram = Ram {
        .allocator = baseAllocator,
        .pages = undefined,
    };

    for(0..NUM_PAGES) |i| {
        const page = baseAllocator.alloc(u8, PAGE_SIZE) catch return RamError.UnableToAllocate;
        errdefer baseAllocator.free(page);

        ram.pages[i] = page;
    }

    return ram;
}

pub fn deinit(self: Ram) void {
    for(self.pages) |page| {
        self.allocator.free(page);
    }
}

test "RAM suceeds in allocation" {
    const gpa = std.heap.page_allocator;

    const ram = try Ram.init(gpa);
    defer ram.deinit();

    std.debug.print("Pages Allocated: {d}\nPage Size: {d}\nTotal RAM: {d}\n", .{ ram.pages.len, ram.pages[0].len, ram.pages.len * ram.pages[0].len });
}

