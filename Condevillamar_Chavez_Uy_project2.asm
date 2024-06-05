<<<<<<< Updated upstream
=======
.macro read_char	#TEMPORARY MACRO	[Asks character from user]
	li $v0, 12
	syscall
	move $a0, $v0	#Stores read input to a0
.end_macro


# DO NOT MIND THE MACROS ABOVE [JUST USED FOR SANITY CHECKING]

.macro print_win	
	subi	$sp, $sp, 8
	sw	$a0, 0($sp)
	sw	$v0, 4($sp)

	li $v0, 4
	la $a0, gw_res	
	syscall
	
	lw	$a0, 0($sp)
	lw	$v0, 4($sp)
	addi	$sp, $sp, 8
.end_macro

.macro print_lose	
	subi	$sp, $sp, 8
	sw	$a0, 0($sp)
	sw	$v0, 4($sp)

	li $v0, 4
	la $a0, gl_res	
	syscall
	
	lw	$a0, 0($sp)
	lw	$v0, 4($sp)
	addi	$sp, $sp, 8
.end_macro

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

.macro add_rnd_ctr			#VERIFIED TO WORK AT RND 1
	subi	$sp, $sp, 4
	sw	$t0, 0($sp)
	lw	$t0, rnd_ctr
	addi	$t0, $t0, 1
	sw	$t0, rnd_ctr
	lw	$t0, 0($sp)
	addi	$sp, $sp, 4
.end_macro

.macro print_rnd	
	subi	$sp, $sp, 8
	sw	$a0, 0($sp)
	sw	$v0, 4($sp)
	
	li $v0, 4
	la $a0, rnd_str
	syscall
	
	lw	$a0, 0($sp)
	lw	$v0, 4($sp)
	addi	$sp, $sp, 8
.end_macro

.macro print_rnd_ctr			#VERIFIED TO WORK AT RND 1
	subi	$sp, $sp, 8
	sw	$a0, 0($sp)
	sw	$v0, 4($sp)
	
	print_rnd
	lw	$a0, rnd_ctr
	li	$v0, 1
	syscall
	printnewline
	
	lw	$a0, 0($sp)
	lw	$v0, 4($sp)
	addi	$sp, $sp, 8
.end_macro

.macro print_ftob	
	subi	$sp, $sp, 8
	sw	$a0, 0($sp)
	sw	$v0, 4($sp)
	
	li $v0, 4
	la $a0, ftob_res
	syscall
	
	lw	$a0, 0($sp)
	lw	$v0, 4($sp)
	addi	$sp, $sp, 8
.end_macro

.macro print_ftob_ctr			#VERIFIED TO WORK AT RND 1
	subi	$sp, $sp, 8
	sw	$a0, 0($sp)
	sw	$v0, 4($sp)
	
	lw	$a0, f_to_b
	li	$v0, 1
	syscall
	print_ftob
	printnewline
	
	lw	$a0, 0($sp)
	lw	$v0, 4($sp)
	addi	$sp, $sp, 8
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

.macro get_offset	#macro for getting offset[assumes a0 has row, and a1 has col]
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

.macro game_end		#used for game_end ops [print win/lose, and eventually ends] | checls all cells iteratively {void fxn}
	#CONTINUE HERE
	li	$t0, 7			# NO NEED TO ALLOCATE STACK AS THIS IS CALLED IFF IT IS THE END
	lw	$t1, f_to_b
	beq	$t0, $t1, game_win
	j game_lost
	
game_lost:
	#PLACEHOLDER
	print_lose			#NOT SURE IF CALLING A MACRO INSIDE A MACRO IS CORRECT
	printnewline
	print_ftob_ctr			#print bomb to flg result here
	 
	j game_res
game_win:
	print_win			#NOT SURE IF CALLING A MACRO INSIDE A MACRO IS CORRECT
	printnewline
	print_ftob_ctr			# print bomb to flg result here
	 
	#ASSUMED TO GO TO game_res
game_res:	
	jal printGridX
	li	$v0, 10
	syscall
.end_macro


#Above are the input macros
>>>>>>> Stashed changes

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
.macro printX	#macro for printf("X");
	li $v0, 4
	la $a0, X
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

<<<<<<< Updated upstream
=======
openCell: 
subi $sp, $sp, 44
sw	$a0, 4($sp)	#ROW COORD
sw	$a1, 8($sp)	#COL COORD
sw	$v0, 12($sp)	#OFFSET
sw	$t0, 16($sp)	#data2
sw	$t1 20($sp) 	#data1
sw	$t2,24($sp)	#placeholder for -1
sw	$t3,28($sp)	#placeholder for row coord
sw	$t4,32($sp)	#placeholder for col coord
#36	for t3
#40	for t4

lh	$t0, grid+2($v0)
bne	$t0, $0, openCellInvalid

lh	$t1, grid($v0)
li	$t2, -1
beq	$t1, $t2, openCellMine

bgtz	$t0, openCellNormal

