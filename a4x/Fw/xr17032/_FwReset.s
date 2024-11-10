// 
//  Contains low level reset code for the ROM.
// 

.section text

.extern FwxExceptionVector
.extern FwProcessorStartup
.extern FwReset

// vector 0 - nothing
    j    FwxExceptionVector

.align 256
// vector 1 - interrupt
    j    FwxExceptionVector

.align 256
// vector 2 - syscall
    j    FwxExceptionVector

.align 256
// vector 3 - nothing
    j    FwxExceptionVector

.align 256
// vector 4 - bus error
    j    FwxExceptionVector

.align 256
// vector 5 - NMI
    j    FwxExceptionVector

.align 256
// vector 6 - breakpoint
    j    FwxExceptionVector

.align 256
// vector 7 - illegal instruction
    j    FwxExceptionVector

.align 256
// vector 8 - privilege violation
    j    FwxExceptionVector

.align 256
// vector 9 - unaligned address
    j    FwxExceptionVector

.align 256
// vector 10 - nothing
    j    FwxExceptionVector

.align 256
// vector 11 - nothing
    j    FwxExceptionVector

.align 256
// vector 12 - page fault read
    j    FwxExceptionVector

.align 256
// vector 13 - page fault write
    j    FwxExceptionVector

.align 256
// vector 14 - nothing
    j    FwxExceptionVector

.align 256
// vector 15 - nothing
    j    FwxExceptionVector

.align 256

//  We should now be at 0xFFFE1000, the reset vector.

FwxReset:
.global FwxReset
    // Zero out RS.

    mtcr rs, zero

    // Invalidate the caches.

    li   t0, 3
    mtcr icachectrl, t0
    mtcr dcachectrl, t0

    // Set our exception block.

    lui  t0, zero, 0xFFFE0000
    mtcr eb, t0

    // If we aren't processor zero, go to the MP corrall and wait for an IPI.

    mfcr t0, whami
    bne  t0, .mp_corrall

    // Reset EBUS to quiescent state.

    la   t0, 0xAABBCCDD
    mov  long [0xF8800000], t0, tmp=t1

    // Set the initial stack pointer to 1024 bytes.

    li   sp, 0x400

    j    FwReset

.mp_corrall:
    // Set the stack pointer to 0x400 + (384 * id).

    li   sp, 0x400
    add  sp, sp, t0 LSH 8 //  + 256 * id
    add  sp, sp, t0 LSH 7 //  + 128 * id

    mov  a0, t0
    j    FwProcessorStartup

FwxEnableInterrupts:
.global FwxEnableInterrupts
    mfcr t0, rs
    ori  t0, t0, 2
    mtcr rs, t0
    ret

FwxGetProcessorId:
.global FwxGetProcessorId
    mfcr a3, whami
    ret

FwxHalt:
.global FwxHalt
    hlt
    ret

FwxFlushWriteBuffer:
.global FwxFlushWriteBuffer
    wmb
    ret

FwxMemoryBarrier:
.global FwxMemoryBarrier
    mb
    ret

FwxSweepDcache:
.global FwxSweepDcache
    li   t0, 3
    mtcr dcachectrl, t0
    ret

FwxSweepIcache:
.global FwxSweepIcache
    li   t0, 3
    mtcr icachectrl, t0
    ret

FwxJumpToA3X:
.global FwxJumpToA3X
    mtcr rs, zero
    la   sp, 0x4000
    jr   a0

FwxWaitForIpis:
.global FwxWaitForIpis
.loop:
    hlt
    b    .loop

FwxProbeUlong:
.global FwxProbeUlong
    mov  t0, long [a0]
    ret

.ds "XR/17032 BootROM, by Will"

.section data

.section bss