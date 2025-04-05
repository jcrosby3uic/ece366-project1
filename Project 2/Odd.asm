.data
prompt:     .asciiz "Enter a number: "
true_msg:   .asciiz "true\n"
false_msg:  .asciiz "false\n"

.text
.globl main

main:
    # Print prompt to user
    li $v0, 4                # syscall 4 = print string
    la $a0, prompt           # load address of prompt
    syscall

    # Read user input (integer)
    li $v0, 5                # syscall 5 = read int
    syscall
    move $t0, $v0            # store input in $t0

    # Copy input for subtraction
    move $t1, $t0            # working copy in $t1

loop:
    # If $t1 >= 2, subtract 2 (for positive numbers)
    bge $t1, 2, subtract_pos

    # If $t1 < 0, add 2 (for negative numbers)
    blt $t1, 0, subtract_neg

    # If $t1 is now 0 or 1, we can decide even/odd
    j check_result

subtract_pos:
    subi $t1, $t1, 2         # $t1 = $t1 - 2
    j loop

subtract_neg:
    addi $t1, $t1, 2         # $t1 = $t1 + 2
    j loop

check_result:
    # If remainder is 1 -> odd -> print "true"
    beq $t1, 1, print_true

    # Otherwise -> even -> print "false"
    j print_false

print_true:
    li $v0, 4                # syscall 4 = print string
    la $a0, true_msg         # load address of "true"
    syscall
    j end

print_false:
    li $v0, 4                # syscall 4 = print string
    la $a0, false_msg        # load address of "false"
    syscall

end:
    li $v0, 10               # syscall 10 = exit
    syscall
