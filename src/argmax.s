.globl argmax

.text
# =================================================================
# FUNCTION: Maximum Element First Index Finder
#
# Scans an integer array to find its maximum value and returns the
# position of its first occurrence. In cases where multiple elements
# share the maximum value, returns the smallest index.
#
# Arguments:
#   a0 (int *): Pointer to the first element of the array
#   a1 (int):  Number of elements in the array
#
# Returns:
#   a0 (int):  Position of the first maximum element (0-based index)
#
# Preconditions:
#   - Array must contain at least one element
#
# Error Cases:
#   - Terminates program with exit code 36 if array length < 1
# =================================================================
argmax:
    li t6, 1
    blt a1, t6, handle_error

    lw t0, 0(a0)       # t0 = max_value = array[0]
    li t1, 0           # t1 = max_index = 0
    li t2, 1           # t2 = current index = 1

loop_start:
    bge t2, a1, end   # if current index >= array length, end

    slli t3, t2, 2     # t3 = t2 * 4
    add  t4, a0, t3    # t4 = address of array[t2]
    lw   t5, 0(t4)     # t5 = array[t2]

    blt t0, t5, update_max
    j next_element

update_max:
    mv  t0, t5          # t0 = max_value = array[t2]
    mv  t1, t2          # t1 = max_index = t2

next_element:
    addi t2, t2, 1      # t2 = t2 + 1
    j loop_start

end:
    mv a0, t1           # Return the index in a0
    ret
    
handle_error:
    li a0, 36
    j exit
    
exit:
    li a7, 10
    ecall
