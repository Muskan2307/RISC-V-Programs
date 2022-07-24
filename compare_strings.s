#Muskan
#2020CSB1100
#The function is not case-sensitive
#Characters except english upper case and lower case letters are also allowed to be the part of input strings
#Total number of different characters are stored in x7 as welll as x10 after computation
#The function return with error code equal to the no. of different characters
#Two strings are taken in input as well as length is taken as input in byte
#String1 stored at location 0x10001000 in memory
#String2 stored at location 0x10002000 in memory
.data
seq1: .asciiz "heyhowareYou$#$"     
seq2: .asciiz "hellolareyouD##"
len: .byte 15
.text
#Storing strings
    la a1 seq1         #Loading address of string 1
    lui a0 65537       #Store address
    loop:
    lbu      t0, 0(a1)    # Load a char from the src
    sb      t0, 0(a0)    # Store the value of the src
    beq     t0, x0, exit # Check if it's 0
    addi    a0, a0, 1    # Advance destination one byte
    addi    a1, a1, 1    # Advance source one byte
    jal     x0, loop     # Go back to the start of the loop
    exit:
    la a1 seq2        #Loading address of string 2
    lui a0 65538      #Store address
    loop1:
    lbu      t0, 0(a1)    # Load a char from the src
    sb      t0, 0(a0)    # Store the value of the src
    beq     t0, x0, exit2 # Check if it's 0
    addi    a0, a0, 1    # Advance destination one byte
    addi    a1, a1, 1    # Advance source one byte
    jal     x0, loop1     # Go back to the start of the loop
    exit2:
    addi x7 x0 0  #Calculating no. of diff characters till now initialising with 0
    la a1 seq1    # Loading address of string 1 stored in memory initially
    la a2 seq2    # Loading address of string 2 stored in memory initially
    loop3:
    lbu t0 0(a1)
    lbu t1 0(a2)
    beq t0 x0 exit3  #End of string
    beq t0 t1 exit4  #Matches
    addi t3 x0 65    # Char with ascii less than A
    blt t0 t3 exit5
    blt t1 t3 exit5  #Add1 as case sensitivity is only for english letters
    addi t3 x0 122   # Char with ascii greater than z
    bgt t0 t3 exit5
    bgt t1 t3 exit5  #Add1 as case sensitivity is only for english letters
    addi t3 x0 91    #Ascii 91,92,93,94,95,96 is not for eng char therefore add1 as issue of sensitivity will not arise
    beq t0 t3 exit5
    beq t1 t3 exit5
    addi t3 x0 92  
    beq t0 t3 exit5
    beq t1 t3 exit5
    addi t3 x0 93
    beq t0 t3 exit5
    beq t1 t3 exit5
    addi t3 x0 94
    beq t0 t3 exit5
    beq t1 t3 exit5
    addi t3 x0 95
    beq t0 t3 exit5
    beq t1 t3 exit5
    addi t3 x0 96
    beq t0 t3 exit5
    beq t1 t3 exit5
    addi t3 t0 32      #If not matched initially because of case sensitivity but are identical if case insensitive
    beq t3 t1 exit4
    addi t4 t1 32
    beq t4 t0 exit4    #If not matched initially because of case sensitivity but are identical if case insensitive
    exit5:
    addi x7 x7 1       #Adding 1 if diff
    exit4:
    addi a1 a1 1      # Pointing to next char
    addi a2 a2 1      # Pointing to next char
    beq x0 x0 loop3
    exit3:
    add x10 x7 x0     # Copying x7 in x10 to get the the expected output as error code also