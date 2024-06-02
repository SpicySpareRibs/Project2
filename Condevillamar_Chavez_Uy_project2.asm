.macro read_char	#TEMPORARY MACRO	[Asks character from user]
	li $v0, 12
	syscall
	move $a0, $v0	#Stores read input to a0
.end_macro

.macro print_input	#temporary macro [Prints initial input]
	li $v0, 4
	la $a0, first_inp_str	
	syscall
	move $a0, $v0	#Stores read input to a0
.end_macro


# DO NOT MIND THE MACROS ABOVE [JUST USED FOR SANITY CHECKING]

.macro read_ini_inp
	li $v0, 8
	la $a0, first_inp_str
	la $a1, 50
	syscall
.end_macro


.macro get_row		#macro for getting row from input [assumes that a0 has the input character]	#NOT YET TESTED
	subi	$sp, $sp, 16
	sw	$t0, 0($sp)
	sw	$t1, 4($sp)	
	sw	$t2, 8($sp)	
	sw	$t3, 12($sp)
	la $t0, chars_inp	#ptr to character input in .data
	la $t1, coord_out	#ptr to coord output in .data
	li $t2, 0		#loop ctr
lgr:				#[l]oop_[g]et_[r]ow
	lb $t3, 0($t0)		# load char from chars_inp
				#NOTE: DO WE STILL NEED TO CONSIDER NULL OPS?
	beq $a0, $t3, lgr_s
	
	addi $t0, $t0, 1	
	addi $t1, $t1, 4	
	j lgr
lgr_s:	
	lw 	$s0, 0($t1)		#s0 has the output	
	lw	$t0, 0($sp)
	lw	$t1, 4($sp)	
	lw	$t2, 8($sp)	
	lw	$t3, 12($sp)
	addi	$sp, $sp, 16
.end_macro

.macro get_col		#macro for getting col from input [assumes that a0 has the input character]	#NOT YET TESTED
	subi	$sp, $sp, 16
	sw	$t0, 0($sp)
	sw	$t1, 4($sp)	
	sw	$t2, 8($sp)	
	sw	$t3, 12($sp)
	la $t0, ints_inp	#ptr to character input in .data
	la $t1, coord_out	#ptr to coord output in .data
	li $t2, 0		#loop ctr
lgc:				#[l]oop_[g]et_[c]olumn
	lb $t3, 0($t0)		# load char from ints_inp
				#NOTE: DO WE STILL NEED TO CONSIDER NULL OPS?
	beq $a0, $t3, lgr_c
	
	addi $t0, $t0, 1	
	addi $t1, $t1, 4	
	j lgc
lgr_c:	
	lw 	$s1, 0($t1)		#s0 has the output	
	lw	$t0, 0($sp)
	lw	$t1, 4($sp)	
	lw	$t2, 8($sp)	
	lw	$t3, 12($sp)
	addi	$sp, $sp, 16
.end_macro



.macro printflag	#macro for printf("F");
	li $v0, 4
	la $a0, flag
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

#Bookmark: Start of Main

main:
	read_ini_inp			#Asks for String Input [The Seven Substring Inital]
	li $t0, 0
	li $t1, 7
	la $t3, first_inp_str
get_row_col:				#Did not allocate stack frame here, should I?
	beq $t0, $t1, exit_row_col
	lb $a0, 0($t3)
	get_row
	addi $t3, $t3, 1
	lb $a0, 0($t3)
	get_col
	move $a0, $s0
	move $a1, $s1
	## PUT YOUR OPERATIONS HERE [a0 has the row, a1 has the column]	
	
	
	
	## /-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-
	addi $t3, $t3, 1
	addi $t3, $t3, 1
	addi $t0, $t0, 1
	j get_row_col
exit_row_col:				#NOTE: Used registers now has trash values(not used anymore)



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
move	$a0, $t6
li	$v0, 1
syscall
j	PGL2_end
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

#CUT IN

#REMOVE THIS[DURING FINAL OUTPUT]:
Sample_prmp: .asciiz "Enter Input: "

first_inp_str: .space 30				#30 for now
chars_inp: .asciiz "ABCDEFGH"
ints_inp: .asciiz "12345678"
coord_out: .word 1, 2, 3, 4, ,5, 6, 7, 8			#Might be wrong due to shorthand declaration //HERE

#CONTINUE HERE: DATA FOR INPUT COMPARISON
#row_1: .asciiz "A"

# CUT OUT

#data1 is stored in lower 4 bytes, data2 is stored in upper4 bytes
grid: 	.word	0x00020001 #(Flagged 1)
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
	
