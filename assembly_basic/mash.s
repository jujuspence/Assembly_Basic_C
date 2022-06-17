# mash(x, y)

mash:
    # PROLOGUE
   subu $sp, $sp, 8
   sw $ra, 8($sp)
   sw $fp, 4($sp)
   addu $fp, $sp, 8

   # BODY
   lw $t1, 4($fp)               #load x from stack into t1
   lw $t2, 8($fp)               #load y from stack into t2
   mul $t1, $t1, 10             #mult 10 to x in t1
   add $v0, $t1, $t2            #add y to 10x in t1
   #move $v0, $t1                #return t1 in v0

   # EPILOGUE
   move $sp, $fp
   lw $ra, ($fp)
   lw $fp, -4($sp)
   jr $ra

