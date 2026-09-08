const UART: *volatile u8 = @ptrFromInt(0x09000000);
pub fn putChar(c: u8) void {
    UART.* = c;
}
pub fn print(str: []const u8) void {
    for (str) |c| {
        putChar(c);
    }
}
