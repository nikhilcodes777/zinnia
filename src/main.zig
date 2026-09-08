const mmio = @import("mmio.zig");
extern var __bss_start: anyopaque;
extern var __bss_end: anyopaque;
fn zeroBss() void {
    const start_addr = @intFromPtr(&__bss_start);
    const end_addr = @intFromPtr(&__bss_end);
    const bss_size: usize = end_addr - start_addr;
    if (bss_size > 0) {
        const ptr: [*]u8 = @ptrCast(&__bss_start);
        @memset(ptr[0..bss_size], 0);
    }
}

export fn kmain() noreturn {
    zeroBss();

    mmio.print("Hello world!\n");
    while (true) {}
}
