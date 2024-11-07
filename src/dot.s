.globl dot

.text
# =======================================================
# FUNCTION: Strided Dot Product Calculator
#
# Calculates sum(arr0[i * stride0] * arr1[i * stride1])
# where i ranges from 0 to (element_count - 1)
#
# Args:
#   a0 (int *): Pointer to first input array
#   a1 (int *): Pointer to second input array
#   a2 (int):   Number of elements to process
#   a3 (int):   Skip distance in first array
#   a4 (int):   Skip distance in second array
#
# Returns:
#   a0 (int):   Resulting dot product value
#
# Preconditions:
#   - Element count must be positive (>= 1)
#   - Both strides must be positive (>= 1)
#
# Error Handling:
#   - Exits with code 36 if element count < 1
#   - Exits with code 37 if any stride < 1
# =======================================================

dot:
    # Prologue: Save callee-saved registers
    addi sp, sp, -32         # Make space on the stack
    sw ra, 28(sp)            # Save return address
    sw s0, 24(sp)            # Save s0
    sw s1, 20(sp)            # Save s1
    sw s2, 16(sp)            # Save s2
    sw s3, 12(sp)            # Save s3
    sw s4, 8(sp)             # Save s4
    sw s5, 4(sp)             # Save s5
    sw s6, 0(sp)             # Save s6

    li t0, 1                   # t0 = 1 for comparisons
    blt a2, t0, error_terminate    # If element_count < 1, error
    blt a3, t0, error_terminate    # If stride0 < 1, error
    blt a4, t0, error_terminate    # If stride1 < 1, error

    li t0, 0                   # t0 will hold the accumulated sum
    li t1, 0                   # t1 is the loop index i

    # Initialize pointers and strides in bytes
    mv t2, a0                  # t2 = current address in arr0
    mv t3, a1                  # t3 = current address in arr1

    slli t4, a3, 2             # t4 = stride0 * 4 (bytes)
    slli t5, a4, 2             # t5 = stride1 * 4 (bytes)

loop_start:
    bge t1, a2, loop_end       # If i >= element_count, exit loop

    # Load values from arr0 and arr1
    lw t6, 0(t2)               # t6 = arr0[i * stride0]
    lw s0, 0(t3)               # s0 = arr1[i * stride1]

    # Begin multiplication without 'mul' instruction
    # Determine signs of t6 and s0
    slt s1, t6, zero           # s1 = 1 if t6 < 0, 0 otherwise
    slt s2, s0, zero           # s2 = 1 if s0 < 0, 0 otherwise

    # Determine the sign of the result
    xor s3, s1, s2             # s3 = s1 XOR s2 (1 if result is negative)

    # Compute absolute values
    bge t6, zero, skip_abs_t6
    neg t6, t6                 # t6 = -t6
skip_abs_t6:
    bge s0, zero, skip_abs_s0
    neg s0, s0                 # s0 = -s0
skip_abs_s0:

    # Initialize product accumulator
    li s4, 0                   # s4 will hold the product

mult_loop:
    beq s0, zero, mult_end     # If multiplier is zero, end multiplication
    andi s5, s0, 1             # s5 = s0 & 1
    beq s5, zero, skip_add
    add s4, s4, t6             # s4 += t6
skip_add:
    slli t6, t6, 1              # t6 <<= 1
    srli s0, s0, 1             # s0 >>= 1 (logical shift right)
    j mult_loop
mult_end:

    # Adjust the sign of the product
    beq s3, zero, skip_negate
    neg s4, s4                 # If result is negative, negate s4
skip_negate:

    # Add product to the sum
    add t0, t0, s4             # t0 += s4

    # Increment pointers
    add t2, t2, t4             # t2 += stride0 * 4
    add t3, t3, t5             # t3 += stride1 * 4

    # Increment loop index
    addi t1, t1, 1             # i += 1
    j loop_start               # Repeat the loop

loop_end:
    mv a0, t0                  # Move the result into a0

    # Epilogue: Restore callee-saved registers and return
    lw ra, 28(sp)              # Restore return address
    lw s0, 24(sp)              # Restore s0
    lw s1, 20(sp)              # Restore s1
    lw s2, 16(sp)              # Restore s2
    lw s3, 12(sp)              # Restore s3
    lw s4, 8(sp)               # Restore s4
    lw s5, 4(sp)               # Restore s5
    lw s6, 0(sp)               # Restore s6
    addi sp, sp, 32            # Restore stack pointer
    jr ra                      # Return to caller

error_terminate:
    blt a2, t0, set_error_36   # If element_count < 1, set error code 36
    li a0, 37                  # Exit code 37 for invalid stride
    j exit

set_error_36:
    li a0, 36                  # Exit code 36 for invalid element count
    j exit

exit:
    li a7, 10                  # Syscall code for exit
    ecall                      # Exit the program
