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
	# print uncovered grid with X's 
	j game_res
game_win:
	print_win			#NOT SURE IF CALLING A MACRO INSIDE A MACRO IS CORRECT
	printnewline
	print_ftob_ctr			# print bomb to flg result here
	# print uncovered grid with X's 
	#ASSUMED TO GO TO game_res
game_res:	
	jal printGridX
	li	$v0, 10
	syscall
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

.macro print_content($num)
	subi	$sp, $sp, 32
	sw	$a0, 0($sp)
	li	$v0, 1
	move	$a0, $num
	syscall
	lw	$a0, 0($sp)
	addi	$sp, $sp, 32
.end_macro

.macro isbomb
	subi	$sp, $sp, 32
	sw	$t0, 0($sp)		# index of current cell
	sw	$t1, 4($sp)		# index of cell being checked
	sw	$t2, 8($sp)		# stores value of cell
	
	sll	$t1, $t1, 2
	sll	$t0, $t0, 2
	
	lh	$t2, grid($t1)
	bne	$t2, -1, not_bomb
	lh	$t1, grid($t0)		# t1 becomes container for value of current cell
	addi	$t1, $t1, 1		# add 1 to the number of nearby mines
	sh	$t1, grid($t0)
not_bomb:				# if checked cell is not a bomb do nothing
	lw	$t0, 0($sp)
	lw	$t1, 4($sp)	
	lw	$t2, 8($sp)
	addi	$sp, $sp, 32
.end_macro 

.macro get_adjacency 	#macro for calculate for mine adjacency;
	subi	$sp, $sp, 32
	sw	$t0, 0($sp)		# index of current cell
	sw	$t1, 4($sp)		# index of cell being checked
	sw	$t2, 8($sp)		# stores value of cell
	sw	$t3, 12($sp)		# remainder
	sw	$t4, 16($sp)		# nahutdan na kog variables
	sw	$t5, 20($sp)		# contains number 8 for div
	
	addi	$t5, $0, 8
	addi	$t0, $0, 0		
adjloop:			
	beq	$t0, 64, adjloop_end
	sll	$t4, $t0, 2
	lh	$t2, grid($t4)
	beq	$t2, -1, last_col	# if current cell is a bomb proceed to next cell
	div	$t0, $t5
	mfhi	$t3
#	bne	$t3, 0, notnewline	#for checking
#	printnewline
notnewline:
	blt	$t0, 8, top_row		# if currently not at the first row, check top cells
	subi	$t1, $t0, 8
	isbomb				# checking top cell
	
	beq	$t3, 0, left_top	# if not in the first column, check top left corner
	subi	$t1, $t0, 9
	isbomb
	
left_top:
	beq	$t3, 7, top_row		# if not in the last column, check top right corner
	subi	$t1, $t0, 7
	isbomb
	
top_row:				
	beq	$t3, 0, first_col	# if currently not at the first column, check left cell
	subi	$t1, $t0, 1
	isbomb
	
first_col:
	bgt	$t0, 55, bottom_row	# if currently not at the last row, check bottom cell
	addi	$t1, $t0, 8
	isbomb
	
bottom_row:
	beq	$t3, 7, last_col	# if currently not at the last column, check right cell
	addi	$t1, $t0, 1
	isbomb
	
	beq	$t3, 0, left_bottom	# if not in the first column, check bottom left corner
	addi	$t1, $t0, 7
	isbomb
	
left_bottom:
	beq	$t3, 7, last_col	# if not in the last column, check bottom right corner
	addi	$t1, $t0, 9
	isbomb

last_col:
#	sll	$t4, $t0, 2		#for checking
#	lh	$t2, grid($t4)
#	print_content($t2)		
#	printspace
	addi	$t0, $t0, 1
	j	adjloop
	
adjloop_end:
	lw	$t0, 0($sp)
	lw	$t1, 4($sp)
	lw	$t2, 8($sp)
	lw	$t3, 12($sp)	
	lw	$t4, 16($sp)
	lw	$t5, 20($sp)
	addi	$sp, $sp, 32
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
	get_adjacency
	print_rnd_ctr
	#add_rnd_ctr
#jal	printGrid
runtime_proper:				#Jump to here if going to next round inputs
# CASES
# O A1
# F A1
# U A1
# DONE
# Determine the Ops first
# Remember: ERROR CHECKING
	jal printGrid
	add_rnd_ctr
	print_rnd_ctr
	read_runtime_inp
	la $t0, runtime_str	# t0 has ptr to runtime input [+1 for character traversal]
	#add_rnd_ctr		#increments round counter
	j Det_op
	
in_ip_case:
	jal printGrid
	print_rnd_ctr
	read_runtime_inp
	la $t0, runtime_str
	# Assumed to go to Det_op [SHOULD NOT INCREASE THE ROUND CTR]
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
	j openCell		# ALL J temp_end ARE TEMPORARY [ALL OPS]

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
	get_offset		# at this point, v0 has the target grid index | DO ACCOUNT FOR data1 & data2 placement | only v0 is curr_used
	lh $t0, grid+2($v0)	# Valid flag iff, no> flag <7 && index is unopened
	li $t1, 0
	beq $t0, $t1, vld_flg
	j invld_flg
	
vld_flg:			#must now check if flagged is < 7
	li $t1, 7
	lw $t2, flg_ctr
	bge $t2, $t1, invld_flg
	addi $t2, $t2, 1
	sw $t2, flg_ctr
	li $t0, 2
	sh $t0, grid+2($v0)	# REMEMBER TO UPDATE Flag to Bomb Correspondence
	
	lh $t0, grid($v0)	# t0 has data 1
	li $t1, -1
	beq $t0, $t1, inc_ftob
	
	j	f_prt
