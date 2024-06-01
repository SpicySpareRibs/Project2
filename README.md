# Project2

Data is stored in an 8 by 8 matrix stored in the data heap?

8 by 8 matrix. stored as 64 adjacent words
For each word: upper half contains data2, lower half contains data1 (use sh, lh to access change cell data)

data2: 0 if unopened, 1 if opened, 2 if flagged
data1: -1 if mine, 0-8 if adjacent to mine


MAXIMIZE MACROS: whenever possible
git repository notes: We can append/adjust 1 function at a time. as such clearly mark and separate created functions
IMPORTANT: MAKE SURE LABELS ARE UNIQUE as per their intended use. (coordinate w team members so that no fxn label are common upon merging)
Example: PrintGrid nested labels: PrintGridL1, PrintGridL1end etc.

USE FUNCTIONS WITH STACK FRAMES

Project GoalPoints:
0. Initializing:  Set up matrix data structure, create test cases for display, 
   PrintFunction: Iteratively print and check each cell's data1 and data2
1. Given Input of Mine Locations: Be sure to be able to print the completed minefield (iteratively calculate all data1s, set data2 to 1s)
   //edge case consideration: cells at edges and corners have less calculations
2. Implement Open Cell Functions: 
	Open Cell:
		If cell is out of bounds, do nothing
		Else if cell is mine, jump to LOSE
		else if cell data1 != 0: set data2 to 1
		else if cell data1 ==0: 
			Open Cell all Adjacents (recursive) (cell upper left, cell upper, cell upper right, to cell left)
			//edge case consideration: out of bounds edge case
		

3. Implement Flag Cell
4. Implement Win/Lose


