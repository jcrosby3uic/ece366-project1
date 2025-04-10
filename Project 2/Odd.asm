.data
.text
.globl main

# --------------------
# Function: is_odd
# Determines if a number is odd using repeated subtraction
# Input : $t1 = n
# Output: $t2 = 1 if odd, 0 if even
# --------------------

main:
    # Simulate input (e.g., n = 6)
    li $t1, 9              # Store input number in $t1

    # Move input into $a0 again for is_odd function call
    move $a0, $t1          # $a0 = input n (again)
    jal is_odd             # Call is_odd function
    move $t2, $v0          # $t3 will hold 1 if odd, 0 if even

    # Program ends here
    j end_program

is_odd:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)

check_loop:
    beq $a0, 0, is_even    # if number reduced to 0 -> even
    beq $a0, 1, is_odd_ret # if number reduced to 1 -> odd
    addi $a0, $a0, -2      # subtract 2
    j check_loop           # continue loop

is_even:
    li $v0, 0              # even
    j end_is_odd

is_odd_ret:
    li $v0, 1              # odd

end_is_odd:
    lw $ra, 0($sp)         # restore return address
    addi $sp, $sp, 4       # deallocate stack space
    jr $ra                 # return to caller

end_program:
    nop                    # Placeholder for program end
