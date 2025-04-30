const std = @import("std");
const common = @import("common.zig");

const MAX_SECTIONS = 8;

pub const RamError = error{
    UnableToAllocate,
};

const Ram = @This();

allocator: std.mem.Allocator,
sections: [][]u8,
_section_data: [MAX_SECTIONS][]u8,
section_count: usize,
section_size: usize,

pub fn init(baseAllocator: std.mem.Allocator, totalRam: usize) RamError!Ram {
    const sections: [MAX_SECTIONS]?[]u8 = [1]?[]u8{null} ** MAX_SECTIONS;

    for (0..MAX_SECTIONS) |sectionCount| {
        const sectionSize = totalRam / (sectionCount + 1);
        var successfulAllocation = true;

        // attempt to allocater the sections
        for (0..(sectionCount + 1)) |i| attempt: {
            sections[i] = baseAllocator.alloc(u8, sectionSize) catch {
                successfulAllocation = false;
                break :attempt;
            };
        }

        if (!successfulAllocation) {
            var i = 0;
            while (sections[i]) |section| {
                baseAllocator.free(section);
                sections[i] = null;
                i += 1;
            }
            continue;
        }

        var result = Ram{
            .allocator = baseAllocator,
            .section_count = sectionCount,
            .section_size = sectionSize,
            .sections = undefined,
            ._section_data = undefined,
        };

        for (sections, 0..) |section, i| {
            if (i == MAX_SECTIONS) break;

            if (section == null) {
                unreachable; // should not happen
            }
            result._section_data[i] = section.?;
        }

        result.sections = result._section_data[0..result.section_count];
        return result;
    }

    return RamError.UnableToAllocate;
}

pub fn deinit(self: Ram) void {
    for (self.sections) |section| {
        self.allocator.free(section);
    }
}

test "ram_allocation_succeeds" {
    var buffer = [1]u8{0} ** common.Kilobytes(10);
    const fba = std.heap.FixedBufferAllocator.init(&buffer);

    const ram = try Ram.init(fba, common.Kilobytes(5));
    defer ram.deinit();

    std.debug.print("RAM Allocation Is: {d} sections of size {d}\n", .{ ram.section_count, ram.section_size });
}
