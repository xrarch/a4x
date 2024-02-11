;
; Contains low level reset code for the ROM.
;

.section text

.extern FwxExceptionVector
.extern FwReset

;vector 0 - nothing
    j    FwxExceptionVector

.align 256
;vector 1 - interrupt
    j    FwxExceptionVector

.align 256
;vector 2 - syscall
    j    FwxExceptionVector

.align 256
;vector 3 - nothing
    j    FwxExceptionVector

.align 256
;vector 4 - bus error
    j    FwxExceptionVector

.align 256
;vector 5 - NMI
    j    FwxExceptionVector

.align 256
;vector 6 - breakpoint
    j    FwxExceptionVector

.align 256
;vector 7 - illegal instruction
    j    FwxExceptionVector

.align 256
;vector 8 - privilege violation
    j    FwxExceptionVector

.align 256
;vector 9 - unaligned address
    j    FwxExceptionVector

.align 256
;vector 10 - nothing
    j    FwxExceptionVector

.align 256
;vector 11 - nothing
    j    FwxExceptionVector

.align 256
;vector 12 - page fault read
    j    FwxExceptionVector

.align 256
;vector 13 - page fault write
    j    FwxExceptionVector

.align 256
;vector 14 - nothing
    j    FwxExceptionVector

.align 256
;vector 15 - nothing
    j    FwxExceptionVector

.align 256

FwxReset:
    ; Invalidate the caches.

    li   t0, 3
    mtcr icachectrl, t0
    mtcr dcachectrl, t0

    ; If we aren't processor zero, go to the MP corrall and wait for an IPI.

    mfcr t0, whami
    bne  t0, .mp_corrall

    ; Reset EBUS to quiescent state.

    la   t0, 0xAABBCCDD
    mov  long [0xF8800000], t0, tmp=t1

    ; Set the initial stack pointer.

    li   sp, 0x2000

    ; Set the exception block.

    lui  t0, zero, 0xFFFE0000
    mtcr eb, t0

    j    FwReset

.mp_corrall:
    hlt
    b    .mp_corrall

.ds "XR/17032 BootROM, by Will"

.section bss