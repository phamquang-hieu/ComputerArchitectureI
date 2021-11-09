##############################################################################
#
#  KURS: 1DT038 2018.  Computer Architecture
#	
# DATUM:
#
#  NAMN:			
#
#  NAMN:
#
##############################################################################

	.data
	
ARRAY_SIZE:
	.word	10	# Change here to try other values (less than 10)
FIBONACCI_ARRAY:
	.word	1, 1, 2, 3, 5, 8, 13, 21, 34, 55
STR_str:
	.asciiz "Hunden, Katten, Glassen"
	.globl DBG
	.text

##############################################################################
#
# DESCRIPTION:  For an array of integers, returns the total sum of all
#		elements in the array.
#
# INPUT:        $a0 - address to first integer in array.
#		$a1 - size of array, i.e., numbers of integers in the array.
#
# OUTPUT:       $v0 - the total sum of all integers in the array.
#
##############################################################################
integer_array_sum:  

DBG:	##### DEBUGG BREAKPOINT ######

        addi    $v0, $zero, 0           # Initialize Sum to zero.
	add	$t0, $zero, $zero	# Initialize array index i to zero.
	addi $sp, $sp, -8
	sw $s0, 0($sp)
	sw $s1, 4($sp)
		
for_all_in_array:
	
	
	#### Append a MIPS-instruktion before each of these comments
	
	beq $t0, $a1, end_for_all
	# Done if i == N
	
	addi $s0, $zero, 4
  	mult $s0, $t0 # t0: index
  	mflo $s0
	# 4*i
	
	add $s1, $a0, $s0  # $s1: address
	# address = ARRAY + 4*i
	
	lw $t1, 0($s1) # t1: n
	# n = A[i]
	
	add $v0, $v0, $t1
       	# Sum = Sum + n
        
        addi $t0, $t0, 1
        # i++ 
        
        j for_all_in_array
  	# next element
	
end_for_all:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	addi $sp, $sp, 8
	jr	$ra			# Return to caller.
	
##############################################################################
#
# DESCRIPTION: Gives the length of a string.
#
#       INPUT: $a0 - address to a NUL terminated string.
#
#      OUTPUT: $v0 - length of the string (NUL excluded).
#
#    EXAMPLE:  string_length("abcdef") == 6.
#
##############################################################################	
string_length:
	add $t0, $zero, $zero #$t0 is the string index
	add $t2, $zero, $zero #$t2 is the current address of the string element
	
	#### Write your solution here ####
	loop:
		add $t2, $a0, $t0  
		# increase address by the index 
		
		lb $t1, 0($t2) # each word = 1 byte -> load only 1 byte
		
		# $t1: current character of the string
		addi $t0, $t0, 1
		bne $t1, $zero, loop 
	
	addi $t0, $t0, -1	
	move $v0, $t0
	jr	$ra
	
##############################################################################
#
#  DESCRIPTION: For each of the characters in a string (from left to right),
#		call a callback subroutine.
#
#		The callback suboutine will be called with the address of
#	        the character as the input parameter ($a0).
#	
#        INPUT: $a0 - address to a NUL terminated string.
#
#		$a1 - address to a callback subroutine.
#
##############################################################################	
string_for_each:
	
	# if the string is empty then return right away.
	lb	$t0, 0($a0)
	beqz 	$t0, return_string_for_each
	
	# else if the string is not empty.
	addi	$sp, $sp, -8		# PUSH return address to caller
	sw	$ra, 0($sp)
	
	str_for_each_loop:
		sw	$a0, 4($sp)
	
		jalr $a1
	
		lw	$a0, 4($sp)
	
		addi 	$a0, $a0, 1
	
		lb 	$t0, 0($a0)
	
		bne 	$t0, $zero, str_for_each_loop
	
	lw	$ra, 0($sp)		# Pop return address to caller
	addi	$sp, $sp, 8	

return_string_for_each:
	jr	$ra

##############################################################################
#
#  DESCRIPTION: Transforms a lower case character [a-z] to upper case [A-Z].
#	
#        INPUT: $a0 - address of a character 
#
##############################################################################		
to_upper:

	#### Write your solution here ####
	lb $t0, 0($a0) # take the current character
	
	# if the current character is not in the (not yet uppercased) alphabet
	bgt $t0, 122, return_to_upper
	blt $t0, 97, return_to_upper
	
	addi $t0, $t0, -32 	# turn the character to upper case
	
	sb $t0, 0($a0) 		# load the character back to memory
	
return_to_upper:
	jr	$ra

