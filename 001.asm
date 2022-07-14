# ARM assembly Tutorial 001

.global _start
.section .text

_start:
    # Enter a value printed to screen
    mov r7, #0x4
    mov r0, #1
    ldr r1, =seek_msg
    mov r2, #14
    swi 0
    # reads the value as a character in ascii
    mov r7, #0x3
    mov r0, #0
    ldr r1, =var
    mov r2, #1
    swi 0
    # prints the value is:
    mov r7, #0x4
    mov r0, #1
    ldr r1, =print_msg
    mov r2, #14
    swi 0
    # prints the value
    mov r7, #0x4
    mov r0, #1
    ldr r1, =var
    mov r2, #1
    swi 0
    # exits the code.
    mov r7, #0x1
    mov r0, #65
    swi 0

.section .data
    seek_msg:
    .ascii "Enter a value\n"
    var:
    .ascii " "
    print_msg:
    .ascii "The value is: "
