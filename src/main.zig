const std = @import("std");

// Windows API functions
extern "user32" fn MessageBeep(uType: u32) callconv(.winapi) i32;
extern "kernel32" fn Sleep(dwMilliseconds: u32) callconv(.winapi) void;

pub fn main() !void {
    const bpm: u32 = 120;
    const beat_ms = 60000 / bpm;

    std.debug.print("Metronome started at {} BPM\n", .{bpm});

    while (true) {
        std.debug.print(".", .{});
        _ = MessageBeep(0);
        Sleep(beat_ms);
    }
}