##############################################################################
#
#  DESCRIPTION: Reverse a string.
#	
#        INPUT: $a0 - address to the 1st character of a NUL terminated string
#
##############################################################################		
string_reverse: 
	
	# Save argument $a0 in case subroutine call another subroutine that may modify $a0
	addi	$sp, $sp, -8
	sw	$a0, 0($sp)
	sw	$ra, 4($sp)
	
	jal string_length 
	
	lw	$a0, 0($sp)
	lw	$ra, 4($sp)	
	addi	$sp, $sp, 8	
	
	add	$t0, $v0, $zero 	# $t0: length of the string
	
	addi	$t0, $t0, -1
	add	$t0, $a0, $t0 	# $t0: address of the last character in the string
	
	# if the last index is not yet = the first index or = the first index - 1
	while_true:
		lb	$t1, 0($t0)	# load the last character into $t1
		lb	$t2, 0($a0)	# load the 1st character into $t2
		
		sb	$t2, 0($t0)	# store the 1st character at the position of the last character
		sb	$t1, 0($a0)	# store the last character at the position of the 1st character
		
		beq	$a0, $t0, end_reverse	# incase the string's length is odd -> reversing ends when 1st pointer = last pointer
		addi	$t2, $a0, -1
		beq	$t2, $t0, end_reverse	# incase the string's length is even -> reversing ends when 1st pointer is 1 unit greater than the last pointer
		
		addi	$a0, $a0, 1		# increase the 1st pointer
		addi	$t0, $t0, -1		# decrease the last pointer
		
		j while_true

	end_reverse:
		jr $ra
	
##############################################################################
#
# Strings used by main:
#
##############################################################################

	.data

NLNL:	.asciiz "\n\n"
	
STR_sum_of_fibonacci_a:	
	.asciiz "The sum of the " 
STR_sum_of_fibonacci_b:
	.asciiz " first Fibonacci numbers is " 

STR_string_length:
	.asciiz	"\n\nstring_length(str) = "

STR_for_each_ascii:	
	.asciiz "\n\nstring_for_each(str, ascii)\n"

STR_for_each_to_upper:
	.asciiz "\n\nstring_for_each(str, to_upper)\n\n"	

	.text
	.globl main

##############################################################################
#
# MAIN: Main calls various subroutines and print out results.
#
##############################################################################	
main:	
	addi	$sp, $sp, -4	# PUSH return address
	sw	$ra, 0($sp)

	##
	### integer_array_sum
	##
	
	li	$v0, 4
	la	$a0, STR_sum_of_fibonacci_a
	syscall

	lw 	$a0, ARRAY_SIZE
	li	$v0, 1
	syscall

	li	$v0, 4
	la	$a0, STR_sum_of_fibonacci_b
	syscall
	
	la	$a0, FIBONACCI_ARRAY
	lw	$a1, ARRAY_SIZE
	jal 	integer_array_sum

	# Print sum
	add	$a0, $v0, $zero
	li	$v0, 1
	syscall

	li	$v0, 4
	la	$a0, NLNL
	syscall
	
	la	$a0, STR_str
	jal	print_test_string

	##
	### string_length 
	##
	
	li	$v0, 4
	la	$a0, STR_string_length
	syscall

	la	$a0, STR_str
	jal 	string_length

	add	$a0, $v0, $zero
	li	$v0, 1
	syscall

	##
	### string_for_each(string, ascii)
	##
	
	li	$v0, 4
	la	$a0, STR_for_each_ascii
	syscall
	
	la	$a0, STR_str
	la	$a1, ascii
	jal	string_for_each

	##
	### string_for_each(string, to_upper)
	##
	
	li	$v0, 4
	la	$a0, STR_for_each_to_upper
	syscall

	la	$a0, STR_str
	la	$a1, to_upper
	jal	string_for_each
	
	la	$a0, STR_str
	jal	print_test_string
	
	# print out some new empty lines
	li	$v0, 4
	la	$a0, NLNL
	syscall
	
	##
	### string_reverse(string)
	
	la 	$a0, STR_str
	jal	string_reverse
	
	la	$a0, STR_str
	jal	print_test_string
	
	
	lw	$ra, 0($sp)	# POP return address
	addi	$sp, $sp, 4	
	
	jr	$ra

##############################################################################
#
#  DESCRIPTION : Prints out 'str = ' followed by the input string surronded
#		 by double quotes to the console. 
#
#        INPUT: $a0 - address to a NUL terminated string.
#
##############################################################################
print_test_string:	

	.data
STR_str_is:
	.asciiz "str = \""
STR_quote:
	.asciiz "\""	

	.text

	add	$t0, $a0, $zero  #QHP: Temporary save $a0 before system call
	
	li	$v0, 4
	la	$a0, STR_str_is
	syscall

	add	$a0, $t0, $zero #QHP: Restore the value of $a0 after system call
	syscall	#QHP: now syscall help printing out the string with address stored in $a0

	li	$v0, 4	
	la	$a0, STR_quote
	syscall
	
	jr	$ra
	

##############################################################################
#
#  DESCRIPTION: Prints out the Ascii value of a character.
#	
#        INPUT: $a0 - address of a character 
#
##############################################################################
ascii:	
	.data
STR_the_ascii_value_is:
	.asciiz "\nAscii('X') = "

	.text

	la	$t0, STR_the_ascii_value_is

	# Replace X with the input character
	
	add	$t1, $t0, 8	# Position of X
	lb	$t2, 0($a0)	# Get the Ascii value
	sb	$t2, 0($t1)

	# Print "The Ascii value of..."
	
	add	$a0, $t0, $zero 
	li	$v0, 4
	syscall

	# Append the Ascii value
	
	add	$a0, $t2, $zero
	li	$v0, 1
	syscall


	jr	$ra
	