inc_ftob:
	lw $t2, f_to_b		# increment ftob corr
	addi $t2, $t2, 1
	sw $t2, f_to_b

f_prt:
	#jal	printGrid
	j	runtime_proper
	
invld_flg:	
	j in_ip_case

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
	lh $t0, grid+2($v0)	# Valid flag iff, no> flag >0 && index is unopened
	li $t1, 2
	beq $t0, $t1, vld_uflg
	j invld_uflg
vld_uflg:
	li $t1, 0
	lw $t2, flg_ctr
	ble $t2, $t1, invld_uflg
	subi $t2, $t2, 1
	sw $t2, flg_ctr
	li $t0, 0
	sh $t0, grid+2($v0)	# REMEMBER TO UPDATE Flag to Bomb Correspondence
	
	lh $t0, grid($v0)	# t0 has data 1
	li $t1, -1
	beq $t0, $t1, dec_ftob
	
	j	f_uprt
dec_ftob:
	lw $t2, f_to_b		# increment ftob corr
	subi $t2, $t2, 1
	sw $t2, f_to_b
	
f_uprt:
	j	runtime_proper

invld_uflg:
	#PLACEHOLDER | NOTE: Error Checking first, before doing said operation
	j in_ip_case

done_op:
	game_end	
	

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

bgt	$t1, 0, openCellNormal


#cell is 0
move	$t3, $a0
move	$t4, $a1

sw	$t3, 36($sp)
sw	$t4, 40($sp)

addi	$a0, $t3, -1 #top left
addi	$a1, $t4, -1 

jal		recursiveOpen

addi	$a0, $t3, -1 #top
addi	$a1, $t4, 0

jal 	recursiveOpen

addi	$a0, $t3, -1 #top right
addi	$a1, $t4, 1

jal 	recursiveOpen

addi	$a0, $t3, 0 #left
addi	$a1, $t4, -1

jal 	recursiveOpen

addi	$a0, $t3, 0 #right
addi	$a1, $t4, 1

jal 	recursiveOpen

addi	$a0, $t3, 1	#bottom left
addi	$a1, $t4, -1

jal 	recursiveOpen

addi	$a0, $t3, 1 #bottom
addi	$a1, $t4, 0

jal 	recursiveOpen

addi	$a0, $t3, 1 #bottom right
addi	$a1, $t4, 1

jal 	recursiveOpen



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


recursiveOpen:				# a0 as row, a1 as column 
	subi	$sp, $sp, 32
	sw	$t0, 0($sp)		# will hold data1 of current cell
	sw	$t1, 4($sp)		# will hold data2 of current cell
	sw	$t2, 8($sp)		# will hold row number of current cell
	sw	$t3, 12($sp)		# will hold column number of current cell
	sw	$ra, 28($sp)		# will hold return address for recursion purposes
	
	addi	$t2, $a0, 0
	addi	$t3, $a1, 0

	blt	$a0, 0, invalid_cell	# checking if cell within bounds
	blt	$a1, 0, invalid_cell
	bgt	$a0, 7, invalid_cell
	bgt	$a1, 7, invalid_cell
	
	
	get_offset			# offset is stored in v0
	
	lh	$t0, grid($v0)		# fetching data1
	addi	$v0, $v0, 2
	lh	$t1, grid($v0)		# fetching data2
	
	beq	$t1, 1, invalid_cell	# if cell is already opened
	beq	$t1, 2, invalid_cell	# if cell is flagged
	beq	$t0, -1, invalid_cell	# if cell is a mine
	bne	$t0, 0, open_cell
	
	addi	$t1, $0, 1		# setting cell to opened before checking other cells 
	sh	$t1, grid($v0)		# done to prevent infinite recursion
	
	addi	$a0, $t2, -1
	addi	$a1, $t3, -1
	jal 	recursiveOpen
	
	
	addi	$a0, $t2, -1
	addi	$a1, $t3, 0
	jal 	recursiveOpen

	addi	$a0, $t2, -1
	addi	$a1, $t3, 1
	jal	recursiveOpen
	
	addi	$a0, $t2, 0
	addi	$a1, $t3, -1
	jal 	recursiveOpen
	
	addi	$a0, $t2, 0
	addi	$a1, $t3, 1
	jal	recursiveOpen
	
	addi	$a0, $t2, 1
	addi	$a1, $t3, -1
	jal	recursiveOpen
	
	addi	$a0, $t2, 1
	addi	$a1, $t3, 0
	jal	recursiveOpen
	
	addi	$a0, $t2, 1
	addi	$a1, $t3, 1
	jal	recursiveOpen
	
	j 	invalid_cell
open_cell:				# setting data2 of cell to be opened
	addi	$t1, $0, 1
	sh	$t1, grid($v0)		
			
invalid_cell:				# if cell is invalid return
	lw	$t0, 0($sp)		
	lw	$t1, 4($sp)
	lw	$t2, 8($sp)		
	lw	$t3, 12($sp)
	lw	$ra, 28($sp)
	addi	$sp, $sp, 32
	jr	$ra



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

#data1 is stored in lower 4 bytes, data2 is stored in upper4 bytes
grid: 	.word	0
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
f_to_b: .word 0					# Flag to Bomb correspondence
rnd_ctr: .word 0				# Round Counter
rnd_str: .asciiz "ROUND "
flg_ctr: .word 0				# Glbl flag ctr, compare it to 7 for flag limitation


bomb:	.asciiz "B"
X:	.asciiz "X"
#GAME RESULT PRINTING BELOW

gw_res:	.asciiz	"WIN!"
gl_res:	.asciiz	"LOSE!"
ftob_res: .asciiz " of 7 bombs"


	
