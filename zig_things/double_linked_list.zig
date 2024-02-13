//! Here i was just learning about how structs work, for actual LinkedList in
//! zig refer to std.DoublyLinkedList on ziglang.org.

const std = @import("std");

const print = @import("std").debug.print;
const assert = std.testing.expect;

const Allocator = std.mem.Allocator;
var alloc = std.heap.GeneralPurposeAllocator(.{}){};
const gpa = alloc.allocator();

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
        pub fn retArray(this: *Self, allocator: Allocator) []T {
            const empty: []T = undefined;
            var array = allocator.alloc(T, this.len) catch {
                return empty;
            };
            var curr_node: *Node = undefined;
            if (this.first) |that| {
                curr_node = that;
                array[0] = that.data;
            } else {
                return array;
            }
            var index: usize = 0;
            while (curr_node.next) |that| {
                array[index] = curr_node.data;
                curr_node = that;
                index += 1;
            } else {
                array[index] = curr_node.data;
                // off by one haha
                return array;
            }
            return array;
        }
    };
}

test "slice test" {
    //making a list
    var exlist = LinkedList(i32){
        .first = null,
        .last = null,
        .len = 1,
    };
    //making nodes and inserting
    var node1 = LinkedList(i32).Node{
        .prev = null,
        .next = null,
        .data = 34,
    };
    var node2 = LinkedList(i32).Node{
        .prev = null,
        .next = null,
        .data = 45,
    };
    var node3 = LinkedList(i32).Node{
        .prev = null,
        .next = null,
        .data = 54,
    };
    exlist.insertAtFront(&node3);
    exlist.insertAtFront(&node2);
    exlist.insertAtFront(&node1);
    //testing .retarray
    const listTest = exlist.retArray(gpa);
    try assert(listTest[0] == 34);
    try assert(listTest[1] == 45);
    try assert(listTest[2] == 54);
    gpa.free(listTest);
}

pub fn main() !void {
    print("end\n", .{});
}
