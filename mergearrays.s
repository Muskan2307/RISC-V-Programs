#Muskan
#2020CSB1100
#Initialising the sorted arrays in .data section
#Specifying length (byte) of arrays in .data section (They are not strings therefore taking length as input is must)
#Initialising x11 and x12 with the starting addresses in .text section at the starting only
#Sorting done in ascending order
#Array elements are assumed to be in the range of byte only therefore declared in that way only in .data section (1 byte per element)
#Sorted array (Merged array) stored at location 0x10001000 with 1 byte assigned for 1 element i.e. add 1 to current to access the next
#Error code i.e. x10 set to zero at the end to check whether the function has ended properly
.data
    testArray1: .byte  -1,2,3,6,7,8,10   #Array1
    testArray2: .byte  -2,4,5,9,13,78    #Array2
    size1: .byte 7               # set this accordingly to testArray1 size
    size2: .byte 6               # set this accordingly to testArray2 size

.text
    la x11 testArray1           #Initialising x11 with array1's address
    la x12 testArray2           #Initialising x12 with array2's address
    la a0, testArray1           # Load testArray1 address  in a0
    la a1, testArray2           # Load testArray2 address  in a1
    lb t0, size1                # Size of array1
    lb t1, size2                # Size of array2
    add a2, a0, t0              # Calculate the last array1 element address
    add a2, a2, t1              # Calculate the last array2 element address
    jal merge                   # Call merge
    beq x0, x0, exit            # Exiting after merging the two arrays
#Merge function
merge:
   # Stack management
   addi sp, sp, -32              # Adjust stack pointer
   sw ra, 0(sp)                  # Load return address
   sw a0, 8(sp)                  # Load start address of first array
   sw a1, 16(sp)                 # Load start address of second array
   sw a2, 24(sp)                 # Load start address of second array
   mv s0, a0                     # First half address copy 
   mv s1, a1                     # Second half address copy
   mloop:
   mv t0, s0                     # copy first half position address
   mv t1, s1                     # copy second half position address
   lb t0, 0(t0)                  # Load first half position value
   lb t1, 0(t1)                  # Load second half position value   
   bgt t1, t0, skip              # If lower value is first, no need to perform operations
   mv a0, s1                     # element to move
   mv a1, s0                     # address to move it to
   jal shift                     # jump to shift 
   addi s1, s1, 1
   skip: 
   addi s0, s0, 1          # Increment first half index and point to the next element
   lw a2, 24(sp)           # Load back last element address
   bge s0, a2, lend
   bge s1, a2, lend
   beq x0, x0, mloop
   shift:
   ble a0, a1, shiftend      # Location reached, stop shifting
   addi t3, a0, -1            # Go to the previous element in the array
   lb t4, 0(a0)               # Get current element pointer
   lb t5, 0(t3)               # Get previous element pointer
   sb t4, 0(t3)               # Copy current element pointer to previous element address
   sb t5, 0(a0)               # Copy previous element pointer to current element address
   mv a0, t3                  # Shift current position back
   beq x0, x0, shift          # Loop again
   shiftend:
          ret
   lend:
      lw ra, 0(sp)                  # Load return address
      lw a0, 8(sp)                  # Load first element of first array address
      lw a1, 16(sp)                 # Load first element of second array address
      lw a2, 24(sp)                 # Load last element of second array address
      addi sp, sp, 32
      ret
      exit:
      lui x5 65537                  #Store address where merger array has to be stored
      loop: 
      bge a0 a2 end                 #Looping for the whole array and storing element one by one on mem location 0x10001000
      lb x6 0(a0)
      sb x6, 0(x5)
      addi x5 x5 1
      addi a0 a0 1
      beq x0, x0, loop
      end:
      addi x10 x0 0                 # Setting the error code to zero (just for checking that function has ended properly