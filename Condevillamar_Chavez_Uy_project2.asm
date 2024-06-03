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

.macro read_runtime_inp
	li $v0, 8
	la $a0, runtime_str
	la $a1, 10
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

.macro get_col		#macro for getting col from input [assumes that a0 has the input character]
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
	lw 	$s1, 0($t1)		#s1 has the output	
	lw	$t0, 0($sp)
	lw	$t1, 4($sp)	
	lw	$t2, 8($sp)	
	lw	$t3, 12($sp)
	addi	$sp, $sp, 16
.end_macro

.macro get_op		#macro for getting op from runtime input[assumes that a0 has the input character]
	subi	$sp, $sp, 16
	sw	$t0, 0($sp)
	sw	$t1, 4($sp)	
	sw	$t2, 8($sp)	
	sw	$t3, 12($sp)
	la $t0, char_op		#ptr to character operators in .data
	la $t1, code_op		#ptr to code operator output in .data
	li $t2, 0		#loop ctr
lgo:
	lb $t3, 0($t0)
	beq $a0, $t3, lgo_c
	addi $t0, $t0, 1	
	addi $t1, $t1, 4	
	j lgo

lgo_c:
	lw 	$s0, 0($t1)		#s0 has the output	
	lw	$t0, 0($sp)
	lw	$t1, 4($sp)	
	lw	$t2, 8($sp)	
	lw	$t3, 12($sp)
	addi	$sp, $sp, 16
.end_macro



.macro place_bomb	#macro for placing bomb in the grid [assumes a0 has row, and a1 has col]
	subi	$sp, $sp, 8
	sw	$t0, 0($sp)
	sw	$t1, 4($sp)	
	
	move $t0, $a0
	sll $t0, $t0, 3
	add $t0, $t0, $a1
	sll $t0, $t0, 2
	li $t1, 0x0000FFFF
	sh $t1, grid($t0)
		
	lw	$t0, 0($sp)
	lw	$t1, 4($sp)	
	addi	$sp, $sp, 8
.end_macro

.macro get_offset	#macro for placing getting offset[assumes a0 has row, and a1 has col]
	subi	$sp, $sp, 4
	sw	$t0, 0($sp)	
	
	move $t0, $a0
	sll $t0, $t0, 3
	add $t0, $t0, $a1
	sll $t0, $t0, 2
	move $v0, $t0

	lw	$t0, 0($sp)	
	addi	$sp, $sp, 4
.end_macro

.macro game_end		#used for game_end ops [print win/lose, and eventually ends]
	
.end_macro


#Above are the input macros

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
	subi $a0, $a0, 1
	subi $a1, $a1, 1
	
	place_bomb
	
	addi $t3, $t3, 1
	addi $t3, $t3, 1
	addi $t0, $t0, 1
	j get_row_col
exit_row_col:				#NOTE: Used registers now has trash values(not used anymore);
	jal	printGrid
runtime_proper:				#Jump to here if going to next round inputs
# CONTINUE HERE
# CASES
# O A1
# F A1
# U A1
# DONE
# Determine the Ops first
# Remember: ERROR CHECKING
	read_runtime_inp
	la $t0, runtime_str	# t0 has ptr to runtime input [+1 for character traversal]
Det_op:
	lb $a0, 0($t0)		# first char of runtime input 
	get_op			# at this point, operator code should be determined(s0) | NOTE: COMMENTS IN code_op LABEL 
	
	li $t1, 1
	beq $s0, $t1, open_op
	
	li $t1, 2
	beq $s0, $t1, flag_op
	
	li $t1, 3
	beq $s0, $t1, unflag_op
	
	li $t1, 4
	beq $s0, $t1, done_op
	
# curr used registers: t0, t1, s0



open_op:
	addi $t0, $t0, 2	#[<OP> -> <SPACE> -> <ROW><COL> ] | Reason why Plus 2? Check left
	lb $a0, 0($t0)
	get_row
	addi $t0, $t0, 1
	lb $a0, 0($t0)
	get_col
	move $a0, $s0
	move $a1, $s1
	subi $a0, $a0, 1
	subi $a1, $a1, 1
	get_offset		# at this point, v0 has the target grid index | DO ACCOUNT FOR data1 & data2 placement
	#PLACEHOLDER | NOTE: Error Checking first, before doing said operation
	j temp_end

flag_op:
	addi $t0, $t0, 2	#[<OP> -> <SPACE> -> <ROW><COL> ] | Reason why Plus 2? Check left
	lb $a0, 0($t0)
	get_row
	addi $t0, $t0, 1
	lb $a0, 0($t0)
	get_col
	move $a0, $s0
	move $a1, $s1
	subi $a0, $a0, 1
	subi $a1, $a1, 1
	get_offset		# at this point, v0 has the target grid index | DO ACCOUNT FOR data1 & data2 placement
	#PLACEHOLDER | NOTE: Error Checking first, before doing said operation
	j temp_end

unflag_op:
	addi $t0, $t0, 2	#[<OP> -> <SPACE> -> <ROW><COL> ] | Reason why Plus 2? Check left
	lb $a0, 0($t0)
	get_row
	addi $t0, $t0, 1
	lb $a0, 0($t0)
	get_col
	move $a0, $s0
	move $a1, $s1
	subi $a0, $a0, 1
	subi $a1, $a1, 1
	get_offset		# at this point, v0 has the target grid index | DO ACCOUNT FOR data1 & data2 placement
	#PLACEHOLDER | NOTE: Error Checking first, before doing said operation
	j temp_end

done_op:
	#PLACEHOLDER | NOTE: Error Checking first, before doing said operation
	j temp_end

temp_end: 	#EDIT THIS LABEL WHEN DONE CODING OPERATIONS | TO REMOVE!
#jal	printGrid
li	$v0, 10
syscall


printGrid:
subi	$sp, $sp, 44
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
addi	$sp, $sp, 44
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



flag:	.asciiz "F"
spac:		.asciiz "  "
newline:	.asciiz "\n"
underscore: .asciiz	"_"

#REMOVE THIS[DURING FINAL OUTPUT]:
Sample_prmp: .asciiz "Enter Input: "

first_inp_str: .space 30			#30 for now	[theoretically should be 20]
runtime_str: .space 10				#10 for now	[theoretically should be 5]
chars_inp: .asciiz "ABCDEFGH"
ints_inp: .asciiz "12345678"
coord_out: .word 1, 2, 3, 4, ,5, 6, 7, 8	# Index-based correlation of asciiz from above two lines
char_op: .asciiz "OFUD"
code_op: .word 1, 2, 3, 4			# 1 = open, 2 = flag, 3 = unflag, 4 = done


bomb:	.asciiz "B"

	