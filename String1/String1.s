/*****************************
* NAME     : Kyle Larson
* CLASS    : CS3B
* DUE DATE : 4/08/2024 
* PROFESSOR: Dr.Barnett
******************************/

/*
@ Subroutine String_length: Provided a pointer to a null terminated string, String_length will
@                           return the length of the string in X0
@ X0: Must point to a null terminated string
@ LR: Must contain the return address
@ ALL AAPCS required registers are preserved,  r19-r29 and SP

@ Returned register contents:
@ All AAPCS are preserved.
@       X0, X1, X2, and X7 are modified and not preserved

*/
  .global String_length  //@Pass entry point name to linker

  .text

String_length:
  
  //Setup do while
  mov X7, X0           //Move address of string to X7
  mov X2, #0           //Initialize counter

loopStringLength:
  //Load char from string and check for null
  ldrb W1,  [X7],  #1  //X1 = *X7, then add one to the address X7.
  cmp  W1,  #0         //if (W1 == '\0') return;
  beq  return          //branch to return if equal

  //increment length counter
  add X2,  X2,  #1     //Increment counter
  b   loopStringLength //Jump to Loop

//Function return
return:
  mov  X0, X2          //Move counter to X0

  RET  LR              //Return to caller

/*
@ Subroutine String_equals: Provided a pointer to a null-terminated string in X0, and another pointer to a null terminated string in X1,
@                           will return whether if the two strings are equal to each other (true = 1, false = 0)
@ X0: Must point to a null terminated string
@ X1: Must point to a null terminated string
@ LR: Must contain the return address
@ ALL AAPCS required registers are preserved,  r19-r29 and SP

@ Returned register contents: X0 of either 1 or 0 (true or false)
@ All AAPCS are preserved.
@       X0, X1, X2, X3, X4, X7 are modified and not preserved
*/
  .global String_equals

