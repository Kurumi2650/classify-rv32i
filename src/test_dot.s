.import dot.s
.globl _start

.data
# Define the vectors
v0: .word 1, 2, 3      # Vector v0
v1: .word 1, 3, 5      # Vector v1

result_msg: .asciiz "The dot product is: "

.text
_start:
    # Store vector addresses in temporary registers
    la t0, v0                # t0 = address of v0
    la t1, v1                # t1 = address of v1

    # Set up arguments for 'dot' function
    mv a0, t0                # a0 = address of first vector (v0)
    mv a1, t1                # a1 = address of second vector (v1)
    li a2, 3                 # a2 = number of elements (3)
    li a3, 1                 # a3 = stride0 (1)
    li a4, 1                 # a4 = stride1 (1)

    # Call 'dot' function
    jal ra, dot              # Jump and link to 'dot'

    # After returning, 'a0' contains the result

    # Print the result message
    mv t0, a0                # Move result to t0 to preserve it
    la a1, result_msg        # Load address of result message into a1
    li a0, 4                 # Syscall code for print_string
    ecall                    # Print the message

    # Print the result (in a0)
    mv a1, t0                # Move result to a1 for printing
    li a0, 1                 # Syscall code for print_int
    ecall                    # Print the integer

    # Exit the program
    li a0, 17                # Syscall code for exit
    li a1, 0                 # Exit code
    ecall                    # Terminate program