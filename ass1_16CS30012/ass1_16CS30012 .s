# *********************************************************************************************************************
# Ishwarkar Rohan Shankar
# 16CS30012
# Compilers Assignment 1 
# Date:- 24/07/2018
# Add comments for each of the assembly language instruction. Your comment should explain
# the functionality of the instruction and the connection to the original C program.
# *********************************************************************************************************************

# *********************************************************************************************************************
# //asgn1.c - Original C program
# #include <stdlib.h>
# #include <stdio.h>
# double monteCarlo(long int n);
# double iSeries(long int n);
# int main()
# {
# 	long int num;
# 	double piD1,piD2;
# 	printf("Number of iterations to estimate PI: ");
# 	scanf("%ld",&num);
# 	piD1=monteCarlo(num);
# 	piD2=iSeries(num);
# 	printf("\nPI: %10.8lf (using Infinite Series)",piD2);
# 	printf("\tPI: %10.8lf (using Monte Carlo method)\n\n",piD1);
# 	return 0;
# }

# double iSeries(long int n)
# {
# 	int i;
# 	double pi=0.0;
# 	for(i=1;i<=n;i++) 
# 	{
# 		if(i%2==0) 
# 			pi-=(4.0/(2*i-1));
# 		else 
# 			pi+=(4.0/(2*i-1));
# 	}
# 	return pi;
# }
# double monteCarlo(long int n)
# {
# 	double x,y;
# 	int i,count=0;
# 	srand(12345);
# 	for(i=1;i<=n;i++) 
# 	{
# 		x = (double)rand()/RAND_MAX;
# 		y = (double)rand()/RAND_MAX;
# 		if ((x*x+y*y)<=1) 
# 			count++;
# 	}
# 	return (double)count/n*4.0;
# }    //asgn1.c - Original C Program

# *********************************************************************************************************************




# *********************************************************************************************************************

	.file	"asgn1.c"   # source file name
	.text
	.section	.rodata # read-only data section
	.align 8            # align with 8-byte boundary
.LC0:                   # Label of f-string-1st printf(which prints below statement in C)
	.string	"Number of iterations to estimate PI: "
.LC1:                   # Label of f-string scanf(which takes the input of number of iterations)
	.string	"%ld"
	.align 8            # align with 8-byte boundary
.LC2:					# Label of f-string-2nd printf(which prints the result of Infinite series in C)
	.string	"\nPI: %10.8lf (using Infinite Series)"
	.align 8            # align with 8-byte boundary
.LC3:					# Label of f-string-3rd printf(which prints the result of Monte Carlo in C)
	.string	"\tPI: %10.8lf (using Monte Carlo method)\n\n"
	.text				# This part defines the start of code
	.globl	main		# main is the global name
	.type	main, @function   # main is a function: (ie. type of main is function)



# *********************************************************************************************************************	

