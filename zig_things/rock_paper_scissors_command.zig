//! Rock paper scissors done differently, because the last one left a bad
//! taste in my mouth.
//! update: this isn't any better man....
const std = @import("std");
const str_eql = std.mem.eql;
const to_slice = std.mem.span;
const copy = std.mem.copyForwards;
const exit = std.os.exit;
//           std.os.argv
const timestamp = std.time.timestamp;
const stdOut = std.io.getStdOut().writer();

fn computerChoice() u8 {
    return @intCast(@mod(timestamp(), 3));
}
fn playerChoice() u8 {
    const help =
        \\This command recognizes only one argument.
        \\available inputs:
        \\    rock
        \\    paper
        \\    scissors 
        \\
    ;
    const rock = "rock";
    const paper = "paper";
    const scissors = "scissors";
    for (std.os.argv) |c_arg| {
        const arg: []u8 = to_slice(c_arg);
        if (str_eql(u8, arg, rock)) {
            return 0;
        } else if (str_eql(u8, arg, paper)) {
            return 1;
        } else if (str_eql(u8, arg, scissors)) {
            return 2;
        }
    }
    _ = stdOut.write(help) catch null;
    return 3;
}
fn didYouWin() u2 {
    // 0 - player, 1 - computer, 2 - tie, 3 - err
    const H = playerChoice();
    if (H == 3) {
        return 3;
    }
    const C = computerChoice();
    if (C == H) {
        return 2;
    } else if ((C == 0 and H == 2) or (C == 1 and H == 0) or (C == 2 and H == 1)) {
        return 1;
    } else if ((C == 0 and H == 1) or (C == 1 and H == 2) or (C == 2 and H == 0)) {
        return 0;
    } else {
        return 3;
    }
}
pub fn main() !void {
    const winner = didYouWin();
    var result = [1]u8{32} ** 14;
    result[13] = '\n';
    if (winner == 3) {
        exit(0);
    } else if (winner == 2) {
        _ = copy(u8, &result, "tie!");
    } else if (winner == 1) {
        _ = copy(u8, &result, "computer won!");
    } else if (winner == 0) {
        _ = copy(u8, &result, "player won!");
    } else {
        exit(1);
    }
    _ = stdOut.write(&result) catch null;
    return;
}
