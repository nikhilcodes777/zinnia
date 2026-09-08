const std = @import("std");

pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{ .preferred_optimize_mode = .ReleaseSafe });
    const target = b.resolveTargetQuery(.{
        .os_tag = .freestanding,
        .cpu_arch = .aarch64,
        .ofmt = .elf,
    });

    const kernel_mod = b.createModule(.{
        .optimize = optimize,
        .root_source_file = b.path("src/main.zig"),
        .target = target,
    });

    const kernel = b.addExecutable(.{
        .name = "kernel.elf",
        .root_module = kernel_mod,
        .use_lld = true,
        .use_llvm = true,
    });
    kernel.root_module.addAssemblyFile(b.path("src/boot.s"));
    kernel.setLinkerScript(b.path("src/linker.ld"));

    b.installArtifact(kernel);
    const qemu = b.addSystemCommand(&.{
        "qemu-system-aarch64",
        "-M",
        "virt",
        "-cpu",
        "cortex-a53",
        "-nographic",
        "-kernel",
    });
    qemu.addArtifactArg(kernel);
    const run_step = b.step("run", "run in QEMU");
    run_step.dependOn(&qemu.step);
}
