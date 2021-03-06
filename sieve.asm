# Code adapted from http://www.marcell-dietl.de/downloads/eratosthenes.s
	
	.data			# the data segment to store global data


init:	sw	$s1, ($sp)	# write ones to the stackpointer's address
	add	$t0, $t0, 1	# increment counter variable
	sub	$sp, $sp, 4	# subtract 4 bytes from stackpointer (push)
	ble	$t0, $t9, init	# take loop while $t0 <= $t9

	li	$t0, 1		# reset counter variable to 1

outer:	add 	$t0, $t0, 1	# increment counter variable (start at 2)
	sll	$t1, $t0, 1	# multiply $t0 by 2 and save to $t1
	bgt	$t1, $t9, print	# start printing prime numbers when $t1 > $t9

check:	add	$t2, $s2, 0	# save the bottom of stack address to $t2
	sll	$t3, $t0, 2	# calculate the number of bytes to jump over
	sub	$t2, $t2, $t3	# subtract them from bottom of stack address
	add	$t2, $t2, 8	# add 2 words - we started counting at 2!

	lw	$t3, ($t2)	# load the content into $t3

	beq	$t3, $s0, outer	# only 0's? go back to the outer loop

inner:	add	$t2, $s2, 0	# save the bottom of stack address to $t2
	sll	$t3, $t1, 2	# calculate the number of bytes to jump over
	sub	$t2, $t2, $t3	# subtract them from bottom of stack address
	add	$t2, $t2, 8	# add 2 words - we started counting at 2!

	sw	$s0, ($t2)	# store 0's -> it's not a prime number!

	add	$t1, $t1, $t0	# do this for every multiple of $t0
	bgt	$t1, $t9, outer	# every multiple done? go back to outer loop

	j	inner		# some multiples left? go back to inner loop

print:	li	$t0, 1		# reset counter variable to 1
count:	add	$t0, $t0, 1	# increment counter variable (start at 2)

	bgt	$t0, $t9, exit	# make sure to exit when all numbers are done

	add	$t2, $s2, 0	# save the bottom of stack address to $t2
	sll	$t3, $t0, 2	# calculate the number of bytes to jump over
	sub	$t2, $t2, $t3	# subtract them from bottom of stack address
	add	$t2, $t2, 8	# add 2 words - we started counting at 2!

	lw	$t3, ($t2)	# load the content into $t3
	beq	$t3, $s0, count	# only 0's? go back to count loop

	add	$t3, $s2, 0	# save the bottom of stack address to $t3

	sub	$t3, $t3, $t2	# substract higher from lower address (= bytes)
	srl	$t3, $t3, 2	# divide by 4 (bytes) = distance in words
	add	$t3, $t3, 2	# add 2 (words) = the final prime number!

	li	$v0, 1		# system code to print integer
	add	$a0, $t3, 0	# the argument will be our prime number in $t3
	syscall			# print it!

	li	$v0, 4		# system code to print string
	la	$a0, space	# the argument will be a whitespace
	syscall			# print it!

	ble	$t0, $t9, count	# take loop while $t0 <= $t9

exit:	li	$v0,10		# set up system call 10 (exit)
	syscall	
