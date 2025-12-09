const std = @import("std");

// Windows API functions
extern "user32" fn MessageBeep(uType: u32) callconv(.winapi) i32;
extern "kernel32" fn Sleep(dwMilliseconds: u32) callconv(.winapi) void;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    const stdout = &stdout_writer.interface;

    var stdin_buffer_internal: [512]u8 = undefined;
    var stdin_reader = std.fs.File.stdin().reader(&stdin_buffer_internal);
    const stdin = &stdin_reader.interface;

    try stdout.print("Enter BPM: ", .{});
    var buffer: [32]u8 = undefined;

    var total_read: usize = 0;
    while (total_read < buffer.len) : (total_read += 1) {
        const byte = stdin.*.takeByte() catch break; // EOF
        buffer[total_read] = byte;
        if (byte == '\n') break;
    }

    var input_slice = buffer[0..total_read];
    // Trim trailing CR or LF
    while (input_slice.len > 0 and (input_slice[input_slice.len - 1] == '\n' or input_slice[input_slice.len - 1] == '\r')) {
        input_slice = input_slice[0 .. input_slice.len - 1];
    }

    const bpm = try std.fmt.parseInt(u32, input_slice, 10);

    const beat_ms = 60000 / bpm;

    std.debug.print("Metronome started at {} BPM\n", .{bpm});

    while (true) {
        std.debug.print(".", .{});
        _ = MessageBeep(0);
        Sleep(beat_ms);
    }
}
