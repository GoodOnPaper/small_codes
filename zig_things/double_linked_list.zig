//! Here i was just learning about how structs work, for actual LinkedList in
//! zig refer to std.DoublyLinkedList on ziglang.org.

const std = @import("std");
const print = @import("std").debug.print;
const Allocator = std.mem.Allocator;

fn LinkedList(comptime T: type) type {
    return struct {
        const Self = @This();
        pub const Node = struct {
            prev: ?*Node,
            next: ?*Node,
            data: T,
        };

        first: ?*Node,
        last: ?*Node,
        len: usize,

        pub fn insertAtFront(this: *Self, node: *Node) void {
            if (this.first) |first_node| {
                first_node.prev = node;
                node.next = first_node;
                this.first = node;
                this.len += 1;
                return;
            } else {
                this.first = node;
                this.last = node;
                return;
            }
        }
        pub fn printNodes(this: *Self) void {
            var curr_node: *Node = undefined;
            if (this.first) |that| {
                curr_node = that;
            } else {
                print("empty", .{});
                return;
            }
            while (true) {
                print("data: {d}\n", .{curr_node.data});
                if (curr_node.next) |that| {
                    curr_node = that;
                } else {
                    return;
                }
            }
            return;
        }
        pub fn retArray(this: *Self, allocator: Allocator) ![*]T {
            const empty: [0]T = undefined;
            var array: []T = try allocator.alloc(T, this.len);
            var curr_node: *Node = undefined;
            if (this.first) |that| {
                curr_node = that;
                array[0] = that.data;
            } else {
                return &empty;
            }
            for (1..this.len) |i| {
                if (curr_node.next) |that| {
                    array[i] = curr_node.data;
                    curr_node = that;
                } else {
                    return &empty;
                }
            }
            return &empty;
        }
    };
}

pub fn main() !void {
    var alloc = std.heap.GeneralPurposeAllocator(.{}){};
    const gpa = alloc.allocator();
    print("test\n", .{});
    const dllist = LinkedList(i32);
    var node1 = dllist.Node{
        .prev = null,
        .next = null,
        .data = 34,
    };
    var exlist = LinkedList(i32){
        .first = &node1,
        .last = &node1,
        .len = 1,
    };
    var node11 = LinkedList(i32).Node{
        .prev = &node1,
        .next = null,
        .data = 45,
    };
    exlist.last = &node11;
    exlist.len += 1;
    exlist.first.?.next = &node11;
    var node111 = LinkedList(i32).Node{
        .prev = null,
        .next = null,
        .data = 54,
    };
    exlist.insertAtFront(&node111);
    exlist.printNodes();
    var listTest: [*]i32 = try exlist.retArray(gpa);
    for (0..exlist.len) |i| {
        _ = i;
        print("{d}\n", .{listTest[0]});
    }
    print("end success\n", .{});
}
