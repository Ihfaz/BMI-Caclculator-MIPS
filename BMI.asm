#Ihfaz Tajwar
#BMI Calculator
		
	.data
#Variables
name:	.space 40
nl:	.byte '\n'
null:	.byte '\0'
height:	.word 0
weight:	.word 0
bmi:	.double 0
val:	.double 18.5, 25.0, 30.0
#Prompts/Messages
m1:	.asciiz "What is your name? "
m2:	.asciiz "Please enter your height in inches (round to a whole number): "
m3:	.asciiz "Now enter your weight in pounds (round to a whole number): "
ans:	.asciiz ", your bmi is: "
c1:	.asciiz "\nThis is considered underweight. \n"
c2:	.asciiz "\nThis is a normal weight. \n"
c3:	.asciiz "\nThis is considered overweight. \n"
c4:	.asciiz "\nThis is considered obese. \n"
	
	.text
main:	li $v0,4	#First prompt (name)
	la $a0,m1
	syscall
	
	li $v0,8
	la $a0,name
	li $a1,40
	syscall
	
	jal del		#Removes the \n at the end
	
	li $v0,4	#Second prompt (height)
	la $a0,m2
	syscall
	
	li $v0,5
	syscall
	sw $v0,height
	
	li $v0,4	#Third prompt (weight)
	la $a0,m3
	syscall
	
	li $v0,5
	syscall
	sw $v0,weight
	
	#Caculating the bmi
	li $t0,703
	lw $t1,weight
	lw $t2,height
	mul $t1,$t1,$t0		#weight *= 703
	mul $t2,$t2,$t2		#height *= height
	
	mtc1.d $t1,$f0		#weight
	mtc1.d $t2,$f2		#height
		
	cvt.d.w $f0,$f0		#Casting weight from int to double
	cvt.d.w $f2,$f2		#Casting height from int to double
	
	div.d $f4,$f0,$f2	#bmi = weight/height
	s.d $f4,bmi		#Storing in memory
	
	li $v0,4
	la $a0,nl
	syscall
	
	#Output the results
	li $v0,4
	la $a0,name
	syscall
	
	li $v0,4
	la $a0,ans
	syscall
	
	li $v0,3
	l.d $f12,bmi
	syscall
	
	#Categorizing
	la $s0,val
	l.d $f0,bmi	#Load bmi
	l.d $f2,($s0)	#Load 18.5
	l.d $f4,8($s0)	#Load 25
	l.d $f6,16($s0)	#Load 30
	
	c.lt.d $f0,$f2
	bc1f ef1
	li $v0,4	#Underwewight
	la $a0,c1
	syscall
	j end
ef1:	c.lt.d $f0,$f4
	bc1f ef2
	li $v0,4	#Ideal weight
	la $a0,c2
	syscall
	j end
ef2:	c.lt.d $f0,$f6
	bc1f else
	li $v0,4	#Overwewight
	la $a0,c3
	syscall
	j end
else:	li $v0,4	#Obese
	la $a0,c4
	syscall
	
end:	li $v0,10	#End program
	syscall
	
	
	#Gets rid of \n at the end of string
del:	
	lb $s0,nl
	lb $s1,null
rep:	lb $s2,($a0)		#Load first char of name
	beq $s2,$s0,fin
	addi $a0,$a0,1		#Next char
	j rep
fin:	sb $s1,($a0)
	jr $ra
	
	
	
	
	
	
	
