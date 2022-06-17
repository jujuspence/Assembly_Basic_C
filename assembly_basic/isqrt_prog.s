 .data

# array terminated by 0 (which is not part of the array)
xarr:
   .word 1
   .word 12
   .word 225
   .word 169
   .word 16
   .word 25
   .word 100
   .word 81
   .word 99
   .word 121
   .word 144
   .word 0 

   .text

# main(): ##################################################
#   uint* j = xarr
#   while (*j != 0):
#     printf(" %d\n", isqrt(*j))
#     j++
main:
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
   move $a0, $s1           # result (in v0) = isqrt(*j)
   jal  isqrt              # 
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
# end main ##################################################isqrt:
   #PROLOGUE
   subu $sp, $sp, 20         #grow stack by 8 bytes
   sw   $ra, 20($sp)         #push $ra
   sw   $fp, 16($sp)         #push $fp
   sw   $s0, 12($sp)         #push n
   sw   $s1, 8($sp)          #push small var
   sw   $s2, 4($sp)          #push large var
   addu $fp,$sp, 20          #set $fp to saved $ra


   #BODY
   lw   $s0, 12($fp)         #accessing n
   lw   $s1, 8($fp)          #accessing small
   lw   $s2, 4($fp)          #accessing large

   move $s0, $a0             #store input n in $s0
   li   $t0, 2               #temp var for 2
   blt  $s0, $t0, quit       #return n if < 2

   srl  $a0, $s0, 2          #input =  n >> 2
   jal  isqrt                #$v0 = isqrt(n >> 2)

   sll  $s1, $v0, 1          #small = isqrt(n >> 2) << 1 stored in $s1
   li   $t0, 1               #store 1 in temp
   add  $s2, $s1, $t0        #large = small + 1 stored in $s2
   mul  $t1, $s2, $s2        #temp var for large^2

   bgt  $t1, $s0, return_s   #if large^2 > n return small
   move $v0, $s2             #return large
   j    exit                 #exit

return_s:
   move $v0, $s1             #return small
   j    exit                 #exit

quit:
   move $v0, $s0             #return n

exit:
   lw   $s0, 12($sp)         #pop n
   lw   $s1, 8($sp)          #pop small variable
   lw   $s2, 4($sp)          #pop large variable
   #EPILOGUE
   move $sp, $fp             #restore $sp
   lw   $ra, ($fp)           #restore $ra
   lw   $fp, -4($sp)         #restore $fp
   jr   $ra                  #return to main


