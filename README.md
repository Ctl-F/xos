## A Virtual Sub-Operating System Written for Personal Use and Learning
# Xos is a sub-operating system started with a few learning goals:

- Improve familiarity with Zig Programming Language
- Explore the components of Operating System development without having to worry about the messy hardware-specific details (yet)
- Implement Audio from Scratch (Not yet done, not high priority, something to get around to)

# Features to Implement:
[.] Memory Manager/Allocator
[.] Virtual Kernel
[.] Program Scheduler
[.] Application Management + Securities
[.] Filesystem
[.] Keyboard+Mouse+Screen I/O
[.] Textual+Graphical Modes (Similar to how older generations of computers operated)

# Architecture (Subject to Change as Project Evolves)
The main "executable" will act as the "hardware" and implement the "hardware specific" details such as a fixed buffer for RAM, a pre-allocated file to simulate the disk, along with i/o details.
The library will act as the kernel and the main executable will "boot" into the "kernel" from there the kernel will be responsible for all further execution.
The result is effectively a swap in the roles between the executable and the library, where the host-executable acts as a library and the host-library acts as the executable.
To enable this to work the host-executable or "virtual hardware" will pass a context to the library in it's main function. This context will contain function pointers to the basic resources provided by the executable. From there, the kernel will execute its main function, and upon exiting the main function, the virtual hardware will perform any cleanup of basic resources and then exit to the host operating system.
Basic buffers for ram, disk, audio, and i/o will be provided by the virtual hardware, and the kernel will be free to use them as necessary to perform any further operation.
As this is all a virtual-environment, and everything will be written in native zig code. There is nothing stopping the "kernel" developer and/or the "application" developer to access the host environment. However, for the best learning results it is strongly recommended that all operations happen within the resources provided by the virtual-environment. This is all under the honor system, and best judgement is recommended. After all, it is your system to do with as you please.
While resources are limited, there is no need to re-implement the wheel with everything, and zig is a particularly good choice for a project like this because of the emphasis on allocators. Once the initial allocator is implemented to work within the RAM buffer (the std.FixedBufferAllocator could be used here but memory management is one of the learning goals for this project), all of the zig standard library should "just work" when provided with that allocator, and there should be no need to re-implement lists, hashmaps, string manipulation, etc.

