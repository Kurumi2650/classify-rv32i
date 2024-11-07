.globl relu

.text
# ==============================================================================
# FUNCTION: Array ReLU Activation
#
# Applies ReLU (Rectified Linear Unit) operation in-place:
# For each element x in array: x = max(0, x)
#
# Arguments:
#   a0: Pointer to integer array to be modified
#   a1: Number of elements in array
#
# Returns:
#   None - Original array is modified directly
#
# Validation:
#   Requires non-empty array (length ≥ 1)
#   Terminates (code 36) if validation fails
#
# Example:
#   Input:  [-2, 0, 3, -1, 5]
#   Result: [ 0, 0, 3,  0, 5]
# ==============================================================================
relu:
    li t0, 1             # t0 = 1
    blt a1, t0, error    # If a1 < 1, jump to error
    li t1, 0             # t1 = 0 (loop counter)

loop_start:
    slli t2, t1, 2       # t2 = t1 * 4 (byte offset)
    add t2, a0, t2       # t2 = address of a0[t1]
    lw t3, 0(t2)         # t3 = a0[t1]

    blt t3, zero, set_zero   # If t3 < 0, set to zero
    j store_value

set_zero:
    li t3, 0

store_value:
    sw t3, 0(t2)         # a0[t1] = t3

    addi t1, t1, 1       # t1++
    blt t1, a1, loop_start  # If t1 < a1, continue loop

exit:
    ret                # Return from function

error:
    li a0, 36          
    j exit      
