
README
Josh Crosby jcrosby3@uic.edu
Scott Kwok skwok7@uic.edu
Leopold Serpe lserp2@uic.edu

Project 2 Submission:

How to Run Fib & Odd Functions:
1. Change input within main function (there will be a comment saying this is input n, should be stored in register $t1)
2. Assemble & run program
3. Result stored in $t2 (can read using MARs)

Summary:
Problem 1 involves creating a function using MIPS (assembly) that computes
if the nth fibonacci number is odd. Our implementation mirrors the C code, we
have a fibonacci subroutine that automatically enters a loop subroutine directly below it. 
The number of executions needed is computed in $a0, the looping continues until the counter
reaches 0, at which point there is a jump to the end subroutine end_loop which stores the 
final result in $t2.

Contributions:
All team members met virtually to contribute to the project's code. Jcrosby is the primary 
author of the MIPS file and pushed to the github. lserp2 and skowk7 are the primary authors
 of this README file.
 
 Link:
 https://github.com/jcrosby3uic/ece366-project1/blob/main/Project%202/fib.asm
 
