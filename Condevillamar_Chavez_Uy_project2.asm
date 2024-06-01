
.macro printflag	#macro for printf("F");
	li $v0, 4
	la $a0, flag
	syscall
.end_macro
.macro printbomb	#macro for printf("B");
	li $v0, 4
	la $a0, bomb
	syscall
.end_macro
.macro print_	#macro for printf("_");
	li $v0, 4
	la $a0, underscore
	syscall
.end_macro
.macro printspace	#macro for printf("   ");
	li $v0, 4
	la $a0, spac
	syscall
.end_macro

.macro printnewline 	#macro for printf("\n");
	li $v0, 4
	la $a0, newline
	syscall
.end_macro



.text


main:
jal	printGrid
li	$v0, 10
syscall
printGrid:
addi	$sp, $sp, 44
sw	$ra, 0($sp)
sw	$t0, 4($sp)	#i
sw	$t1, 8($sp)	#j
sw	$t2, 12($sp)	#celldata
sw	$t3, 16($sp)	#offset
sw	$t4, 20($sp)	#8
sw	$t5, 24($sp)	#data2
sw	$t6, 28($sp)	#data1
sw	$t7, 32($sp)	#comparator for data2
sw	$a0, 36($sp)	
sw	$v0, 40($sp)
li	$t0, 0
li	$t4, 8
printGridloop1:
li	$t1, 0
blt	$t0, $t4,printGridloop2 
#end print	
lw	$ra, 0($sp)
lw	$t0, 4($sp)	#i
lw	$t1, 8($sp)	#j
lw	$t2, 12($sp)	#celldata
lw	$t3, 16($sp)	#offset
lw	$t4, 20($sp)	#8
lw	$t5, 24($sp)	#data2
lw	$t6, 28($sp)	#data1
lw	$t7, 32($sp)	#comparator for data2
lw	$a0, 36($sp)	
lw	$v0, 40($sp)
subi	$sp, $sp, 44
jr	$ra
printGridloop2:
blt	$t1, $t4, printGridCell
#endrow
printnewline
addi	$t0, $t0, 1
j printGridloop1

printGridCell:
move	$t3, $t0
sll	$t3, $t3, 3
add	$t3, $t3, $t1
sll	$t3, $t3, 2
lh	$t5, grid+2($t3)

li	$t7, 0
beq	$t5,$t7, PGprint_
li	$t7, 2
beq	$t5,$t7, PGprintF

lh	$t6, grid($t3)

li	$t7, -1
beq	$t6, $t7, PGprintB
move	$a0, $t6
li	$v0, 1
syscall
j	PGL2_end

PGprintB:
printbomb
j PGL2_end
PGprint_:
print_
j PGL2_end

PGprintF:
printflag
j PGL2_end
PGL2_end:
printspace
addi	$t1, $t1, 1
j	printGridloop2






.data
flag:	.asciiz "F"
spac:		.asciiz "  "
newline:	.asciiz "\n"
underscore: .asciiz	"_"
bomb:	.asciiz "B"
#data1 is stored in lower 4 bytes, data2 is stored in upper4 bytes
grid: 	.word	0x00020001 #(Flagged 1)
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	
	.word	0x0000FFFF
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0x000010005 #(Flagged 5)
	
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0	
	.word	0
	.word	0
	
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	