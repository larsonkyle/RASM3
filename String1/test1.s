//  .global _start
    .global test1 

  .data

szS1: .asciz "Cat in the hat."
szS2: .asciz "Green eggs and ham."
szS3: .asciz "cat in the hat."
szS4: .asciz "hat."
szS5: .asciz "Cat"
szS6: .asciz "in the hat."

szHeader: .asciz "Contributers: Kyle Larson and Andrew Maciborski\nProject     : RASM3\nClass       : CS3B\nProfessor   : Dr.Barnett\nGithub      : https://github.com/larsonkyle/RASM3\n\n"

szSize1:                .asciz      "1.  s1.length()                         = "
szSize2:                .asciz      "    s2.length()                         = "
szSize3:                .asciz      "    s3.length()                         = "
szEquals1:              .asciz      "2.  String_equals(s1,s3)                = "
szEquals2:              .asciz      "3.  String_equals(s1,s1)                = "
szEqualsIG1:            .asciz      "4.  String_equalsIgnoreCase(s1,s3)      = "
szEqualsIG2:            .asciz      "5.  String_equalsIgnoreCase(s1,s2)      = "
szString_copy:          .asciz      "6.  s4 = String_copy(s1)\n"
szCopyS1:               .asciz      "    s1 = "
szCopyS4:               .asciz      "    s4 = "
szSubstring1:           .asciz      "7.  String_substring_1(s3,4,14)         = \""
szSubstring2:           .asciz      "8.  String_substring_2(s3,7)            = \""
szCharAt:               .asciz      "9.  String_charAt(s2,4)                 = '"
szStartsWith1:          .asciz      "10. String_startsWith_1(s1,11,\"hat.\")   = "
szStartsWith2:          .asciz      "11. String_startsWith_2(s1,\"Cat\")       = "
szEndsWith:             .asciz      "12. String_endsWith(s1,\"in the hat.\")   = "

szTrue:   .asciz "TRUE\n"
szFalse:  .asciz "FALSE\n"

szBuffer: .skip 21
strPtr:   .quad 0

chBuffer: .byte 0
chLF:     .byte 0xA
chQ:      .byte 0x22
chA:      .byte 0x27

.text

