const std = @import("std");

// Windows API Beep function
extern "kernel32" fn Beep(freq: u32, duration: u32) callconv(.Winapi) c_int;

pub fn main() !void {
    const bpm: u32 = 120;
    const freq: u32 = 880;
    const click_ms: u32 = 40;

    const beat_ms = 60000 / bpm;

    while (true) {
        _ = Beep(freq, click_ms);
        std.time.sleep(std.time.ns_per_ms * (beat_ms - click_ms));
    }
}
