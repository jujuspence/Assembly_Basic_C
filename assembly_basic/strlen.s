# strlen(str)

strlen:
   # PROLOGUE
   subu $sp, $sp, 8
   sw   $ra, 8($sp)
   sw   $fp, 4($sp)
   addu $fp, $sp, 8

   # BODY
   li $t1, -1
   loop:
           lb $t0, ($a0)
           addi $a0, $a0, 1             #advance char pointer
           addi $t1, $t1, 1             #add to count 
           bne $t0, $zero, loop         #return to loop if byte not null
   move $v0, $t1

   # EPILOGUE
   move $sp, $fp
   lw $ra, ($fp)
   lw $fp, -4($sp)
   jr $ra
~               