main:					# The main function starts
.LFB5:
	.cfi_startproc      	 # Initializes some internal data structures and emits initial CFI instructions.
	pushq	%rbp			 # Save old base pointer 
	.cfi_def_cfa_offset 16   # Change rule for CFA to use offset 16. Register remains the same.
	.cfi_offset 6, -16       # Generate a rule saying that register 6 is saved at offset -16 from CFA.
	movq	%rsp, %rbp		 # rbp <-- rsp, set new stack base pointer (q for quadword)
	.cfi_def_cfa_register 6  # Change rule for CFA to use offset 6. Register remains the same.
	subq	$48, %rsp		 # Create space for local array and variables
	movq	%fs:40, %rax  	 # Copy %fs:40 to %rax 
	movq	%rax, -8(%rbp) 	 # Copy %rax to -8(%rbp)
	xorl	%eax, %eax 		 # %eax = %eax^%eax ie %eax = 0 
	leaq	.LC0(%rip), %rdi	# Load effective address of Label LC0 in %rdi ie parameter of 1st printf in C program
	movl	$0, %eax 			# %eax=0
	call	printf@PLT			# Calls the printf function to print the first printf statement in C.(Number of iterations to estimate PI)
	leaq	-32(%rbp), %rax 	# Load address of -32(%rbp) into %rax
	movq	%rax, %rsi 			# Copy %rax to %rsi
	leaq	.LC1(%rip), %rdi 	# Load address to store the value of input variable ie parameter of scanf function in C program
	movl	$0, %eax 			# %eax=0
	call	__isoc99_scanf@PLT	# Calls the scanf function to get the input of number of iterations in C program
	movq	-32(%rbp), %rax 	# Copy -32(%rbp) to %rax ie %rax = num in C program
	movq	%rax, %rdi 			# Copy %rax to %rdi  ie %rdi = num in C program. This is the parameter of MonteCarlo Function called below
	call	monteCarlo			# Calls the Monte Carlo function to calculate the required value using the Monte-Carlo function.
	movq	%xmm0, %rax  		# After calling Monte Carlo Function Result is stored in %xmm0. Copy the result in %rax
	movq	%rax, -24(%rbp) 	# Copy %rax to -24(%rbp)
	movq	-32(%rbp), %rax 	# Copy -32(%rbp) to %rax %rax = num in C Program
	movq	%rax, %rdi 			# Copy %rax to %rdi, %rdi = num in C program. Parameter of the iseries function called below.
	call	iSeries				# Calls the iSeries function to calculate the required value using the iseries function.
	movq	%xmm0, %rax 		# After calling the iseries function result is stored in %xmm0. Copy the result to %rax.
	movq	%rax, -16(%rbp) 	# Store the output of iseries  at -16(%rbp) 
	movq	-16(%rbp), %rax  	# Copy output of iseries to %rax
	movq	%rax, -40(%rbp) 	# Copy output of iseries to -40(%rbp)
	movsd	-40(%rbp), %xmm0 	# Copy output of iseries to %xmm0
	leaq	.LC2(%rip), %rdi 	# Lead effective address of Second printf statement in %rdi which prints the result of Iseries function
	movl	$1, %eax 			# %eax=1
	call	printf@PLT			# Calls the printf function to print the value returned by above iseries call.
	movq	-24(%rbp), %rax 	# Copy output of Monte Carlo to %rax
	movq	%rax, -40(%rbp)		# Copy output of Monte Carlo to -40(%rbp)	
	movsd	-40(%rbp), %xmm0 	# Copy output of Monte Carlo to %xmm0
	leaq	.LC3(%rip), %rdi 	# Load effective address of Third printf statement in %rdi which prints the value of MonteCarlo function
	movl	$1, %eax    		# %eax=1
	call	printf@PLT			# Calls the printf function to print the value returned by above Monte-Carlo call
	movl	$0, %eax 			# %eax = 0
	movq	-8(%rbp), %rdx   	# Copy -8(%rbp) to %rdx
	xorq	%fs:40, %rdx  		# %rdx = %rdx ^ %fs:40
	je	.L3 					# Jump if zero
	call	__stack_chk_fail@PLT# Doing a sanity check of the stack before it pops the stack and does a return
.L3:
	leave 						# Copy EBP to ESP and then restore the old EBP from the stack
	.cfi_def_cfa 7, 8 			# Set a rule for computing CFA to: take content of register 7 and add 8 to it.
	ret 						# Pop return address from stack and jump to popped address( Here it goes to the main function in C)
	.cfi_endproc 				# Opens .eh_frame, generates appropriate binary structures (CIE, FDE) and sets up relocation records.


# *********************************************************************************************************************


.LFE5:
	.size	main, .-main
	.globl	iseries 			# iseries is the global name
	.type	iSeries, @function  # iseries is a function
