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
  ldrb W1,  [X7],  #1  //X1 = *X7, then add one to the address X7.
  cmp  W1,  #0         //if (W1 == '\0') return;
  beq  return          //branch to return if equal
  add X2,  X2,  #1     //Increment counter
  b   loopStringLength //Jump to Loop

return:
  mov  X0, X2          //Move counter to X0

/***EXIT_SEQUENCE***/
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
  str X0, [SP, #-16]!  //PUSH X0
  str X1, [SP, #-16]!  //PUSH X1
  
  bl  String_length
  mov X3, X0           //Store str1.size() for safe keeping

  ldr X0, [SP], #16
  mov X4, X0           //MOVE str2 to safe keeping
  bl  String_length

  cmp X0, X3
  bne sizeNotString_equals

  //Move and pop the correct original string parameters into place
  mov X1, X4
  ldr X0, [SP], #16
loopString_equals:
  //X2 = str1[i]
  //X3 = str2[i]
  ldrb W2, [X0], #1
  ldrb W3, [X1], #1

  //Check to see if the charecters are equals
  cmp W2, W3
  bne falseString_equals

  //If they are equal, check to see if its a '\0'
  cmp W2, #0
  beq trueString_equals

  //If they are equal, but they arent null chars, continue with the check.
  b loopString_equals
  
//Function Returns
sizeNotString_equals: 
  mov X0 ,  #0 
  ldr X1 , [SP], #16
  ldr X30, [SP], #16

  RET  LR
 
falseString_equals:
  mov X0,   #0
  ldr X30, [SP], #16

  RET  LR

trueString_equals:
  mov X0,   #1
  ldr X30, [SP], #16

  RET  LR
  
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
  str X30, [SP, #-16]!  //PUSH LR
  
  //Push parameters for safekeeping to set up String-length calls
  str X0, [SP, #-16]!  //PUSH X0
  str X1, [SP, #-16]!  //PUSH X1
  
  bl  String_length
  mov X3, X0           //Store str1.size() for safe keeping

  ldr X0, [SP], #16
  mov X4, X0           //MOVE str2 to safe keeping
  bl  String_length

  cmp X0, X3
  bne sizeNotString_equalsIgnoreCase

  //Move and pop the correct original string parameters into place
  mov X1, X4
  ldr X0, [SP], #16

loopString_equalsIgnoreCase:
 //Check each byte from str1 and str2, if any are uppercase, ADD 32 to that charecter and then compare
  //X2 = str1[i]
  //X3 = str2[i]
  ldrb W2, [X0], #1
  ldrb W3, [X1], #1

  cmp W2, #0
  beq trueString_equalsIgnoreCase

  //Check to see if str1[i] is an uppercase char
  cmp W2, #0x41
  blt convert_secondIgnoreCase
  cmp W2, #0x5a
  bgt convert_secondIgnoreCase
  //If it is in the range, convert to lower case. If not, skip
  add W2, W2, #32

convert_secondIgnoreCase: 
  //Check to see if str1[i] is an uppercase char
  cmp W3, #0x41
  blt compare_charectersIgnoreCase
  cmp W3, #0x5a
  bgt compare_charectersIgnoreCase
  //If it is in the range, convert to lower case. If not, skip
  add W3, W3, #32

compare_charectersIgnoreCase:
 cmp W2, W3
 bne falseString_equalsIgnoreCase

 b   loopString_equalsIgnoreCase

//Function Returns
sizeNotString_equalsIgnoreCase: 
  mov X0 ,  #0 
  ldr X1 , [SP], #16
  ldr X30, [SP], #16

  RET  LR
 
falseString_equalsIgnoreCase:
  mov X0,   #0
  ldr X30, [SP], #16

  RET  LR

trueString_equalsIgnoreCase:
  mov X0,   #1
  ldr X30, [SP], #16

  RET  LR

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
  str X19 , [SP, #-16]!  
  str X20 , [SP, #-16]! 
  str X21 , [SP, #-16]! 
  str X22 , [SP, #-16]! 
  str X23 , [SP, #-16]! 
  str X24 , [SP, #-16]! 
  str X25 , [SP, #-16]! 
  str X26 , [SP, #-16]! 
  str X27 , [SP, #-16]! 
  str X28 , [SP, #-16]! 
  str X29 , [SP, #-16]! 
  
  str X0 , [SP, #-16]!  //PUSH X0: Parameter

  //Get length of string to copy
  bl  String_length
  
  //Save String_length
  str X0 , [SP, #-16]!

  //Add one to string length for null char
  add X0, X0, #1        
  bl  malloc
 
  ldr X3, [SP], #16     //Pop String_length for loop
  ldr X1, [SP], #16     //Pop original passed parameter
  str X0, [SP, #-16]!   //Save original malloced string address for returning

loopString_copy:
  //Load register with one byte from original parameter
  //Store it into the malloced string
  //post increment both pointers, and continue for the length of the original string.
  // X0 = malloced string
  // X1 = parameter
  // X3 = String_length or loopControl
  
  ldrb W2, [X1], #1
  strb W2, [X0], #1
  

  cmp X3, #0
  beq finishedString_copy
  sub X3, X3, #1

  b   loopString_copy

finishedString_copy:
  mov  W2, #0
  strb W2, [X0], #1
  
  ldr X0, [SP], #16
 
  ldr X29, [SP], #16
  ldr X28, [SP], #16
  ldr X27, [SP], #16
  ldr X26, [SP], #16
  ldr X25, [SP], #16
  ldr X24, [SP], #16
  ldr X23, [SP], #16
  ldr X22, [SP], #16
  ldr X21, [SP], #16
  ldr X20, [SP], #16
  ldr X19, [SP], #16

  ldr X30, [SP], #16

  RET  LR
  
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
  str X19 , [SP, #-16]!  
  str X20 , [SP, #-16]! 
  str X21 , [SP, #-16]! 
  str X22 , [SP, #-16]! 
  str X23 , [SP, #-16]! 
  str X24 , [SP, #-16]! 
  str X25 , [SP, #-16]! 
  str X26 , [SP, #-16]! 
  str X27 , [SP, #-16]! 
  str X28 , [SP, #-16]! 
  str X29 , [SP, #-16]! 
  
  str X0 , [SP, #-16]!  //PUSH X0: String pointer
  str X1 , [SP, #-16]!  //PUSH X1: BeginIndex
  str X2 , [SP, #-16]!  //PUSH X1: EndIndex

  //call stringlength
  //determine if indexes are in range
  //allocate memory
  //do algorithm
  bl  String_length

  ldr X2, [SP], #16
  ldr X1, [SP], #16

  //unresolved bug: if empty string, will segfault
  cmp X1, #1
  blt notInRangeSubstring1
  cmp X1, X0
  bgt notInRangeSubstring1

  cmp X2, #1
  blt notInRangeSubstring1
  cmp X2, X0
  bgt notInRangeSubstring1
 
  subs X0, X2, X1
  bmi  notInRangeSubstring1

  str X1 , [SP, #-16]!  //PUSH X1: BeginIndex
  str X2 , [SP, #-16]!  //PUSH X1: EndIndex
  
  add X0, X0, #2
  bl  malloc

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

  str X0, [SP, #-16]!  //Push original dynamically allocated string for return
  
/*
X0 = dynamically allocated memory
X3 = orginal string
X4 = loopcontrol
*/

loopSubstring1:
  ldrb W1, [X3], #1
  strb W1, [X0], #1

  sub X4, X4, #1
  cmp X4, #0
  beq finishedSubstring1

  b   loopSubstring1


notInRangeSubstring1:
  ldr X0 , [SP], #16

  ldr X29, [SP], #16
  ldr X28, [SP], #16
  ldr X27, [SP], #16
  ldr X26, [SP], #16
  ldr X25, [SP], #16
  ldr X24, [SP], #16
  ldr X23, [SP], #16
  ldr X22, [SP], #16
  ldr X21, [SP], #16
  ldr X20, [SP], #16
  ldr X19, [SP], #16

  ldr X30, [SP], #16

  mov X0, #-1

  RET  LR

finishedSubstring1:
  mov  W1,  #0
  strb W1, [X0]

  ldr X0 , [SP], #16

  ldr X29, [SP], #16
  ldr X28, [SP], #16
  ldr X27, [SP], #16
  ldr X26, [SP], #16
  ldr X25, [SP], #16
  ldr X24, [SP], #16
  ldr X23, [SP], #16
  ldr X22, [SP], #16
  ldr X21, [SP], #16
  ldr X20, [SP], #16
  ldr X19, [SP], #16

  ldr X30, [SP], #16

  RET LR

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
  str X19 , [SP, #-16]!  
  str X20 , [SP, #-16]! 
  str X21 , [SP, #-16]! 
  str X22 , [SP, #-16]! 
  str X23 , [SP, #-16]! 
  str X24 , [SP, #-16]! 
  str X25 , [SP, #-16]! 
  str X26 , [SP, #-16]! 
  str X27 , [SP, #-16]! 
  str X28 , [SP, #-16]! 
  str X29 , [SP, #-16]! 
  
  str X0 , [SP, #-16]!  //PUSH X0: String pointer
  str X1 , [SP, #-16]!  //PUSH X1: BeginIndex

  bl  String_length
  
  ldr X1, [SP], #16
 
  //unresolved bug: if empty string, will segfault
  cmp X1, #1
  blt notInRangeSubstring2
  cmp X1, X0
  bgt notInRangeSubstring2

  str X1 , [SP, #-16]!  //PUSH X1: BeginIndex

  subs X0, X0, X1
  bmi  notInRangeSubstring2

  add X0, X0, #2
  bl malloc

  ldr X1, [SP], #16 //POP BeginIndex
  ldr X2, [SP], #16 //POP string parameter

  add X2, X2, X1    //Add base index to string parameter
  sub X2, X2, #1    //Minus one because ^^ is one off

  str X0, [SP, #-16]!  //Push original dynamically allocated string for return

loopSubstring2:
  cmp W1, #0
  beq finishedSubstring1

  ldrb W1, [X2], #1
  strb W1, [X0], #1

  b   loopSubstring2

notInRangeSubstring2:
  ldr X0 , [SP], #16

  ldr X29, [SP], #16
  ldr X28, [SP], #16
  ldr X27, [SP], #16
  ldr X26, [SP], #16
  ldr X25, [SP], #16
  ldr X24, [SP], #16
  ldr X23, [SP], #16
  ldr X22, [SP], #16
  ldr X21, [SP], #16
  ldr X20, [SP], #16
  ldr X19, [SP], #16

  ldr X30, [SP], #16

  mov X0, #-1

  RET  LR


finishedSubstring2: 
  mov  W1,  #0
  strb W1, [X0]

  ldr X0 , [SP], #16

  ldr X29, [SP], #16
  ldr X28, [SP], #16
  ldr X27, [SP], #16
  ldr X26, [SP], #16
  ldr X25, [SP], #16
  ldr X24, [SP], #16
  ldr X23, [SP], #16
  ldr X22, [SP], #16
  ldr X21, [SP], #16
  ldr X20, [SP], #16
  ldr X19, [SP], #16

  ldr X30, [SP], #16

  RET LR 

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
  str X30, [SP, #-16]!
  
  str X0, [SP, #-16]!
  str X1, [SP, #-16]!

  bl  String_length

  ldr X2, [SP], #16  //Pop index
  ldr X1, [SP], #16  //Pop String pointer

  cmp X2, #1
  blt notInRangeString_charAt
  cmp X2, X0
  bgt notInRangeString_charAt
  
  b   finishedString_charAt


notInRangeString_charAt:
  mov X0, #0
  ldr X30, [SP], #16

  RET  LR


finishedString_charAt:
  add X1, X1, X2
  sub X1, X1, #1

  ldrb W0, [X1]

  ldr X30, [SP], #16

  RET  LR


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
  str X30, [SP, #-16]!
  
  str X0, [SP, #-16]!
  str X1, [SP, #-16]!
  str X2, [SP, #-16]!

  bl  String_length

  ldr X3, [SP], #16  //Pop position
  ldr X2, [SP], #16  //Pop mini string
  ldr X1, [SP], #16  //Pop big string

  cmp X3, #1
  blt doesNotStartsWith1
  cmp X3, X0
  bgt doesNotStartsWith1

  mov X0, X1
  mov X1, X2
  mov X2, X3

  /*
  X0 - big string
  X1 - prefix string
  X2 - position
  */
  add X0, X0, X2

loopStartsWith1:
  ldrb W2, [X1], #1
  cmp  W2, #0
  beq doesStartsWith1

  ldrb W3, [X0], #1
  cmp  W3, W2
  bne doesNotStartsWith1

  b loopStartsWith1


doesNotStartsWith1:
  mov X0, #0
  ldr X30, [SP], #16

  RET  LR

doesStartsWith1:
  mov X0, #1
  ldr X30, [SP], #16

  RET  LR


/*
@ Subroutine String_startsWith_2: Provided a pointer to a null-terminated string in X0 and a prefix string in X1
@                                 this function will return true or false (1 or 0) if the string starts with the prefix string
@ X0: Must point to a null terminated string
@ X1: Must point to a null terminated string
@ LR: Must contain the return address
@ ALL AAPCS required registers are preserved,  r19-r29 and SP

@ Returned register contents: X0 true or false
@ All AAPCS are preserved.
@       X0, X1, X2, X3 and X7 are changed and not preserved
*/

  .global String_startsWith_2

String_startsWith_2:
  ldrb W2, [X1], #1
  cmp  W2, #0
  beq doesStartsWith2

  ldrb W3, [X0], #1
  cmp  W3, W2
  bne doesNotStartsWith2

  b   String_startsWith_2

doesNotStartsWith2:
  mov X0, #0

  RET  LR

doesStartsWith2:
  mov X0, #1

  RET  LR
