 .data

# array terminated by 0 (which is not part of the array)
xarr:
   .word 1
   .word 2
   .word 3
   .word 4
   .word 10
   .word 11
   .word 12
   .word 13
   .word 14
   .word 16
   .word 18
   .word 20
   .word 24
   .word 0

   .text

# main(): ##################################################
#   uint* j = xarr
#   while (*j != 0):
#     printf(" %d\n", fibonacci(*j))
#     j++
main:
   li   $sp, 0x7ffffffc    # initialize $sp

   # PROLOGUE
   subu $sp, $sp, 8        # expand stack by 8 bytes
   sw   $ra, 8($sp)        # push $ra (ret addr, 4 bytes)
   sw   $fp, 4($sp)        # push $fp (4 bytes)
   addu $fp, $sp, 8        # set $fp to saved $ra

   subu $sp, $sp, 8        # save s0, s1 on stack before using them
   sw   $s0, 8($sp)        # push $s0
   sw   $s1, 4($sp)        # push $s1

   la   $s0, xarr          # use s0 for j. init to xarr
main_while:
   lw   $s1, ($s0)         # use s1 for *j
   beqz $s1, main_end      # if *j == 0 go to main_end
   move $a0, $s1
   jal  fibonacci          # result = fibonacci(*j)
   move $a0, $v0           # print_int(result)
   li   $v0, 1
   syscall
   li   $a0, 10            # print_char('\n')
   li   $v0, 11
   syscall
   addu $s0, $s0, 4        # j++
   b    main_while
main_end:
   lw   $s0, -8($fp)       # restore s0
   lw   $s1, -12($fp)      # restore s1

   # EPILOGUE
   move $sp, $fp           # restore $sp
   lw   $ra, ($fp)         # restore saved $ra
   lw   $fp, -4($sp)       # restore saved $fp
   j    $ra                # return to kernel
## end main ##################################################fibonacci:
   #PROLOGUE
   subu $sp, $sp, 16         #grows stack by 8 bytes
   sw   $ra, 16($sp)         #move return value to top of stack 
   sw   $fp, 12($sp)         #save frame pointer
   sw   $s0, 8($sp)          #push s0 for n-1
   sw   $s1, 4($sp)          #push s1 for n-2
   addu $fp, $sp, 16         #set $fp to saved $ra

   #BODY
   lw   $s0, 8($fp)          #access variable for fib(n-1)
   lw   $s1, 4($fp)          #access variable for fib(n-2)

   move $s0, $a0             #store n in $s0 
   li   $t1, 1               #store temp variable for 1
   beq  $s0, $zero,return0   #if n == 0 then return 0
   beq  $s0, $t1, return1    #if n == 1 then return 1

   addi $a0, $s0, -1         #a0 =  n - 1 (a0,s0,-1)

   jal  fibonacci            #$v0 = fib( n-1)

   add  $s1, $zero, $v0      #stores temp return for fib(n-1)
   addi $a0, $s0, -2         #deincrements n by 2

   jal fibonacci             #$v0 = fib(n-2)

   add  $v0, $v0, $s1        #$v0 = fib(n-2) + fib(n-1)
   j    exit_fib             #finished fibonacci call

exit_fib:
   lw   $s0, 8($sp)          #pop local from stack
   lw   $s1, 4($sp)          #pop local from stack
   j    quit                 #exits fibonacci process

return1:
   li   $v0, 1               #return 1 case
   j    exit_fib             #ends recursive call 

return0:
   li   $v0, 0               #return 0 case
   j    exit_fib             #ends recursive call

quit:
   #EPILOGUE
   move $sp, $fp             #restore sp
   lw   $ra, ($fp)           #restore saved $ra
   lw   $fp, -4($sp)         #restore saved $fp
   jr   $ra                  #return to stack