iSeries:						# iseries function starts

						 
.LFB6:
	.cfi_startproc				# Initializes some internal data structures and emits initial CFI instructions.
	pushq	%rbp				# Save old base pointer	
	.cfi_def_cfa_offset 16		# Change rule for CFA to use offset 16. Register remains the same.
	.cfi_offset 6, -16			# Generate a rule saying that register 6 is saved at offset -16 from CFA.
	movq	%rsp, %rbp			# rbp <-- rsp, set new stack base pointer (q for quadword)
	.cfi_def_cfa_register 6		# Change rule for CFA to use offset 6. Register remains the same.
	movq	%rdi, -24(%rbp)		# Store the value of n in -24(%rbp)	
	pxor	%xmm0, %xmm0  		# %xmm0 = %xmm0 ^ %xmm0 ie. %xmm0 = 0
	movsd	%xmm0, -8(%rbp)   	# Copy %xm0 to -8(%rbp)  ie. -8(%rbp) = 0 (Initilization of the value of pi in iseries function in C program)
	movl	$1, -12(%rbp)		# 1 ----> -12(%rbp) initilization of the value of i in iseries function in C Program
	jmp	.L5  					# Jump to Label L5 which is for loop label in C program.


.L8:  							# Label of For loop content
	movl	-12(%rbp), %eax 	# %eax = i as -12(%rbp) = i
	andl	$1, %eax 			# %eax = %eax & 1 (Check i%2 in iSeries function in C program)
	testl	%eax, %eax 			# %eax = %eax & %eax. Here if i is odd ie. (i%2!=0) then %eax = 1
	jne	.L6 					# Jump if not equal to zero(Else part of the for loop in iSeries function in C )
	movl	-12(%rbp), %eax 	# %eax = i  (Now we process if(i%2==0) part of iSeries function in C Program)
	addl	%eax, %eax 			# %eax = %eax+%eax (2*i in C program)
	subl	$1, %eax 			# %eax = %eax -1 (2*i-1  in C program)
	cvtsi2sd	%eax, %xmm0    	# Typecast %eax to double precision floating point value and store in %xmm0
	movsd	.LC5(%rip), %xmm1 	# %xmm1 = 4.0
	divsd	%xmm0, %xmm1		# %xmm1 = %xmm1/%xmm0 (4.0/(2*i-1)  in C program)
	movapd	%xmm1, %xmm0 		# %xmm1 ----> %xmm0  (%xmm0 = 4.0/(2*i-1)) Just copy the result
	movsd	-8(%rbp), %xmm1		# %xmm1 = pi as value of pi is stored in -8(%rbp)
	subsd	%xmm0, %xmm1		# %xmm1 = %xmm1 - %xmm0 (pi-=(4.0/(2*i-1)) in C program)
	movapd	%xmm1, %xmm0 		# %xmm1 ---->%xmm0 Copy %xmm1 into %xmm0
	movsd	%xmm0, -8(%rbp) 	# %xmm0 ---->-8(%rbp)  (Update the value of pi in -8(%rbp) )
	jmp	.L7 					# Jump to label L7 which increases the value of i by 1


.L6:							# Else part of iseries function in C( when i%2!=0 in the C program)
	movl	-12(%rbp), %eax  	# %eax = i  (Now we process if(i%2!=0) part of iSeries function in C Program)
	addl	%eax, %eax 			# %eax = %eax+%eax (2*i in C program)
	subl	$1, %eax 			# %eax = %eax -1 (2*i-1  in C program)
	cvtsi2sd	%eax, %xmm0  	# Typecast %eax to double precision floating point value and store in %xmm0
	movsd	.LC5(%rip), %xmm1 	# %xmm1 = 4.0
	divsd	%xmm0, %xmm1 		# %xmm1 = %xmm1/%xmm0 (4.0/(2*i-1)  in C program)
	movapd	%xmm1, %xmm0 		# %xmm1 ----> %xmm0  (%xmm0 = 4.0/(2*i-1))
	movsd	-8(%rbp), %xmm1 	# %xmm1 = pi as pi is stored at -8(%rbp)
	addsd	%xmm1, %xmm0 		# %xmm1 = %xmm1  + %xmm0 (pi+=(4.0/(2*i-1)) in C program)
	movsd	%xmm0, -8(%rbp) 	# %xmm0 ---->-8(%rbp)  (Update the value of pi)


