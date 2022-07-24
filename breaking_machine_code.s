#Muskan
#2020CSB1100
#Machine code is read from .data for different instructions
#Storing 12 bit immediate value as it is without appending zero as halfword in the memory without sign extension
#Order of storing bits in memory:-
#First 7 Opcode bits are stored as byte starting from 0x10001000 mem location
#Next 3 function3 bits are stored as byte
#Then storing 7 function7 bits as byte(if function7 is applicable)
#Then storing 5 Rd bits as byte (if applicable)
#Then storing 5 Rs1 bits as byte
#Then storing 5 Rs2 bits as byte (if applicable)
#Then storing 12 immediate bits as halfword (if applicable)
#Error code is insignificant as only memory has to be filled correctly and registers have to be correct but no return value is expected as output
.data
#ins1: .word 0b00001110100101010011100000100011  # store
#ins1: .word 0b00000000100110101000010010110011 # add
#ins1: .word 0b101010011000100001100011 #beq
#ins1: .word 0b00001111000001010011010010000011 #I type
ins1: .word 0b00001111000001010011010010010011 #I type slti
.text
la a0 ins1  #Loading address of instruction
lui a1 0x10001   #Initialising a1 with 0x10001000
lw t0 0(a0)
addi t1 x0 0b01111111   #Extracting opcode
and t2 t0 t1
addi t3 x0 0b00110011    # R type opcode
beq t2 t3 R
addi t3 x0 0b00000011  # I type opcode(add immediate)
beq t2 t3 I
addi t3 x0 0b00010011  # I type opcode (for slti)
beq t2 t3 I
addi t3 x0 0b00100011  # S type opcode
beq t2 t3 S
addi t3 x0 0b01100011  # SB type opcode
beq t2 t3 S_B
R:
addi t1 x0 0b01111111 # Opcode bits
and t2 t0 t1          # Extracting opcode bits
sb t2 0(a1)           # Storing opcode bits
addi a1 a1 1          # Incrementing storage address
lui t1 0b0111         # Function3 bits
and t2 t0 t1          # Extracting function3 bits
srli t2 t2 12
sb t2 0(a1)           # Storing function3 bits
addi a1 a1 1          # Incrementing storage address
addi t1 x0 0b1111111  # Function7 bits
slli t1 t1 25        
and t2 t0 t1          # Extracting function7 bits
srli t2 t2 25
sb t2 0(a1)           # Storing function7 bits
addi a1 a1 1          # Incrementing storage address
addi t1 x0 0b011111   
slli t1 t1 7          # Rd destination reg. bits
and t2 t0 t1          # Extracting Rd bits
srli t2 t2 7
sb t2 0(a1)           # Storing Rd bits
addi a1 a1 1          # Incrementing storage address
addi t1 x0 0b011111   
slli t1 t1 15          # Rs1 source reg.1 bits
and t2 t0 t1           # Extracting Rs1 bits
srli t2 t2 15      
sb t2 0(a1)            # Storing Rs1 bits
addi a1 a1 1           # Incrementing storage address
addi t1 x0 0b011111   
slli t1 t1 20          # Rs2 source reg.2 bits
and t2 t0 t1           # Extracting Rs2 bits
srli t2 t2 20      
sb t2 0(a1)            # Storing Rs2 bits
beq x0 x0 exit
I:
addi t1 x0 0b01111111 # Opcode bits
and t2 t0 t1          # Extracting opcode bits
sb t2 0(a1)           # Storing opcode bits
addi a1 a1 1          # Incrementing storage address
lui t1 0b0111         # Function3 bits
and t2 t0 t1          # Extracting function3 bits
srli t2 t2 12
sb t2 0(a1)           # Storing function3 bits
addi a1 a1 1          # Incrementing storage address
addi t1 x0 0b011111   
slli t1 t1 7          # Rd destination reg. bits
and t2 t0 t1          # Extracting Rd bits
srli t2 t2 7
sb t2 0(a1)           # Storing Rd bits
addi a1 a1 1          # Incrementing storage address
addi t1 x0 0b011111   
slli t1 t1 15          # Rs1 source reg.1 bits
and t2 t0 t1           # Extracting Rs1 bits
srli t2 t2 15      
sb t2 0(a1)            # Storing Rs1 bits
addi a1 a1 1           # Incrementing storage address
lui t1 0b11111111111100000000   # Immediate bits
and t2 t0 t1                    # Extracting Immediate bits
srli t2 t2 20
sh t2 0(a1)                     # Storing Immediate bits as half word
beq x0 x0 exit                  # Exit
S:
addi t1 x0 0b01111111 # Opcode bits
and t2 t0 t1          # Extracting opcode bits
sb t2 0(a1)           # Storing opcode bits
addi a1 a1 1          # Incrementing storage address
lui t1 0b0111         # Function3 bits
and t2 t0 t1          # Extracting function3 bits
srli t2 t2 12
sb t2 0(a1)           # Storing function3 bits
addi a1 a1 1          # Incrementing storage address
addi t1 x0 0b011111   
slli t1 t1 15          # Rs1 source reg.1 bits
and t2 t0 t1           # Extracting Rs1 bits
srli t2 t2 15      
sb t2 0(a1)            # Storing Rs1 bits
addi a1 a1 1           # Incrementing storage address
addi t1 x0 0b011111   
slli t1 t1 20          # Rs2 source reg.2 bits
and t2 t0 t1           # Extracting Rs2 bits
srli t2 t2 20      
sb t2 0(a1)            # Storing Rs2 bits
addi a1 a1 1           # Incrementing storage address
addi t1 x0 0b1111111   #Extracting imm[11:5]
slli t1 t1 25
and t3 t0 t1
srli t3 t3 20
addi t1 x0 0b11111     #Extracting imm[4:0]
slli t1 t1 7
and t4 t0 t1
srli t4 t4 7
add t2 t3 t4          #Collecting the immediate
sh t2 0(a1)           #Storing the immediate as half word
beq x0 x0 exit
S_B:
addi t1 x0 0b01111111 # Opcode bits
and t2 t0 t1          # Extracting opcode bits
sb t2 0(a1)           # Storing opcode bits
addi a1 a1 1          # Incrementing storage address
lui t1 0b0111         # Function3 bits
and t2 t0 t1          # Extracting function3 bits
srli t2 t2 12
sb t2 0(a1)           # Storing function3 bits
addi a1 a1 1          # Incrementing storage address
addi t1 x0 0b011111   
slli t1 t1 15          # Rs1 source reg.1 bits
and t2 t0 t1           # Extracting Rs1 bits
srli t2 t2 15      
sb t2 0(a1)            # Storing Rs1 bits
addi a1 a1 1           # Incrementing storage address
addi t1 x0 0b011111   
slli t1 t1 20          # Rs2 source reg.2 bits
and t2 t0 t1           # Extracting Rs2 bits
srli t2 t2 20      
sb t2 0(a1)            # Storing Rs2 bits
addi a1 a1 1           # Incrementing storage address
addi t1 x0 0b01111     # Extracting imm[4:1]
slli t1 t1 8
and t3 t0 t1
srli t3 t3 8
addi t1 x0 0b0111111    # Extracting imm[10:5]
slli t1 t1 25
and t4 t0 t1
srli t4 t4 21
addi t1 x0 0b01         #Extracting imm[11]
slli t1 t1 7
and t5 t0 t1
slli t5 t5 3
addi t1 x0 0b01         #Extracting imm[12]
slli t1 t1 31
and t6 t0 t1
srli t6 t6 20
add t2 t3 t4            #Collecting the whole immediate
add t2 t2 t5
add t2 t2 t6
sh t2 0(a1)             #Storing the immediate as halfword
beq x0 x0 exit

exit: