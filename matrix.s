.data
A: .word 2, 3, 1, 4
B: .word 3, 7, 1, 6
C: .word 7, 8, 9, 0   
D: .word 0, 0, 0, 0
msg1: .asciiz "enter element of A \n"
msg2: .asciiz "enter element of B \n" 
msg3: .asciiz "Selected matrix A: \n"
msg4: .asciiz "Selected matrix B: \n"
msg5: .asciiz "multiplied Matrix C: \n"
msg6: .asciiz "\nretrieved: \n"
msg7: .asciiz " Multiply call: \n"
msg8: .asciiz "\nsum: \n"
msg9: .asciiz "\nend 3 loop\n"
msg10: .asciiz "\nc is: "
eol: .asciiz "\n"
space: .asciiz " "

.text

main: 

#FILL A
li $v0, 4
la $a0, msg1
syscall
sw $ra, 0($sp)
li $s1, 1 # row index
li $s2, 1 # column index
la  $a1, A
jal colslideP
lw $ra, 0($sp)
addiu $sp, $sp, 4


#PRINT A
li $v0, 4
la $a0, msg3
syscall 
addiu $sp, $sp, -4
sw $ra, 0($sp)
li $s1, 1 # row index
li $s2, 1 # column index
la  $a1, A 
jal colslide 
lw $ra, 0($sp)
addiu $sp, $sp, 4

#FILL B
li $v0, 4
la $a0, msg2
syscall
sw $ra, 0($sp)
li $s1, 1 # row index
li $s2, 1 # column index
la  $a1, B
jal colslideP
lw $ra, 0($sp)
addiu $sp, $sp, 4



#PRINT B
li $v0, 4
la $a0, msg4
syscall
sw $ra, 0($sp)
li $s1, 1 # row index
li $s2, 1 # column index
la  $a1, B
jal colslide 
lw $ra, 0($sp)
addiu $sp, $sp, 4

#MULTIPLY A and B
sw $ra, 0($sp)
li $s1, 1 # row index
li $s2, 1 # column index

la $a0, C
la $s5, D
jal colslideM
lw $ra, 0($sp)
addiu $sp, $sp, 4


#PRINT C
li $v0, 4
la $a0, msg5
syscall
sw $ra, 0($sp)
li $s1, 1 # row index
li $s2, 1 # column index
la  $a1, D
jal colslide 
lw $ra, 0($sp)
addiu $sp, $sp, 4






jr $ra
li $v0, 10
	syscall



#-----------------------------------------------------MULTIPLY 2x2 FUNCTION---------------------------------------------------------------------#
colslideM:    #address of A in a4
move $s4, $a0 #store c in s4
 
 li $t6, 2 #number rows and column
 addiu $t1, $s1, -1
addiu $t2, $s2, -1

la $s6, 0($t1)
la $s7, 0($t2)

 li $t4, 8 # size row
 li $t5, 4  #size column
 mul $t1, $t1, $t4 # row index
 mul $t2, $t2, $t5 # column index
 add $s4, $s4, $t1 #add offsets to addres
 add $s4, $s4, $t2 
 

li $t5, 0 #sum
li $s3, 0



j MULTIPLY
endmul:
sw $t5, 0($s5)
addi $s5 $s5 4

li $v0, 4
la $a0, eol

li $t6, 2
div $s2, $t6
mfhi $t6
beqz $t6, endrowM
addiu $s2, $s2, 1
j colslideM



endrowM: li $s2, 1 #reset col index
li $v0, 4
la $a0, eol
syscall
li $t6, 2
div $s1, $t6
mfhi $t6
beqz $t6, doneM
addi $s1, $s1, 1
j colslideM
doneM: jr $ra
 



MULTIPLY:  #I am inside C[i][j] now

beq $s3, 2, endmul

#Retrieve A[i][k] in t7


move $t1, $s6				#this is i
move $t2, $s3				#this is k
j RetrieveA				#find A[i][k]


RetrieveA:
la $t3, A
li $t4, 8
mul $t1, $t1, $t4
li $t4, 4
mul $t2, $t2, $t4
add $t3, $t3, $t1
add $t3, $t3, $t2
lw $t8, 0($t3)
j endA
endA: 

#Retrieve B[k][j] in t7

move $t1, $s3				#this is k
move $t2, $s7				#this is j
j RetrieveB					#find B[k][j]


RetrieveB:
la $t3, B
li $t4, 8
mul $t1, $t1, $t4
li $t4, 4
mul $t2, $t2, $t4
add $t3, $t3, $t1
add $t3, $t3, $t2
lw $t7, 0($t3)
j endB

endB: 




#set C[i][j] in t9 then store to c ($s4)
mul $t8, $t7, $t8			#A[i][k]*B[k][j]
add $t5, $t5, $t8						#update sum
addi $s3, 1  #increment k



j MULTIPLY



#-----------------------------------------------------FILL MATRIX FUNCTION--------------------------------------------------------------------------#



colslideP:    #address of A in a4
move $s4, $a1
 
 li $t6, 2 #number rows and column
 addiu $t1, $s1, -1
addiu $t2, $s2, -1


 li $t4, 8 # size row
 li $t5, 4  #size column
 mul $t1, $t1, $t4 # row index
 mul $t2, $t2, $t5 # column index
 add $s4, $s4, $t1 #add offsets to addres
 add $s4, $s4, $t2 
 li $v0, 5    #get imput
syscall


move $t0, $v0
sw $t0, 0($s4)
 li $t6, 2
 div $s2, $t6
 mfhi $t6
 beqz $t6, endrowP
 addiu $s2, $s2, 1
 j colslideP



endrowP: li $s2, 1 #reset col index
li $v0, 4
la $a0, eol
syscall
li $t6, 2
div $s1, $t6
mfhi $t6
beqz $t6, doneP
addi $s1, $s1, 1
j colslideP
doneP: jr $ra
 



#-----------------------------------------------------PRINT 2*2 MATRIX FUNCTION-------------------------------------------------------------------------#
li $v0, 4
la $a0, msg3
syscall 


colslide:    #address of A in a4
move $s4, $a1
 
 li $t6, 2 #number rows and column
 addiu $t1, $s1, -1
addiu $t2, $s2, -1
 li $t4, 8 # size row
 li $t5, 4  #size column
 mul $t1, $t1, $t4 # row index
 mul $t2, $t2, $t5 # column index
 add $s4, $s4, $t1 #add offsets to addres
 add $s4, $s4, $t2 
 li $v0, 1
 lw $a0, 0($s4)
 syscall
 li $v0, 4
 la $a0, space
 syscall
 li $t6, 2
 div $s2, $t6
 mfhi $t6
 beqz $t6, endrow
 addiu $s2, $s2, 1
 j colslide



endrow: li $s2, 1 #reset col index
li $v0, 4
la $a0, eol
syscall
li $t6, 2
div $s1, $t6
mfhi $t6
beqz $t6, done
addi $s1, $s1, 1
j colslide

done: jr $ra