test1:
//_start:
  str LR, [SP,#-16]!

  ldr X0, =szHeader
  bl  putstring

  /*** Test Case 1 ***/
  // - test szS1
  ldr X0, =szSize1 //load address of Test Prompt
  bl  putstring    //Call putstring

  ldr X0, =szS1
  bl  String_length

  ldr X1, =szBuffer
  bl  int64asc
  ldr X0, =szBuffer
  bl  putstring

  ldr X0, =chLF
  bl  putch

  // - test szS2
  ldr X0, =szSize2 //load address of Test Prompt
  bl  putstring    //Call putstring

  ldr X0, =szS2
  bl  String_length

  ldr X1, =szBuffer
  bl  int64asc
  ldr X0, =szBuffer
  bl  putstring

  ldr X0, =chLF
  bl  putch

  // - test szS3
  ldr X0, =szSize3 //load address of Test Prompt
  bl  putstring    //Call putstring

  ldr X0, =szS3
  bl  String_length

  ldr X1, =szBuffer
  bl  int64asc
  ldr X0, =szBuffer
  bl  putstring

  ldr X0, =chLF
  bl  putch

  /*** Test Case 2 ***/
  ldr X0, =szEquals1 //load address of Test Prompt
  bl  putstring      //Call putstring

  ldr X0, =szS1
  ldr X1, =szS3
  bl  String_equals

  cmp X0, #1
  beq testCase3

  ldr X0, =szFalse
  bl  putstring

testCase3:  
  /*** Test Case 3 ***/
  ldr X0, =szEquals2 //load address of Test Prompt
  bl  putstring      //Call putstring

  ldr X0, =szS1
  ldr X1, =szS1
  bl  String_equals

  cmp X0, #0
  beq testCase4

  ldr X0, =szTrue
  bl  putstring

testCase4:  
  /*** Test Case 4 ***/
  ldr X0, =szEqualsIG1 //load address of Test Prompt
  bl  putstring        //Call putstring

  ldr X0, =szS1
  ldr X1, =szS3
  bl  String_equalsIgnoreCase

  cmp X0, #0
  beq testCase5

  ldr X0, =szTrue
  bl  putstring

testCase5:  
  /*** Test Case 5 ***/
  ldr X0, =szEqualsIG2 //load address of Test Prompt
  bl  putstring        //Call putstring

  ldr X0, =szS1
  ldr X1, =szS2
  bl  String_equalsIgnoreCase

  cmp X0, #1
  beq testCase6

  ldr X0, =szFalse
  bl  putstring

testCase6:
  /*** Test Case 6 ***/
  ldr X0, =szString_copy //load address of Test Prompt
  bl  putstring          //Call putstring

  ldr X0, =szCopyS1      //load address of Test Prompt
  bl  putstring          //Call putstring

  ldr X0, =szS1
  bl  putstring

  ldr X0, =chLF
  bl  putch

  ldr X0, =szCopyS4 //load address of Test Prompt
  bl  putstring        //Call putstring

  ldr X0, =szS1
  bl  String_copy

  ldr X1, =strPtr
  str X0, [X1]
  bl  putstring

  ldr X0, =chLF
  bl  putch

  ldr X0, =strPtr
  ldr X0, [X0]
  bl  free

  /*** Test Case 7 ***/
  ldr X0, =szSubstring1 //load address of Test Prompt
  bl  putstring         //Call putstring

  ldr X0, =szS3
  mov X1, #4
  mov X2, #14
  bl  String_substring_1
 
  ldr X1, =strPtr
  str X0, [X1]
  bl  putstring

  ldr x0,=chQ
  bl  putch

  ldr X0, =chLF
  bl  putch

  ldr X0, =strPtr
  ldr X0, [X0]
  bl  free

  /*** Test Case 8 ***/ 
  ldr X0, =szSubstring2 //load address of Test Prompt
  bl  putstring         //Call putstring

  ldr X0, =szS3
  mov X1, #7
  bl  String_substring_2
 
  ldr X1, =strPtr
  str X0, [X1]
  bl  putstring

  ldr x0,=chQ
  bl  putch

  ldr X0, =chLF
  bl  putch

  ldr X0, =strPtr
  ldr X0, [X0]
  bl  free

  /*** Test Case 9 ***/
  ldr X0, =szCharAt //load address of Test Prompt
  bl  putstring     //Call putstring

  ldr X0, =szS2
  mov X1, #4
  bl  String_charAt
  
  ldr  X1, =chBuffer
  strb W0, [X1]

  ldr X0, =chBuffer
  bl  putch

  ldr x0,=chA
  bl  putch
  
  ldr X0, =chLF
  bl  putch

  /*** Test Case 10 ***/
  ldr X0, =szStartsWith1 //load address of Test Prompt
  bl  putstring          //Call putstring

  ldr X0, =szS1
  ldr X1, =szS4
  mov X2, #11
  bl  String_startsWith_1

  cmp X0, #0
  beq testCase11

  ldr X0, =szTrue
  bl  putstring

testCase11: 
  /*** Test Case 11 ***/ 
  ldr X0, =szStartsWith2 //load address of Test Prompt
  bl  putstring          //Call putstring

  ldr X0, =szS1
  ldr X1, =szS5
  bl  String_startsWith_2

  cmp X0, #0
  beq testCase12

  ldr X0, =szTrue
  bl  putstring

testCase12:
  /*** Test Case 12 ***/ 
  ldr X0, =szEndsWith  //load address of Test Prompt
  bl  putstring        //Call putstring

  ldr X0, =szS1
  ldr X1, =szS6
  bl  String_endsWith

  cmp X0, #0
  beq testCase13

  ldr X0, =szTrue
  bl  putstring

testCase13:

ldr LR, [SP], #16
//    mov     x0,#0
//    mov     X8,#93
//    svc     0
RET  LR
