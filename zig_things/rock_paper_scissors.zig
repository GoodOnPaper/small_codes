//! Rock Paper Scissors that is probably very much not random. no structs.
const std = @import("std");
const stdin = std.io.getStdIn().reader();
const stdout = std.io.getStdOut().writer();
const time = std.time;
const equalStr = std.ascii.eqlIgnoreCase;
fn time_rand(max: u8) u8 {
    if (max == 0) {
        return 0;
    }
    const max_64: i64 = @intCast(max);
    const result: u8 = @intCast(@mod(time.timestamp(), max_64));
    return result;
}
fn WhoWon(H: u8, C: u8) u2 {
    // 0 - computer, 1 - human, 2 - tie
    if (H == C or C > 2 or H > 2) {
        return 2;
    } else if ((C == 1 and H == 2) or (C == 0 and H == 1) or (C == 2 and H == 0)) {
        return 1;
    } else if ((C == 2 and H == 1) or (C == 1 and H == 0) or (C == 0 and H == 2)) {
        return 0;
    } else {
        return 2;
    }
}
fn ChoiceToStr(C: u8) []const u8 {
    if (C == 0) {
        return "rock\n";
    } else if (C == 1) {
        return "paper\n";
    } else if (C == 2) {
        return "scissors\n";
    } else {
        return "\n";
    }
}
pub fn playRockPaperScissorsVSComputer() void {
    var player_choice: u8 = undefined;
    var buffer: [9]u8 = undefined;
    //keep trying until it works out... uhh yeah
    while (true) {
        _ = stdout.write("your choice: ") catch null;
        if (stdin.readUntilDelimiterOrEof(buffer[0..], '\n') catch null) |input| {
            if (equalStr(input, "rock")) {
                player_choice = 0;
                break;
            } else if (equalStr(input, "paper")) {
                player_choice = 1;
                break;
            } else if (equalStr(input, "scissors")) {
                player_choice = 2;
                break;
            } else {
                _ = stdout.write("couldn't read player input!\n") catch null;
                continue;
            }
        } else {
            continue;
        }
    }
    const computer_choice = time_rand(3);
    _ = stdout.write("computer choice: ") catch null;
    _ = stdout.write(ChoiceToStr(computer_choice)) catch null;
    const win: u2 = WhoWon(player_choice, computer_choice);
    const winner = switch (win) {
        0 => "computer won!\n",
        1 => "human won!\n",
        2 => "tie!\n",
        else => "error\n",
    };
    _ = stdout.write(winner) catch null;
    _ = stdout.write("another round?[y/n]:") catch null;
    var yesno: [5]u8 = undefined;
    var restart = false;
    if (stdin.readUntilDelimiterOrEof(&yesno, '\n') catch null) |yorn| {
        if (yorn[0] == 'y') {
            restart = true;
        }
    }
    if (restart) {
        _ = playRockPaperScissorsVSComputer();
    }
}
pub fn main() !void {
    _ = playRockPaperScissorsVSComputer();
}