.L7:
	addl	$1, -12(%rbp)		# i = i + 1 and updated i value stored in -12(%rbp)



.L5:							# For loop label of iseries function in C program.
	movl	-12(%rbp), %eax 	# Copy -12(%rbp) ----> %eax ie %eax = i because -12(%rbp) = i
	cltq						# Convert double word in %eax to quadword in %rax. So i is converted to quadword and stored in %rax
	cmpq	%rax, -24(%rbp)		# Compare i with n as n is stored in -24(%rbp) 
	jge	.L8						# Jump if greater than or equal to(Jump to Label L8 if n-i>=0)
	movsd	-8(%rbp), %xmm0 	# Copy -8(%rbp) to %xmm0 as -8(%rbp) = pi (After the for loop)
	popq	%rbp   				# Pop from %rbp
	.cfi_def_cfa 7, 8			# Set a rule for computing CFA to: take content of register 7 and add 8 to it.
	ret  						# Pop return address from stack and jump to the popped address.(Returns to the main function)
	.cfi_endproc				# Opens .eh_frame, generates appropriate binary structures (CIE, FDE) and sets up relocation records.


# *********************************************************************************************************************


.LFE6:
	.size	iSeries, .-iSeries
	.globl	monteCarlo  			# montecarlo is a global name
	.type	monteCarlo, @function 	# montecarlo is a function
monteCarlo: 						# montecarlo function starts


.LFB7:
	.cfi_startproc			# Initializes some internal data structures and emits initial CFI instructions.
	pushq	%rbp			# Save old base pointer
	.cfi_def_cfa_offset 16	# Change rule for CFA to use offset 16. Register remains the same.
	.cfi_offset 6, -16		# Generate a rule saying that register 6 is saved at offset -16 from CFA.
	movq	%rsp, %rbp		# rbp <-- rsp, set new stack base pointer (q for quadword)
	.cfi_def_cfa_register 6	# Change rule for CFA to use offset 6. Register remains the same.
	subq	$48, %rsp		# Create space for local array and variables
	movq	%rdi, -40(%rbp) # Store the value of n in -40(%rbp).
	movl	$0, -20(%rbp)	# Set value of -20(%rbp) to zero (Corresponds to count=0; in Monte Carlo function in C program)
	movl	$12345, %edi	# Copy the value 12345 to %edi
	call	srand@PLT		# Call SRAND function(Corresponds to srand(12345); in Monte Carlo function in C program )
	movl	$1, -24(%rbp)	# Copy value 1 to -24(%rbp)(Corresponds to assigning value of 1 to i in for loop in Monte Carlo function in C program )
	jmp	.L11				# Jump to for loop label .L11 (The only for loop in Monte_carlo Function in C)


