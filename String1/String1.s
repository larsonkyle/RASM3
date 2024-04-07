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
@ Subroutine String_length: Provided a pointer to a null-terminated string in X0, and another pointer to a null terminated string in X1,
@                           will return whether if the two strings are equal to each other (true = 1, false = 0)
@ X0: Must point to a null terminated string
@ X1: Must point to a null terminated string
@ LR: Must contain the return address
@ ALL AAPCS required registers are preserved,  r19-r29 and SP

@ Returned register contents:
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
  