#cell is 0
move	$t3, $a0
move	$t4, $a1

sw	$t3, 36($sp)
sw	$t3, 40($sp)

addi	$a0, $t3, -1 #top left
addi	$a1, $t4, -1 

#jal	recursiveOpen

lw	$t3, 36($sp)
lw	$t4, 40($sp)

addi	$a0, $t3, -1 #top
addi	$a1, $t4, 0

#jal 	recursiveOpen

lw	$t3, 36($sp)
lw	$t4, 40($sp)

addi	$a0, $t3, -1 #top right
addi	$a1, $t4, 1

#jal 	recursiveOpen

lw	$t3, 36($sp)
lw	$t4, 40($sp)

addi	$a0, $t3, 0 #right
addi	$a1, $t4, 1

#jal 	recursiveOpen

lw	$t3, 36($sp)
lw	$t4, 40($sp)

addi	$a0, $t3, 1 #bottom right
addi	$a1, $t4, 1

#jal 	recursiveOpen

lw	$t3, 36($sp)
lw	$t4, 40($sp)

addi	$a0, $t3, 1 #bottom
addi	$a1, $t4, 0

#jal 	recursiveOpen

lw	$t3, 36($sp)
lw	$t4, 40($sp)

addi	$a0, $t3, -1 #bottom left
addi	$a1, $t4, -1

#jal 	recursiveOpen

lw	$t3, 36($sp)
lw	$t4, 40($sp)

addi	$a0, $t3, -1 #top right
addi	$a1, $t4, 0

#jal 	recursiveOpen


openCellNormal:
li	$t2, 1
lw	$v0, 12($sp)
sh	$t2, grid+2($v0)

lw	$a0, 4($sp)	#ROW COORD
lw	$a1, 8($sp)	#COL COORD
lw	$v0, 12($sp)	#OFFSET
lw	$t0, 16($sp)	#data2
lw	$t1 20($sp) 	#data1
lw	$t2,24($sp)	#placeholder for -1
lw	$t3,28($sp)	#placeholder for row coord
lw	$t4,32($sp)	#placeholder for col coord
#36	for t3
#40	for t4
addi	$sp, $sp, 44
j 	runtime_proper
openCellInvalid:
lw	$a0, 4($sp)	#ROW COORD
lw	$a1, 8($sp)	#COL COORD
lw	$v0, 12($sp)	#OFFSET
lw	$t0, 16($sp)	#data2
lw	$t1 20($sp) 	#data1
lw	$t2,24($sp)	#placeholder for -1
lw	$t3,28($sp)	#placeholder for row coord
lw	$t4,32($sp)	#placeholder for col coord
#36	for t3
#40	for t4
addi	$sp, $sp, 44
j 	in_ip_case
openCellMine:
lw	$a0, 4($sp)	#ROW COORD
lw	$a1, 8($sp)	#COL COORD
lw	$v0, 12($sp)	#OFFSET
lw	$t0, 16($sp)	#data2
lw	$t1 20($sp) 	#data1
lw	$t2,24($sp)	#placeholder for -1
lw	$t3,28($sp)	#placeholder for row coord
lw	$t4,32($sp)	#placeholder for col coord
#36	for t3
#40	for t4
addi	$sp, $sp, 44
game_end


>>>>>>> Stashed changes

printGridX:
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
printGridloop1X:
li	$t1, 0
blt	$t0, $t4,printGridloop2X 
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
printGridloop2X:
blt	$t1, $t4, printGridCellX
#endrow
printnewline
addi	$t0, $t0, 1
j printGridloop1X

printGridCellX:
move	$t3, $t0
sll	$t3, $t3, 3
add	$t3, $t3, $t1
sll	$t3, $t3, 2

lh	$t5, grid+2($t3)
lh	$t6, grid($t3)
li	$t7, 2
beq	$t5, $t7, PrintGridCaseFlag

li	$t7, -1
beq	$t6, $t7, PCGBX

move	$a0, $t6
li	$v0, 1
syscall
j	PGL2X_end

PrintGridCaseFlag:
li	$t7, -1
bne	$t6, $t7, PGCFX

PCGBX:
printbomb
j PGL2X_end

PGCFX:
printX
j PGL2X_end

PGL2X_end:
printspace
addi	$t1, $t1, 1
j	printGridloop2X





.data
flag:	.asciiz "F"
spac:		.asciiz "  "
newline:	.asciiz "\n"
underscore: .asciiz	"_"
bomb:	.asciiz "B"
<<<<<<< Updated upstream
#data1 is stored in lower 4 bytes, data2 is stored in upper4 bytes
grid: 	.word	0x00020001 #(Flagged 1)
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
=======
X:	.asciiz "X"

#GAME RESULT PRINTING BELOW

gw_res:	.asciiz	"WIN!"
gl_res:	.asciiz	"LOSE!"
ftob_res: .asciiz " of 7 bombs"


>>>>>>> Stashed changes
	
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
	