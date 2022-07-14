.section .text

.global _start

//; r0 = buffer to write to
//; r1 = number of bytes to read
read_user_input:
    push {lr}
    push {r4-r11}
    push {r1}
    push {r0}
    mov r7, #0x3
    mov r0, #0x0
    pop {r1}
    pop {r2}
    svc 0x0
    pop {r4-r11}
    pop {pc}

//; r0 = pointer to the string of ascii numbers
my_atoi:
    push {lr}
    push {r4-r11}
    mov r2, #0x0 //; strlength counter
    mov r5, #0x0 //; end state counter variable
    mov r6, #1
    mov r7, #10

_string_length_loop:
    ldrb r8, [r0]
    cmp r8, #0xa
    beq _count
    add r0, r0, #1
    add r2, r2, #1
    b _string_length_loop

_count:
    sub r0, r0, #1
    ldrb r8, [r0] //; first number in the string
    sub r8, r8, #0x30 //; subtrcting hex 30 from any number gives the real number instead of ascii
    mul r4, r8, r6 //; current place times the number
    mov r8, r4
    mul r4, r6, r7
    mov r6, r4
    add r5, r5, r8 //; add current number to counter
    sub r2, r2, #1 //; decrement length to check for end
    cmp r2, #0x0
    beq _leave
    b _count

_leave:   
    mov r0, r5


    pop {r4-r11}
    pop {pc}

int_to_string:
    push {lr}
    push {r4-r11}
    mov r2, #0x0 
    mov r3, #1000
    mov r7, #10

_loop:
    mov r4, #0x0
    udiv r4, r0, r3
    add r4, r4, #48

    ldr r5, =sum //; store ascii number in sum
    add r5, r5, r2 //; add the current digit to the sum 
    strb r4, [r5] //; store the current digit in the sum
    add r2, r2, #1 //; increment the digit counter

    sub r4, r4, #48 //; convert the ascii number to a number
    mul r6, r4, r3 //; multiply the current digit by the current place
    sub r0, r0, r6 //; subtract the current digit from the number

    udiv r6, r3, r7 //; divide by 10
    mov r3, r6 //; set the new divisor
    cmp r3, #0 //; check if the divisor is 10
    beq _leave_int_to_string
    b _loop

_leave_int_to_string:
    mov r4, #0xa //; newline
    ldr r5, =sum //; store ascii number in sum
    add r5, r5, r2 //; add the current digit to the sum
    add r5, r5, #1 //; add the newline to the sum
    strb r4, [r5] //; store the newline in the sum
    pop {r4-r11}
    pop {pc}

display:
    push {lr}
    push {r4-r11}

    mov r7, #0x4
    mov r0, #0x1
    ldr r1, =sum //; load the sum into r1
    mov r2, #0x8
    svc 0x0

    pop {r4-r11}
    pop {pc}

_start:
    //; read user input
    ldr r0, =first
    ldr r1, =#0x6
    bl read_user_input

    ldr r0, =second
    ldr r1, =#0x6 
    bl read_user_input

    //; convert string to number
    ldr r0, =first
    bl my_atoi
    mov r4, r0

    ldr r0, =second
    bl my_atoi
    mov r5, r0

    //; add the numbers
    add r0, r4, r5
    bl int_to_string

    //; display
    bl display

    mov r0, #0x0
    mov r7, #0x1
    svc 0x0


.section .data
first:
    .skip 8
second:
    .skip 8
sum:
    .skip 8
