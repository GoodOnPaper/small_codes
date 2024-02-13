const std = @import("std");
const time = std.time;
const stdOut = std.io.getStdOut();
const numError = error{numAboveHundred};

const offset_UTC: i17 = 1;

fn intToStr(num: u8, str: *[2]u8) !void {
    if (num < 100 and num > -100) {
        str[1] = @mod(num, 10) + '0';
        str[0] = @divFloor(num, 10) + '0';
    } else {
        return numError.numAboveHundred;
    }
}
pub fn main() !void {
    var timewas: u17 = @truncate(@abs(@mod(time.timestamp() + extra_secs, 86400)));
    var timeis: u17 = undefined;
    var seconds: u8 = @intCast(@mod(timewas, 60));
    var minutes: u8 = @intCast(@mod(@divFloor(timewas, 60), 60));
    var hours: u8 = @intCast(@divFloor(timewas, 3600));

    var time_display: [8]u8 = undefined;
    var time_string = &time_display;
    time_string[2] = ':';
    const clock_sec = time_string[6..8];
    const clock_min = time_string[3..5];
    const clock_hur = time_string[0..2];

    const clear_terminal = "\x1B[2J\x1B[H";
    var swap: bool = false;
    const extra_secs: i64 = 3600 * offset_UTC;
    while (true) {
        timeis = @truncate(@abs(@mod(time.timestamp() + extra_secs, 86400)));
        if (timeis > timewas) {
            if (swap) {
                swap = false;
                time_string[5] = ':';
            } else {
                swap = true;
                time_display[5] = ' ';
            }
            seconds = @truncate(@mod(timeis, 60));
            try intToStr(seconds, clock_sec);
            minutes = @truncate(@mod(@divFloor(timeis, 60), 60));
            try intToStr(minutes, clock_min);
            hours = @truncate(@divFloor(timeis, 3600));
            try intToStr(hours, clock_hur);
            _ = try stdOut.write(clear_terminal);
            _ = try stdOut.write(time_string);
            std.debug.print(" {}", .{timeis});

            timewas = timeis;
        }
        time.sleep(700000); //arbitrary number, makes cpu not go vroooom
    }
}
