.data
prompt: .asciiz "Enter n: "  # Prompt message for user input
result: .asciiz "Fib(n) = "  # Message to display result
.text
.globl main

main:
    # Print prompt message
    li $v0, 4
    la $a0, prompt
    syscall

    # Read integer input from user
    li $v0, 5
    syscall
    move $a0, $v0  # Move user input to $a0

    # Call fibonacci function
    jal fibonacci
    move $t0, $v0  # Store result in $t0

    # Print result message
    li $v0, 4
    la $a0, result
    syscall

    # Print Fibonacci result
    li $v0, 1
    move $a0, $t0
    syscall

    # Exit program
    li $v0, 10
    syscall

fibonacci:
    # Function prologue - save return address and registers
    addi $sp, $sp, -12   # Allocate stack space
    sw $ra, 0($sp)       # Save return address
    sw $s0, 4($sp)       # Save register $s0 (a)
    sw $s1, 8($sp)       # Save register $s1 (b)

    # Base case: if n <= 1, return n directly
    ble $a0, 1, return_n

    # Initialize variables
    li $s0, 0   # a = 0 (first Fibonacci number)
    li $s1, 1   # b = 1 (second Fibonacci number)
    addi $a0, $a0, -1  # n - 1 (loop counter)

loop:
    beq $a0, 0, end_loop  # If counter reaches 0, exit loop
    move $t0, $s1         # temp = b (store old b)
    add $s1, $s0, $s1     # b = a + b (next Fibonacci number)
    move $s0, $t0         # a = temp (update a)
    addi $a0, $a0, -1     # Decrement loop counter
    j loop                # Repeat loop

end_loop:
    move $v0, $s1  # Store final Fibonacci result in $v0
    j exit_fib     # Jump to function exit

return_n:
    move $v0, $a0  # Return n directly if n <= 1

exit_fib:
    # Function epilogue - restore saved registers and return
    lw $ra, 0($sp)  # Restore return address
    lw $s0, 4($sp)  # Restore $s0 (a)
    lw $s1, 8($sp)  # Restore $s1 (b)
    addi $sp, $sp, 12  # Free stack space
    jr $ra  # Return to caller