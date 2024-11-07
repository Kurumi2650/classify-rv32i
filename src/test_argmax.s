.import argmax.s
.globl _start

.data

array:
    .word 9, 1, 7, 7, 8  # Test array

result_msg:
    .asciiz "The index of the maximum element is: "

.text

_start:
    # Store array address and length in temporary registers
    la  t5, array        # t5 = address of the array
    li  t6, 5            # t6 = number of elements in the array

    # Set up arguments for argmax function
    mv  a0, t5           # a0 = address of the array
    mv  a1, t6           # a1 = number of elements

    jal ra, argmax       # Call the argmax function

    # After return, a0 contains the index of the max element
    # Print the result message
    mv t0, a0
    la a1, result_msg    # Load address of result message into a1
    addi a0, x0, 4       # Syscall code for print_string
    ecall                # Print the message

    # Print the index
    mv a1, t0            # Move the result (index) to a1
    addi a0, x0, 1       # Syscall code for print_int
    ecall                # Print the index

    # Exit the program
    addi a0, x0, 17      # Syscall code for exit
    addi a1, x0, 0       # Exit code (optional)
    ecall                # Terminate program
