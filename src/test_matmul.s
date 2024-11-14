.import matmul.s
.globl _start

.data
# Define matrices
matrix_m0:
    .word 1, 2, 3
    .word 4, 5, 6
    .word 7, 8, 9

matrix_m1:
    .word 1, 2, 3
    .word 4, 5, 6
    .word 7, 8, 9

matrix_result:
    .word 0, 0, 0
    .word 0, 0, 0
    .word 0, 0, 0

result_msg: .asciiz "The result matrix is:\n"
row_delim: .asciiz "\n"

.text
_start:
    # Load matrix arguments
    la a0, matrix_m0          # Address of M0
    li a1, 3                  # Rows of M0
    li a2, 3                  # Columns of M0

    la a3, matrix_m1          # Address of M1
    li a4, 3                  # Rows of M1
    li a5, 3                  # Columns of M1

    la a6, matrix_result      # Address of result matrix

    # Call matmul
    jal matmul                # Perform M0 * M1 = matrix_result

    # Print result message
    la a1, result_msg         # Load address of result message
    li a0, 4                  # Syscall code for print_string
    ecall                     # Print the message

    # Print the result matrix
    la t0, matrix_result      # Base address of result matrix
    li t1, 3                  # Number of rows
    li t2, 3                  # Number of columns

    li t3, 0                  # Row counter

print_rows:
    bge t3, t1, done          # If all rows are printed, exit
    li t4, 0                  # Reset column counter

print_columns:
    bge t4, t2, next_row      # If all columns are printed, go to next row

    # Print the matrix element
    lw a1, 0(t0)              # Load current matrix element
    li a0, 1                  # Syscall code for print_int
    ecall                     # Print integer

    # Print space after the integer
    li a1, 32                 # ASCII for space
    li a0, 11                 # Syscall code for print_char
    ecall                     # Print space

    # Advance to the next element
    addi t4, t4, 1            # Increment column counter
    addi t0, t0, 4            # Move to the next element in memory
    j print_columns           # Continue printing columns

next_row:
    # Print a newline after the row
    la a1, row_delim          # Address of newline string
    li a0, 4                  # Syscall code for print_string
    ecall                     # Print newline

    addi t3, t3, 1            # Increment row counter
    j print_rows              # Continue printing rows

done:
    # Exit the program
    li a0, 10                 # Syscall code for exit
    ecall                     # Exit the program
