#Muskan
#2020CSB1100
#Input is taken in accordance with the format mentioned a space in between but no space at start or end in the form of string
#Register a2 is used to store the size of queue after each update(enqueue or dequeue)
#Register s0 (front) stores the address of the first element in the queue, each time a dequeue is performed it is incremented by 4 to point to next element
#Register s1 (rear) points to the address location where next enque operation can be performed after each enqueue it is incremented by four
#No change at the memory is made during dequeue but the s0 is adjusted accordingly so that the element is no longer a part of queue
#Each enqueued element gets stored at memory as word(32 bits)
#Both negative and positive numbers are allowed to be enqueued
#Whenever S is called size of the queue gets stored to mem location 0x10005000
#Extra Dequeue operations are ignored
#String is case sensitive i.e. E,D,S are required to be written for performing the correct operations(e,d,s not allowed)
#Error code is insignificant as only memory has to be filled correctly and registers have to be correct but no return value is expected as output
.data
#seq: .asciiz "E -20 E 40 D S E 546 E 123 E -456 D D S D D D D D D D D S"   #Input Sequence
seq: .asciiz "E 20 E 40 D S E 46 E 13 E -4 D D S"   #Input Sequence
.text
la a0 seq           #a0 storing sequence address
lui a4 0x10005      #a4 storing address of memory where size has to be placed whenever demanded
addi a2 x0 0      #Initialising size of queue
lui s0 0x10001    #Initialising front of queue
lui s1 0x10001    #Initialising rear of queue
loop:
lb t0 0(a0)       #Loading char from input sequence
beq t0 x0 exit    #End of string
addi t1 x0 69     #Enqueue
beq t0 t1 E
addi t1 x0 68     #Dequeue
beq t0 t1 D
addi t1 x0 83     #Size
beq t0 t1 S
#Enqueue operation
E:
addi t6 x0 0   #Acting as sign bit
addi a0 a0 2   
addi t3 x0 0   #Temp reg used for computing int value from no. of characters
addi t4 x0 10  #Temp reg used for computing int value
lb t0 0(a0)
addi t5 x0 45
bne t0 t5 loop1
addi a0 a0 1   #Ignoring - sign
addi t6 x0 1   #Sign bit set to 1
loop1:
lb t0 0(a0)
addi t1 x0 32  #Marking end of element to be enqueued by space
beq t0 t1 eexit
beq t0 x0 eexit    #Marking end of input string
addi t0 t0 -48  # Ascii value of '0' is 48
mul t3 t3 t4     # Computing value out of characters
add t3 t3 t0
addi a0 a0 1    #Pointing to next input character
beq x0 x0 loop1 
eexit:
beq t6 x0 pos
sub t3 x0 t3     #Handling neg numbers
pos:
sw t3 0(s1)
addi s1 s1 4     #Incrementing rear
addi a2 a2 1     #Incrementing size
beq t0 x0 exit   #End of input seq
addi a0 a0 1
beq x0 x0 loop
#Dequeue Operation
D:
beq a2 x0 dexit   #Queue empty
addi a2 a2 -1     #Decrementing size
addi s0 s0 4      #Incrementing front
dexit:
lb s2 1(a0)
beq s2 x0 exit   #End of input seq
addi a0 a0 2
beq x0 x0 loop
#Size operation
S:
sb a2 0(a4)      #Storing size at mam location 0x10005000
lb s2 1(a0)      #End of input seq
beq s2 x0 exit
addi a0 a0 2
beq x0 x0 loop
exit: