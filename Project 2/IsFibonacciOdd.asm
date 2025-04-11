.data
.text
.globl main

# --------------------
# Function: IsFibonacciOdd
# Returns 1 if the Nth fibonacci number is odd, 0 if not
# Input : $t1 = n
# Output: $t2 = IsFibonacciOdd(n)
# --------------------

main:
    # Simulate input (e.g., n = 7 -> 13 (odd))
    li $t1, 7              # Store input number in $t1

    # Move input into $a0 for function call
    move $a0, $t1          # $a0 = input n

    # Call fibonacci function
    jal fibonacci          # Jump and link to fibonacci

    move $a0, $v0          # move the fibonacci number to $a0
    
    jal is_odd             # run is odd function

    # Move result from $v0 to register (simulate output)
    move $t2, $v0          # $t2 will hold 1 if the Nth fibonacci number is odd, and 0 otherwise.

    # Program ends here 
    j end_program


# --------------------
# Function: fibonacci
# Calculates the nth Fibonacci number iteratively
# Input : $t1 = n
# Output: $t2 = Fibonacci(n)
# --------------------

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

# --------------------
# Function: is_odd
# Determines if a number is odd using repeated subtraction
# Input : $t1 = n
# Output: $t2 = 1 if odd, 0 if even
# --------------------

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