.L14:						# The for loop code in Monte Carlo Function is contained in this label
	call	rand@PLT		# Call random function to generate a random integer(This is the first rand() call in MonteCarlo function in C program)
	cvtsi2sd	%eax, %xmm0	# Convert the above integer to double precision floating point value(This is the casting function (double) in Monte Carlo function in C program)
	movsd	.LC6(%rip), %xmm1	# Get the value of RAND_MAX from .LC6(%rip) in %xmm1 ie. %xmm1 = RAND_MAX;
	divsd	%xmm1, %xmm0	# %xmm0 = %xmm0/%xmm1.  Corresponds to (x = (double)rand()/RAND_MAX;) in C program
	movsd	%xmm0, -16(%rbp)# -16(%rbp) ---->  (double)rand()/RAND_MAX; Copy the above calculated value
	call	rand@PLT		# Call random function to generate a random integer(This is the second rand() call in MonteCarlo function in C program)
	cvtsi2sd	%eax, %xmm0	# Convert the above integer to double precision floating point value(This is the casting function (double) in Monte Carlo function in C program)
	movsd	.LC6(%rip), %xmm1	# Get the value of RAND_MAX from .LC6(%rip) in %xmm1
	divsd	%xmm1, %xmm0	# %xmm0 = %xmm0/%xmm1  Corresponds to y = (double)rand()/RAND_MAX; in C program
	movsd	%xmm0, -8(%rbp)	# -8(%rbp)  ---->  (double)rand()/RAND_MAX;
	movsd	-16(%rbp), %xmm0# %xmm0 = x(C Program)
	movapd	%xmm0, %xmm1	# %xmm0  ---->  %xmm1
	mulsd	-16(%rbp), %xmm1# %xmm1 = %xmm1*-16(%rbp)  ie %xmm1 = x*x in C program
	movsd	-8(%rbp), %xmm0	# %xmm0 = y(C program)
	mulsd	-8(%rbp), %xmm0	# %xmm0 = %xmm0 * -8(%rbp)  ie %xmm0 = y*y in C program
	addsd	%xmm1, %xmm0	# %xmm0 = %xmm0 + %xmm1
	movsd	.LC7(%rip), %xmm1	# .LC7(%rip) ----> %xmm1 (Value of 1)
	ucomisd	%xmm0, %xmm1	#Compare the value in %xmm0 and %xmm1 (Corresponds to this comparison in C program: (x*x+y*y)<=1)
	jb	.L12				# Jump if below to Label L12 (if ((x*x+y*y)<=1) statement in MonteCarlo function in C)
	addl	$1, -20(%rbp)	# Increase the value of -20(%rbp)(Corresponds to increase the value of count  ie count++; in Monte Carl function in C program)


.L12:
	addl	$1, -24(%rbp)	# Increase the value of i by 1.(Corresponds to i++ of for loop in Monte Carlo function of C program)


.L11:						# For loop label(The only for loop in Monte Carlo function in C)
	movl	-24(%rbp), %eax # Here -24(%rbp) has the value of i. therefore  %eax = i
	cltq					# Convert double word in %eax to quadword in %rax. So i is converted to quadword and stored in %rax
	cmpq	%rax, -40(%rbp) # Sets condition codes according to -40(%rbp)-%rax.(Here it corresponds to n-i)
	jge	.L14				# Jump if greater than or equal to ie if n>=i then Jump to Label .L14
	cvtsi2sd	-20(%rbp), %xmm0	# xmm0 has the value of count in double precision floating point value(This corresponds to typecast (double)count in C program)
	cvtsi2sdq	-40(%rbp), %xmm1	# xmm1 has the value of n in double precision floating point
	divsd	%xmm1, %xmm0			# Divide count/n  %xmm0 = %xmm0/%xmm1
	movsd	.LC5(%rip), %xmm1		# Get the value of 4.0 from the label .LC5 ie %xmm1=4.0
	mulsd	%xmm1, %xmm0			# Multiply above result by 4.0 (Corresponds to (double)count/n*4.0 in the Monte Carlo function in C program )
	leave							# Copy EBP to ESP and then restore the old EBP from the stack
	.cfi_def_cfa 7, 8		# Set a rule for computing CFA to: take content of register 7 and add 8 to it.
	ret  					# Pop return address from stack and jump to popped address( Here it goes to the main function in C)
	.cfi_endproc			# Opens .eh_frame, generates appropriate binary structures (CIE, FDE) and sets up relocation records.


# *********************************************************************************************************************


.LFE7:
	.size	monteCarlo, .-monteCarlo
	.section	.rodata
	.align 8
.LC5:      						# Label to store long value 4
	.long	0
	.long	1074790400
	.align 8
.LC6: 							# Label to store value of RANDMAX
	.long	4290772992
	.long	1105199103
	.align 8
.LC7:    						# Label to store the value of 1
	.long	0
	.long	1072693248
	.ident	"GCC: (Ubuntu 7.3.0-16ubuntu3) 7.3.0"
	.section	.note.GNU-stack,"",@progbits


