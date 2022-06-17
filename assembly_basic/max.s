# max(x, y)

max:
       # PROLOGUE
       subu $sp, $sp, 8
       sw $ra, 8($sp)
       sw $fp, 4($sp)
       addu $fp, $sp, 8

       # BODY
       blt $a0, $a1, endif
       move $v0, $a0
       j ret
endif: move $v0, $a1

ret:
       # EPILOGUE
       move $sp, $fp
       lw $ra, ($fp)
       lw $fp, -4($sp)
       jr $ra
~              
