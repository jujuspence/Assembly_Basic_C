 .data
str1:
   .asciiz "abba"
str2:
   .asciiz "racecar"
str3:
   .asciiz "swap paws",
str4:
   .asciiz "not a palindrome"
str5:
   .asciiz "another non palindrome"
str6:
   .asciiz "almost but tsomla"

# array of char pointers = {&str1, &str2, ..., &str6}
ptr_arr:
   .word str1, str2, str3, str4, str5, str6, 0

yes_str:
   .asciiz " --> Y\n"
no_str:
   .asciiz " --> N\n"

   .text

# main(): ##################################################
#   char ** j = ptr_arr
#   while (*j != 0):
#     rval = is_palindrome(*j)
#     printf("%s --> %c\n", *j, rval ? yes_str: no_str)
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

   la   $s0, ptr_arr        # use s0 for j. init ptr_arr
main_while:
   lw   $s1, ($s0)         # use s1 for *j
   beqz $s1, main_end      # while (*j != 0):
   move $a0, $s1           #    print_str(*j)
   li   $v0, 4
   syscall
   move $a0, $s1           #    v0 = is_palindrome(*j)
   jal  is_palindrome
   beqz $v0, main_print_no #    if v0 != 0:
   la   $a0, yes_str       #       print_str(yes_str)
   b    main_print_resp
main_print_no:             #    else:
   la   $a0, no_str        #       print_str(no_str)
main_print_resp:
   li   $v0, 4
   syscall

   addu $s0, $s0, 4       #     j++
   b    main_while        # end while
main_end:

   # EPILOGUE
   move $sp, $fp           # restore $sp
   lw   $ra, ($fp)         # restore saved $ra
   lw   $fp, -4($sp)       # restore saved $fp
   j    $ra                # return to kernel
# end main #################################################is_palindrome:
   #PROLOGUE
   subu $sp, $sp, 16            #grow stack by 8 bytes
   sw   $ra, 16($sp)            #push $ra 
   sw   $fp, 12,($sp)           #push $fp
   sw   $s0, 8($sp)             #push i
   sw   $s1, 4($sp)             #push strlen
   addu $fp, $sp, 16            #set $fp to saved $ra

   #BODY
   lw   $s0, 8($fp)             #accessing i
   lw   $s1, 4($fp)             #accessing strlen/2 variable

   li   $s0, 0                  # i =0
   move $s1, $a0                #temporary storage $s1 = *string

   jal  strlen                  #$v0 = strlen
   move $t1, $v0                # $t1 = strlen
   subu $t1, $t1, 1             # $t1 = strlen - 1
   move $a0, $s1                # $a0 = *string
   add  $t2, $a0, $t1           # $t2 = string[length-1]
   divu $s1, $v0, 2             # $s1 = strlen/2
   lb   $t3, ($t2)              # $t3 = string[length -1] ()
   lb   $t0, ($a0)              # $t0 = *string

while:
   bge  $s0, $s1, return1       #if i >= strlen/2 then return1

   bne  $t0, $t3, return0       #if str[i] != str[length-i-1] then return0
   addu $a0, $a0, 1             #advance string pointer string++
   subu $t2, $t2, 1             # $t2 = str[len-i-1] 
   lb   $t0, ($a0)              # $t0 = str[i]
   lb   $t3, ($t2)              # $t3 = str[len-i-1]

   addi $s0, $s0, 1             #i++
   j    while                   #jump back to beginning of while loop

return1:
   li   $v0, 1                  #load output 1
   j    exit                    #exit function call

return0:
   li   $v0, 0                  #load output 0
   j    exit                    #exit function call

exit: lw   $s0, 8($sp)             #pop $s0
   lw   $s1, 4($sp)             #pop $s1
   #EPILOGUE
   move $sp, $fp                #restore stack pointer
   lw   $ra, ($fp)              #restore saved $fp
   lw   $fp, -4($sp)            #restore saved $ra
   jr   $ra                     #return to main

strlen:
   # PROLOGUE
   subu $sp, $sp, 8             #move stack pointer by 8 bytes
   sw   $ra, 8($sp)             #push $ra
   sw   $fp, 4($sp)             #push $fp
   addu $fp, $sp, 8             #set $fp to saved $ra

   # BODY
   li $t1, -1                   #store temp -1
 loop:
   lb $t0, ($a0)                #store string byte into $t0
   addi $a0, $a0, 1             #advance char pointer
   addi $t1, $t1, 1             #add to count 
   bne $t0, $zero, loop         #return to loop if byte not null

   move $v0, $t1                #return $t1 count

   # EPILOGUE
   move $sp, $fp                #restore stack pointer
   lw $ra, ($fp)                #restore saved $fp
   lw $fp, -4($sp)              #restore saved $ra
   jr $ra                       #return to previous call
           
