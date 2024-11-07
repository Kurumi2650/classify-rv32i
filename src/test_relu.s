# test_relu.s - Test program for relu.s function using modified ecall method
    .import relu.s
    .globl _start        # Define global entry point

    .data
# Define the array (matrix) in static memory
array:
    .word -2, 0, 3, -1, 5   # Test array to apply ReLU

    .text
_start:
    # Store array address and length in temporary registers to preserve a0 and a1 for syscalls
    la t5, array          # t5 = address of the array
    li t6, 5              # t6 = number of elements in the array

    # Print original array (before applying ReLU)
    li t0, 0              # Index counter
    # Print "Before ReLU:\n" message
    la a1, before_msg     # Load address of message into a1
    addi a0, x0, 4        # Syscall code for print_string
    ecall                 # Execute syscall

print_before:
    bge t0, t6, call_relu # If we've printed all elements, proceed
    slli t2, t0, 2        # Offset = t0 * 4 (size of int)
    add t3, t5, t2        # Address of array[t0]
    lw t1, 0(t3)          # Load array[t0] into t1
    mv a1, t1             # Move value to a1 for printing
    addi a0, x0, 1        # Syscall code for print_int
    ecall                 # Print the integer
    addi a1, x0, 32       # ASCII code for space character
    addi a0, x0, 11       # Syscall code for print_char
    ecall                 # Print a space
    addi t0, t0, 1        # Increment index
    j print_before        # Loop to print all elements

call_relu:
    # Set up arguments for relu function
    mv a0, t5             # a0 = address of the array
    mv a1, t6             # a1 = number of elements
    jal ra, relu          # Call the relu function

    # Print modified array (after applying ReLU)
    li t0, 0              # Reset index counter
    # Print "After ReLU:\n" message
    la a1, after_msg      # Load address of message into a1
    addi a0, x0, 4        # Syscall code for print_string
    ecall                 # Execute syscall

print_after:
    bge t0, t6, end       # If all elements printed, exit
    slli t2, t0, 2        # Offset = t0 * 4
    add t3, t5, t2        # Address of array[t0]
    lw t1, 0(t3)          # Load array[t0] into t1
    mv a1, t1             # Move value to a1 for printing
    addi a0, x0, 1        # Syscall code for print_int
    ecall                 # Print the integer
    addi a1, x0, 32       # ASCII code for space character
    addi a0, x0, 11       # Syscall code for print_char
    ecall                 # Print a space
    addi t0, t0, 1        # Increment index
    j print_after         # Loop to print all elements

end:
    # Exit the program
    addi a0, x0, 17       # Syscall code for exit (as per your example)
    addi a1, x0, 0        # Exit code (optional)
    ecall                 # Execute syscall

    # Messages to display
    .data
before_msg:
    .asciiz "Before ReLU:\n"
after_msg:
    .asciiz "\nAfter ReLU:\n"
