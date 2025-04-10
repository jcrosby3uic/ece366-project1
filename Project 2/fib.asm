.data
.text
.globl main

# --------------------
# Function: fibonacci
# Calculates the nth Fibonacci number iteratively
# Input : $t1 = n
# Output: $t2 = Fibonacci(n)
# --------------------

main:
    # Simulate input (e.g., n = 6)
    li $t1, 6              # Store input number in $t1

    # Move input into $a0 for function call
    move $a0, $t1          # $a0 = input n

    # Call fibonacci function
    jal fibonacci          # Jump and link to fibonacci

    # Move result from $v0 to register (simulate output)
    move $t2, $v0          # $t2 will hold the result of Fibonacci(n)

    # Program ends here 
    j end_program

fibonacci:
    # Function prologue - save return address and registers
    addi $sp, $sp, -12     # make space on stack for 3 words
    sw $ra, 0($sp)         # save return address
    sw $s0, 4($sp)         # save $s0 (used for 'a')
    sw $s1, 8($sp)         # save $s1 (used for 'b')

    # Base case: if n <= 1, return n directly
    ble $a0, 1, return_n   # if n <= 1, skip loop and return n

    # Initialize Fibonacci values
    li $s0, 0              # a = 0
    li $s1, 1              # b = 1
    addi $a0, $a0, -1      # loop counter = n - 1

# Loop to calculate Fibonacci iteratively
loop:
    beq $a0, 0, end_loop   # if counter is 0, end loop
    move $t0, $s1          # temp = b
    add $s1, $s0, $s1      # b = a + b
    move $s0, $t0          # a = temp
    addi $a0, $a0, -1      # decrement loop counter
    j loop                 # repeat loop

end_loop:
    move $v0, $s1          # result = b (Fibonacci number)
    j exit_fib             # jump to function epilogue

return_n:
    move $v0, $a0          # return n directly for base case

# Function epilogue - restore registers and return
exit_fib:
    lw $ra, 0($sp)         # restore return address
    lw $s0, 4($sp)         # restore $s0 (a)
    lw $s1, 8($sp)         # restore $s1 (b)
    addi $sp, $sp, 12      # deallocate stack space
    jr $ra                 # return to caller

end_program:
    nop                    # Placeholder for program end