String_equals:
  //Push LR to set up calls to String_length
  str X30, [SP, #-16]!  //PUSH LR
  
  //Push parameters for safekeeping to set up String-length calls
  str X0, [SP, #-16]!      //PUSH X0
  str X1, [SP, #-16]!      //PUSH X1
  
  //Get length of str1
  bl  String_length        //Call String_length
  mov X3, X0               //Store str1.size() for safe keeping

  //Load address of str2
  ldr X0, [SP], #16        //Load into X0 from SP
  mov X4, X0               //MOVE str2 to safe keeping
  
  //Get length of str2
  bl  String_length        //Call String_length

  //Check lengths of str1 & str2
  cmp X0, X3               //Compare both string sizes
  bne sizeNotString_equals //if sizes not equal, branch to not equal size

  //Move and pop the correct original string parameters into place
  mov X1, X4               //Move str2 to X1
  ldr X0, [SP], #16        //Pop  str1 to X0
loopString_equals:
  //X2 = str1[i]
  //X3 = str2[i]
  //Load chars from str1 and str2
  ldrb W2, [X0], #1        //Load char from str1, then increment
  ldrb W3, [X1], #1        //Load char from str2, then increment

  //Check to see if the charecters are equals
  cmp W2, W3               //Compare chars
  bne falseString_equals   //If chars arent equal, branch to false

  //If they are equal, check to see if its a '\0'
  cmp W2, #0               //Check to see if at end of string
  beq trueString_equals    //If at end, branch to true

  //If they are equal, but they arent null chars, continue with the check.
  b loopString_equals      //Loop Algorithm
  
//Function Returns
sizeNotString_equals: 
  mov X0 ,  #0             //Mov 0 into X0 for false
  ldr X1 , [SP], #16       //Pop left over stack variable
  ldr X30, [SP], #16       //Pop LR

  RET  LR                  //Return to LR
 
falseString_equals:
  mov X0,   #0             //Mov 0 into X0 for false
  ldr X30, [SP], #16       //Pop LR

  RET  LR                  //Return to LR

trueString_equals:
  mov X0,   #1             //mov 1 into X0 for true
  ldr X30, [SP], #16       //Pop LR

  RET  LR                  //Return LR
  
/*
@ Subroutine String_equalsIgnoreCase: Provided a pointer to a null-terminated string in X0, and another pointer to a null terminated string in X1,
@                                     will return whether if the two strings are equal to each other (true = 1, false = 0)
@ X0: Must point to a null terminated string
@ X1: Must point to a null terminated string
@ LR: Must contain the return address
@ ALL AAPCS required registers are preserved,  r19-r29 and SP

@ Returned register contents: X0 of either 1 or 0 (true or false)
@ All AAPCS are preserved.
@       X0, X1, X2, X3, X4, X7 are modified and not preserved
*/
  .global String_equalsIgnoreCase

  .text

String_equalsIgnoreCase: 
  //Push LR to set up calls to String_length
  str X30, [SP, #-16]!               //PUSH LR
  
  //Push parameters for safekeeping to set up String-length calls
  str X0, [SP, #-16]!                //PUSH X0
  str X1, [SP, #-16]!                //PUSH X1
  
  bl  String_length                  //Call String_length
  mov X3, X0                         //Store str1.size() for safe keeping

  ldr X0, [SP], #16                  //Pop str1 into X0
  mov X4, X0                         //MOVE str2 to safe keeping
  bl  String_length

  cmp X0, X3                         //Compare string sizes
  bne sizeNotString_equalsIgnoreCase //If sizes not equal, branch to size not equal

  //Move and pop the correct original string parameters into place
  mov X1, X4                         //Mov str2 into X1
  ldr X0, [SP], #16                  //Pop str1 into X0

loopString_equalsIgnoreCase:
 //Check each byte from str1 and str2, if any are uppercase, ADD 32 to that charecter and then compare
  //X2 = str1[i]
  //X3 = str2[i]
  ldrb W2, [X0], #1                  //Load char from str1
  ldrb W3, [X1], #1                  //Load char from str2

  cmp W2, #0                         //Check to see if we any of the strings are at the end
  beq trueString_equalsIgnoreCase    //if at end, branch to true

  //Check to see if str1[i] is an uppercase char
  cmp W2, #0x41                      //check if str1[i] < 'A'
  blt convert_secondIgnoreCase       //If less than, then not in range
  cmp W2, #0x5a                      //check if str[i] > 'Z'
  bgt convert_secondIgnoreCase       //If greater, then not in range
  //If it is in the range, convert to lower case. If not, skip
  add W2, W2, #32                    //if did not branch, then was in range,
                                     //So convert to lowercase
convert_secondIgnoreCase: 
  //Check to see if str1[i] is an uppercase char
  cmp W3, #0x41                      //Check if str2[i] < 'A'
  blt compare_charectersIgnoreCase   //If less than, then not in range
  cmp W3, #0x5a                      //Check if str2[i] > 'Z'
  bgt compare_charectersIgnoreCase   //If greater than, then not in range
  //If it is in the range, convert to lower case. If not, skip
  add W3, W3, #32                    //If did not branch, then was in range,
                                     //So convert to lowercase
compare_charectersIgnoreCase:
 cmp W2, W3                          //Compare the two chars
 bne falseString_equalsIgnoreCase    //Branch to false if not equal

 b   loopString_equalsIgnoreCase     //Loop algorithm


//Function Returns
sizeNotString_equalsIgnoreCase:
  //Return false
  //But, preserve SP
  mov X0 ,  #0                       //Move 0 into X0 for false
  ldr X1 , [SP], #16                 //Pop left over stack var
  ldr X30, [SP], #16                 //Pop LR

  RET  LR                            //Return to LR
 
falseString_equalsIgnoreCase:
  //Return false
  mov X0,   #0                       //Move 0 into X0 for false
  ldr X30, [SP], #16                 //Pop LR

  RET  LR                            //Return to LR

trueString_equalsIgnoreCase:
  //Return true
  mov X0,   #1                       //Move 1 into X0 for true
  ldr X30, [SP], #16                 //Pop LR

  RET  LR                            //Return to LR

/*
@ Subroutine String_copy: Provided a pointer to a null-terminated string in X0,
@                         This function will return a DYNAMICALLY ALLOCATED copy of the given null terminated string in X0.
@ X0: Must point to a null terminated string
@ LR: Must contain the return address
@ ALL AAPCS required registers are preserved,  r19-r29 and SP

@ Returned register contents: X0, Address of the dynamically allocated string copy
@ All AAPCS are preserved.
@       ALL registers except r19-r29 & SP are modified and not preserved.
*/
  .global String_copy

  .text

String_copy:
  //Store LR for String_length calls
  str X30, [SP, #-16]!  //PUSH LR
  
  //MUST push all r19-r29 registers onto stack to preserve AAPCS protocol after malloc() C function
  str X19 , [SP, #-16]! //PUSH X19
  str X20 , [SP, #-16]! //PUSH X20
  str X21 , [SP, #-16]! //PUSH X21
  str X22 , [SP, #-16]! //PUSH X22
  str X23 , [SP, #-16]! //PUSH X23
  str X24 , [SP, #-16]! //PUSH X24
  str X25 , [SP, #-16]! //PUSH X25
  str X26 , [SP, #-16]! //PUSH X26
  str X27 , [SP, #-16]! //PUSH X27
  str X28 , [SP, #-16]! //PUSH X28
  str X29 , [SP, #-16]! //PUSH X29
  
  //Save parameters for function call
  str X0 , [SP, #-16]!  //PUSH X0: Parameter

  //Get length of string to copy
  bl  String_length     //Call String_length
  
  //Save String_length
  str X0 , [SP, #-16]!  //Push X0

  //Add one to string length for null char
  add X0, X0, #1        //X0 = X0 + 1
  bl  malloc            //Call malloc
 
  //Load parameters for algorithm
  ldr X3, [SP], #16     //Pop String_length for loop
  ldr X1, [SP], #16     //Pop original passed parameter

  //Save original allocated string address
  str X0, [SP, #-16]!   //Save original malloced string address for returning

loopString_copy:
  //Load register with one byte from original parameter
  //Store it into the malloced string
  //post increment both pointers, and continue for the length of the original string.
  // X0 = malloced string
  // X1 = parameter
  // X3 = String_length or loopControl
  ldrb W2, [X1], #1     //Load char from string
  strb W2, [X0], #1     //Store into allocated string
  

  cmp X3, #0            //Check to see if string ended
  beq finishedString_copy //If ended, branch to finish
  sub X3, X3, #1        //Decrement counter

  b   loopString_copy   //Loop algorithm 

//Function return
finishedString_copy:
  //Load null char into string
  mov  W2, #0           //Mov null char
  strb W2, [X0], #1     //Store null char
  
  //Pop address of original allocated string
  ldr X0, [SP], #16     //Pop original address of allocated string
 
  ldr X29, [SP], #16    //POP X29
  ldr X28, [SP], #16    //POP X28
  ldr X27, [SP], #16    //POP X27
  ldr X26, [SP], #16    //POP X26
  ldr X25, [SP], #16    //POP X25
  ldr X24, [SP], #16    //POP X24
  ldr X23, [SP], #16    //POP X23
  ldr X22, [SP], #16    //POP X22
  ldr X21, [SP], #16    //POP X21
  ldr X20, [SP], #16    //POP X20
  ldr X19, [SP], #16    //POP X19

  ldr X30, [SP], #16    //POP LR

  RET  LR               //Return to LR
  
/*
@ Subroutine String_substring_1: Provided a pointer to a null-terminated string in X0,
@                                This function will return a DYNAMICALLY ALLOCATED substring of the given string from beginning index to end index.
@                                If the indexes are not within the range of the string, the function will return -1
@ X0: Must point to a null terminated string
@ X1: Beginning Index
@ X2: Ending Index
@ LR: Must contain the return address
@ ALL AAPCS required registers are preserved,  r19-r29 and SP

@ Returned register contents: X0, Dynamically allocated substring or -1 failure
@ All AAPCS are preserved.
@       ALL registers except r19-r29 & SP are modified and not preserved.
*/
  .global String_substring_1

String_substring_1:
  //Store LR for String_length calls
  str X30, [SP, #-16]!  //PUSH LR
  
  //MUST push all r19-r29 registers onto stack to preserve AAPCS protocol after malloc() C function
  str X19 , [SP, #-16]! //PUSH X19
  str X20 , [SP, #-16]! //PUSH X20
  str X21 , [SP, #-16]! //PUSH X21
  str X22 , [SP, #-16]! //PUSH X22
  str X23 , [SP, #-16]! //PUSH X23
  str X24 , [SP, #-16]! //PUSH X24
  str X25 , [SP, #-16]! //PUSH X25
  str X26 , [SP, #-16]! //PUSH X26
  str X27 , [SP, #-16]! //PUSH X27
  str X28 , [SP, #-16]! //PUSH X28
  str X29 , [SP, #-16]! //PUSH X29
  
  //Save parameters for function call
  str X0 , [SP, #-16]!  //PUSH X0: String pointer
  str X1 , [SP, #-16]!  //PUSH X1: BeginIndex
  str X2 , [SP, #-16]!  //PUSH X1: EndIndex

  //call stringlength
  //determine if indexes are in range
  //allocate memory
  //do algorithm
  bl  String_length     //Call String_length

  ldr X2, [SP], #16     //Pop endIndex
  ldr X1, [SP], #16     //Pop beginIndex

  //unresolved bug: if empty string, will segfault
  //Determine if indexes are in range
  cmp X1, #1            //Check if begin index is less than one
  blt notInRangeSubstring1 //If less than, branch to notinrange
  cmp X1, X0            //Check if outside of string length
  bgt notInRangeSubstring1 //if greater than string length, branch to not in range

  cmp X2, #1            //Check if end index is less than one
  blt notInRangeSubstring1 //If less than, branch to notinrange
  cmp X2, X0            //Check if end index is greater than string length
  bgt notInRangeSubstring1 //If greater then, branch to notinrange
 
  //Calculate substring size and for allocation
  subs X0, X2, X1       //Check if end index is smaller than begin index
  bmi  notInRangeSubstring1 //If smaller, branch to notinrange

  //Save parameters for malloc call
  str X1 , [SP, #-16]!  //PUSH X1: BeginIndex
  str X2 , [SP, #-16]!  //PUSH X1: EndIndex
  
  //Calculate memory to allocate
  add X0, X0, #2 //Add two to original calculation. 1 for null char, one for being one off (end index - begin index is one off)
  bl  malloc     //Call malloc

  //Pop out variables
  ldr X2, [SP], #16 //Pop endIndex
  ldr X1, [SP], #16 //pop beginIndex
  ldr X3, [SP], #16 //pop parameter
  
  //Set up loop control
  sub X4, X2, X1 //endIndex - beginIndex
  add X4, X4, #1 //Add one, since ^^ is one off

  //Set up starting address
  add X3, X3, X1 //start address + beginIndex
  sub X3, X3, #1 //minus one, since ^^ is one off

  str X0, [SP, #-16]! //Push original dynamically allocated string for return
  
/*
X0 = dynamically allocated memory
X3 = orginal string
X4 = loopcontrol
*/

loopSubstring1:
  //Load char, then store char in new string
  ldrb W1, [X3], #1 //Load char of substring in string
  strb W1, [X0], #1 //Store char into allocated string

  //Decrement counter, then check for null
  sub X4, X4, #1    //Decrement counter
  cmp X4, #0        //Check if byte was null char
  beq finishedSubstring1 //If null char, then branch to finished

  b   loopSubstring1 //Loop algorithm


//Function Return
notInRangeSubstring1:
  //STACK UNDWIND
  ldr X0 , [SP], #16 //Pop left over stack var

  ldr X29, [SP], #16 //POP X29
  ldr X28, [SP], #16 //POP X28
  ldr X27, [SP], #16 //POP X27
  ldr X26, [SP], #16 //POP X26
  ldr X25, [SP], #16 //POP X25
  ldr X24, [SP], #16 //POP X24
  ldr X23, [SP], #16 //POP X23
  ldr X22, [SP], #16 //POP X22
  ldr X21, [SP], #16 //POP X21
  ldr X20, [SP], #16 //POP X20
  ldr X19, [SP], #16 //POP X19

  ldr X30, [SP], #16 //POP LR

  mov X0, #-1        //Mov -1 into X0 

  RET  LR            //Return to LR

finishedSubstring1:
  //Finish string with null char
  mov  W1,  #0       //Load null char into w1
  strb W1, [X0]      //Store null char at end of string

  //STACK UNWIND
  ldr X0 , [SP], #16 //Pop original allocated string address

  ldr X29, [SP], #16 //POP X29
  ldr X28, [SP], #16 //POP X28
  ldr X27, [SP], #16 //POP X27
  ldr X26, [SP], #16 //POP X26
  ldr X25, [SP], #16 //POP X25
  ldr X24, [SP], #16 //POP X24
  ldr X23, [SP], #16 //POP X23
  ldr X22, [SP], #16 //POP X22
  ldr X21, [SP], #16 //POP X21
  ldr X20, [SP], #16 //POP X20
  ldr X19, [SP], #16 //POP X19

  ldr X30, [SP], #16 //POP LR

  RET LR             //Return to LR

/*
@ Subroutine String_substring_2: Provided a pointer to a null-terminated string in X0,
@                                This function will return a DYNAMICALLY ALLOCATED substring of the given string from beginning index to end of string.
@                                If the index is not within the range of the string, the function will return -1
@ X0: Must point to a null terminated string
@ X1: Beginning Index
@ LR: Must contain the return address
@ ALL AAPCS required registers are preserved,  r19-r29 and SP

@ Returned register contents: X0, Dynamically allocated substring or -1 failure
@ All AAPCS are preserved.
@       ALL registers except r19-r29 & SP are modified and not preserved.
*/
  .global String_substring_2

String_substring_2:
  //Store LR for String_length calls
  str X30, [SP, #-16]!  //PUSH LR
  
  //MUST push all r19-r29 registers onto stack to preserve AAPCS protocol after malloc() C function
  str X19 , [SP, #-16]! //PUSH X19
  str X20 , [SP, #-16]! //PUSH X20
  str X21 , [SP, #-16]! //PUSH X21
  str X22 , [SP, #-16]! //PUSH X22
  str X23 , [SP, #-16]! //PUSH X23
  str X24 , [SP, #-16]! //PUSH X24
  str X25 , [SP, #-16]! //PUSH X25
  str X26 , [SP, #-16]! //PUSH X26
  str X27 , [SP, #-16]! //PUSH X27
  str X28 , [SP, #-16]! //PUSH X28
  str X29 , [SP, #-16]! //PUSH X29
  
  //Save parameters for function calls
  str X0 , [SP, #-16]!  //PUSH X0: String pointer
  str X1 , [SP, #-16]!  //PUSH X1: BeginIndex

  //Get length of String
  bl  String_length     //Call String_length
  
  //Load index back
  ldr X1, [SP], #16     //Pop begin index
 
  //unresolved bug: if empty string, will segfault
  //Range check index
  cmp X1, #1            //Check if begin index is less than 0
  blt notInRangeSubstring2 //If less than, then branch to not in range
  cmp X1, X0            //Check if begin index is greater than String_length
  bgt notInRangeSubstring2 //If greather than, then branch to not in range

  //Save index
  str X1 , [SP, #-16]!  //PUSH X1: BeginIndex

  //Calculate substring memory size
  subs X0, X0, X1       //Calculate substring size
  bmi  notInRangeSubstring2 //If substring is larger than size, then branch to not in range

  //Add null and off by one for memory allocation
  add X0, X0, #2        //Add two to substring size, one for null char and one for being one off (beginIndex - end is one off)
  bl malloc

  //Load parameters
  ldr X1, [SP], #16     //POP BeginIndex
  ldr X2, [SP], #16     //POP string parameter

  //Calculate substring offset
  add X2, X2, X1        //Add base index to string parameter
  sub X2, X2, #1        //Minus one because ^^ is one off

  //Save original dynamically allocated string address
  str X0, [SP, #-16]!   //Push original dynamically allocated string for return

loopSubstring2:
  cmp W1, #0            //Check if loaded byte is null char
                        //or if first time around, check if substring size is 0
  beq finishedSubstring1//If == 0, then branch to finished

  ldrb W1, [X2], #1     //Load char from string
  strb W1, [X0], #1     //Store into allocated string

  b   loopSubstring2    //Loop algorithm


//Function return
notInRangeSubstring2:
  //Stack unwind
  ldr X0 , [SP], #16    //Pop extra stack var

  ldr X29, [SP], #16    //POP X29
  ldr X28, [SP], #16    //POP X28
  ldr X27, [SP], #16    //POP X27
  ldr X26, [SP], #16    //POP X26
  ldr X25, [SP], #16    //POP X25
  ldr X24, [SP], #16    //POP X24
  ldr X23, [SP], #16    //POP X23
  ldr X22, [SP], #16    //POP X22
  ldr X21, [SP], #16    //POP X21
  ldr X20, [SP], #16    //POP X20
  ldr X19, [SP], #16    //POP X19

  ldr X30, [SP], #16    //POP LR

  //Set -1 error
  mov X0, #-1           //Move -1 into X0

  RET  LR               //Return LR


finishedSubstring2: 
  //Finish string with null char
  mov  W1,  #0          //Move null char into W1 
  strb W1, [X0]         //Store null char at end of substring

  //Load original dynamically allocated string
  ldr X0 , [SP], #16    //Load original allocated string into X0

  //STACK UNWIND
  ldr X29, [SP], #16    //POP X29
  ldr X28, [SP], #16    //POP X28
  ldr X27, [SP], #16    //POP X27
  ldr X26, [SP], #16    //POP X26
  ldr X25, [SP], #16    //POP X25
  ldr X24, [SP], #16    //POP X24
  ldr X23, [SP], #16    //POP X23
  ldr X22, [SP], #16    //POP X22
  ldr X21, [SP], #16    //POP X21
  ldr X20, [SP], #16    //POP X20
  ldr X19, [SP], #16    //POP X19

  ldr X30, [SP], #16    //POP LR

  RET LR                //Return to LR

/*
@ Subroutine String_charAt: Provided a pointer to a null-terminated string in X0 and an index in the string,
@                           this function will return the charecter at that index. If the index is not in range, the function returns 0
@ X0: Must point to a null terminated string
@ X1: Index
@ LR: Must contain the return address
@ ALL AAPCS required registers are preserved,  r19-r29 and SP

@ Returned register contents: X0 Char at index or 0 
@ All AAPCS are preserved.
@       X0, X1, X2 and X7 are changed and not preserved
*/
  .global String_charAt

String_charAt:
  //Save LR for function calls
  str X30, [SP, #-16]! //PUSH LR
  
  //Save vars for String_length Call
  str X0, [SP, #-16]!  //PUSH X0: String param
  str X1, [SP, #-16]!  //PUSH X1: Index

  bl  String_length    //Call String_length

  //RePop parameters
  ldr X2, [SP], #16    //Pop index
  ldr X1, [SP], #16    //Pop String pointer

  //Index Range Check
  cmp X2, #1           //Check if index is less than 1
  blt notInRangeString_charAt //If less than 1, branch to not in range
  cmp X2, X0           //Check if index is greater than String_length
  bgt notInRangeString_charAt //If greater than, branch to not in range
  
  b   finishedString_charAt   //Do algorithm Then end


//Function return
notInRangeString_charAt:
  //Return 0 error
  mov X0, #0                  //Move 0 into X0 to return
  ldr X30, [SP], #16          //POP LR

  RET  LR                     //Return to LR


finishedString_charAt:
  //Calculate index position in string
  add X1, X1, X2     //Add index to string address
  sub X1, X1, #1     //Sub one because ^^ is one off

  //Load char from charecter at index
  ldrb W0, [X1]      //Load char from index position

  //Pop LR to return
  ldr X30, [SP], #16 //POP LR

  RET  LR            //Return to LR


/*
@ Subroutine String_startsWith_1: Provided a pointer to a null-terminated string in X0, a prefix string in X1, and an index in X2
@                                 this function will return true or false (1 or 0) if the string starting at given index, matches the prefix string
@ X0: Must point to a null terminated string
@ X1: Must point to a null terminated string
@ X2: Starting position
@ LR: Must contain the return address
@ ALL AAPCS required registers are preserved,  r19-r29 and SP

@ Returned register contents: X0 true or false
@ All AAPCS are preserved.
@       X0, X1, X2, X3 and X7 are changed and not preserved
*/
  .global String_startsWith_1

String_startsWith_1:
  //Save LR for function calls
  str X30, [SP, #-16]! //PUSH LR
  
  //Save Parameters for function calls
  str X0, [SP, #-16]!  //Push X0: String
  str X1, [SP, #-16]!  //Push X1: Prefix string
  str X2, [SP, #-16]!  //Push X2: Starting position

  bl  String_length    //Call String_length

  //Pop original parameters
  ldr X3, [SP], #16    //Pop position
  ldr X2, [SP], #16    //Pop Prefix String
  ldr X1, [SP], #16    //Pop String

  //Range check index
  cmp X3, #1           //Check if position is less than 1
  blt doesNotStartsWith1 //If less than, branch to not in range
  cmp X3, X0           //Check If position is greater than size
  bgt doesNotStartsWith1 //if greater than, branch to not in range

  //Move parameters into original spots
  mov X0, X1           //Move string to X0
  mov X1, X2           //Move prefix string to X1
  mov X2, X3           //Move position to X2

  /*
  X0 - big string
  X1 - prefix string
  X2 - position
  */
  //Calculate starting position in string
  add X0, X0, X2       //X0 = X0 + X2

loopStartsWith1:
  //Check for Null
  ldrb W2, [X1], #1    //Load char from Prefix String
  cmp  W2, #0          //Compare char to null
  beq doesStartsWith1  //if null, branch to true

  //Check if chars equal
  ldrb W3, [X0], #1    //Load char from string
  cmp  W3, W2          //Compare chars from string and prefix string
  bne doesNotStartsWith1 //if not equal, branch to false

  b loopStartsWith1    //Loop algorithm


//Function return
doesNotStartsWith1:
  //Return false
  mov X0, #0           //Move 0 into X0
  ldr X30, [SP], #16   //Pop LR

  RET  LR              //Return to LR

doesStartsWith1:
  //Return true
  mov X0, #1           //Move 1 into X0
  ldr X30, [SP], #16   //Pop LR

  RET  LR              //Return to LR


/*
@ Subroutine String_startsWith_2: Provided a pointer to a null-terminated string in X0 and a prefix string in X1
@                                 this function will return true or false (1 or 0) if the string starts with the prefix string
@ X0: Must point to a null terminated string
@ X1: Must point to a null terminated string
@ LR: Must contain the return address
@ ALL AAPCS required registers are preserved,  r19-r29 and SP

@ Returned register contents: X0 true or false
@ All AAPCS are preserved.
@       X0, X1, X2, X3 are changed and not preserved
*/
  .global String_startsWith_2

String_startsWith_2:
  //Check for null in prefix string
  ldrb W2, [X1], #1       //Load char from prefix string
  cmp  W2, #0             //Compare char to null char
  beq doesStartsWith2     //If equal, then branch to true

  //Load char from string and compare chars
  ldrb W3, [X0], #1       //Load char from string
  cmp  W3, W2             //Compare chars
  bne doesNotStartsWith2  //If not equal, branch to false

  b   String_startsWith_2 //Loop algorithm

//Function return
doesNotStartsWith2:
  //Return false
  mov X0, #0              //Move 0 into X0

  RET  LR                 //Return to LR

doesStartsWith2:
  //Return true
  mov X0, #1              //Move 1 into X0

  RET  LR                 //Return to LR

/*
@ Subroutine String_startsWith_2: Provided a pointer to a null-terminated string in X0 and a prefix string in X1
@                                 this function will return true or false (1 or 0) if the string starts with the prefix string
@ X0: Must point to a null terminated string
@ X1: Must point to a null terminated string
@ LR: Must contain the return address
@ ALL AAPCS required registers are preserved,  r19-r29 and SP

@ Returned register contents: X0 true or false
@ All AAPCS are preserved.
@       X0, X1, X2, X3 are changed and not preserved
*/
  .global String_endsWith

String_endsWith: 
  //Save LR and parameters
  str X30, [SP, #-16]! //PUSH LR
  str X1,  [SP, #-16]! //PUSH X1: suff string
  str X0,  [SP, #-16]! //PUSH X0  String

  //Get length of orig string
  //Get length of suffix string
  //set orig string address to the end
  //minus orig string by length of suffix string
  // do algorithm
  
  //Safe keep X1 param
  mov X3, X1           //Move suffix string to X3


  //Get length of orig string
  bl  String_length    //Call String_length
  mov X4, X0           //Move suffix string length to X4

  //Get length of suffix string
  mov X0, X3           //Move string address to X0
  bl  String_length    //Call String_length
  //X4 = length of orig string
  //X0 = length of suffix string

  ldr X1, [SP], #16    //Pop orig string
  ldr X2, [SP], #16    //Pop Suffix string

  //Calcualate proper offsets and store into proper locations
  add X1, X1, X4       //Set string address to end of string
  sub X0, X1, X0       //Minus string address by length of suffix string
  mov X1, X2           //Move suffix string addres to X1

  //X0 = orig string with proper offset
  //X1 = suffix string
loopString_endsWith:
  //Check for null in suffix string
  ldrb W2, [X1], #1    //Load char from suffix string
  cmp  W2, #0          //Compare char to null
  beq  doesEndsWith    //If equal, branch to true

  ldrb W3, [X0], #1    //load char from string with offset
  cmp  W3, W2          //Compare both chars
  bne  doesNotEndsWith //if not equal, branch to false

  b    loopString_endsWith //Loop algorithm


//Function returns
doesNotEndsWith:
  //Return False
  mov X0, #0               //Move 0 into X0
  ldr X30, [SP], #16       //Pop LR

  RET  LR                  //Return to LR

doesEndsWith:
  //Return True
  mov X0, #1               //Move 1 into X0
  ldr X30, [SP], #16       //Pop LR

  RET  LR                  //Return to LR
