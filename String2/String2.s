    .global String_indexOf_1
    .global String_indexOf_2
    .global String_indexOf_3
    .global String_lastIndexOf_1
    .global String_lastIndexOf_2
    .global String_lastIndexOf_3
    .global String_concat
    .global String_replace
    .global String_toLowerCase
    .global String_toUpperCase
    .text

/*
String_indexOf_1
Given a string to search and a character to find, 
return the first index where the character is found

parameters:
x0 - string address
x1 - character

return:
x0 - index

not preserved:
x1, x2, x3
*/

String_indexOf_1:
    str     LR,[SP,#-16]!       // push the LR to the stack
    mov     x2,#-1              // start searching string from beginning
                                // we will add 1 to this because String_indexOf_2 starts searching one after the passed index
    bl      String_indexOf_2    // find first instance of the character between index 0 and the end
    ldr     LR,[SP],#16         // pop the LR off the stack

    ret     lr                  // return to caller

/*
String_indexOf_2
Given a string to search, a character to find, and an index to start at,
return the first index after the passed index where the character found

parameters:
x0 - string address
x1 - character
x2 - starting index

local:
x2 - string length
w3 - current character

return:
x0 - index

not preserved:
x1, x2, x3
*/

String_indexOf_2:
    add     x2,x0,x2        // add the index to start at to the address of the string
    add     x2,x2,#1        // add one because we are finding the first index after the passed one

loop_iO2:
    ldrb    w3,[x2],#1                  // load character from string + passed index into w2 and increment address of string

    cmp     w3,#0                       // if character == null terminator, 
    beq     error_char_not_found_i02    // the character is not in the string

    cmp     w3,w1                       // else if current char == passed char,
    beq     found_char_iO2              // the character was found

    b       loop_iO2                    // else continue searching

found_char_iO2:
    sub     x0,x2,x0        // x0 = found character address - initial string address
    sub     x0,x0,#1        // subtract 1 from (found character address - initial string address) because 
                            // the found character address is post incremented in the loop before exiting
    ret     lr              // return to caller

error_char_not_found_i02:
    mov     x0,#-1          // move -1 into x0 as an error code not found
    ret     lr              // return to caller

/*
String_indexOf_3
Given a string to search and a substring to find, 
return the first index where the substring is found

parameters:
x0 - string address (we will use to get index from final - initial string addresses)
x1 - substring address

local:
x1 - current substr address (we use null terminator to find if we found substring, so we don't need to remember initial substr address)
x2 - current string address
w3 - current string char
w4 - current substr char

return:
x0 - index

not preserved:
x1, x2, x3, x4
*/

String_indexOf_3:
    mov     x2,x0               // most string address to x2 to make a copy of it, as we will use it later
    ldrb    w3,[x1],#1          // load the first character from the substring to search for and increment address of substring

substr_char_loop_i03:
    ldrb    w4,[x2],#1                          // load a character from the string to compare to and increment address of string

    cmp     w4,#0                               // if string char == null terminator,
    beq     error_substr_char_not_found_iO2     // the character is not in the string

    cmp     w4,w3                               // else if current string char == current substr char
    beq     found_substr_char_i03               // a possible starting index for the substring was found

    b       substr_char_loop_i03                // else continue searching

found_substr_char_i03:
    str     x1,[SP,#-16]!                   // push the mutated substring address to the stack
    str     x2,[SP,#-16]!                   // push the mutated string address to the stack

loop_substr_i03:
    ldrb    w3,[x1],#1                      // load a character from the substring to search for and increment address of substring
    ldrb    w4,[x2],#1                      // load a character from the string to compare to and increment address of string

    cmp     w3,#0                           // if substr char == null terminator,
    beq     found_substr_i03                // the substring was found

    cmp     w4,#0                           // else if string char == null terminator,
    beq     error_substr_not_found_iO2      // the substr is not in the string

    cmp     w4,w3                           // else if string char == substr char
    beq     loop_substr_i03                 // continue searching

    ldr     x2,[SP],#16                     // else the string char != substr char, pop adjusted string address back in
    ldr     x1,[SP],#16                     // pop adjusted substr address back in
    sub     x1,x1,#1                        // we post increment x1 to check next chars in substring, but we need to go back
                                            // to original loop and keep checking for the first char
    ldrb    w3,[x1],#1                      // load the first character from the substring to search for and increment address of substring
    b       substr_char_loop_i03            // go back to first loop to find new char where a substr could start

found_substr_i03:
    ldr     x2,[SP],#16         // we advance forward away from the beginning index of the substring we need to return, 
                                // so we need it back

    sub     x0,x2,x0            // x0 = found string address - initial string address
    sub     x0,x0,#1            // subtract 1 from (found character address - initial string address) because 
                                // the found character address is post incremented in the loop before exiting
    ret     lr                  // return to caller

error_substr_not_found_iO2:
    add     SP,SP,#16           // just add 16

error_substr_char_not_found_iO2:
    mov     x0,#-1              // move -1 into x0 as an error code not found
    ret     lr                  // return to caller

/*
String_lastIndexOf_1
Given a string to search and a character to find, 
return the last index where the substring is found

parameters:
x0 - string address
x1 - character

local:
x2 - starting index/string length
w3 - current character

return:
x0 - index

not preserved:
x1, x2, x3
*/

String_lastIndexOf_1:
    str     LR,[SP,#-16]!           // push the LR to the stack
    str     x0,[SP,#-16]!           // push the string address and character to the stack
    
    bl      String_length           // put the length of the string in string address in x0
    mov     x2,x0                   // move the length to a new register so the string address and character can be brought back
                                    // no need to add 1 to the length because it is already 1 greater than the largest index

    ldr     x0,[SP],#16             // pop the string address and character off the stack
    bl      String_lastIndexOf_2    // find last instance of the character between index 0 and the end

    ldr     LR,[SP],#16             // pop LR off the stack
    ret     lr                      // return to caller

/*
String_lastIndexOf_2
Given a string to search, a character to find, and an index to start at,
return the last index before the passed index where the character found

parameters:
x0 - string address
x1 - character
x2 - starting index

local:
w3 - current character

return:
x0 - index

not preserved:
x1, x2, x3
*/

String_lastIndexOf_2:
    add     x2,x0,x2        // add the index to start at to the address of the string
    sub     x2,x2,#1        // subtract one because we are finding the last index before the passed one

loop_lIO2:
    cmp     x2,x0                       // if (string address + offset) < string address
    blt     error_char_not_found_lIO2   // the character is not in the string (for i02 we are able to test if we are at null terminator)

    ldrb    w3,[x2],#-1                 // load character from string + passed index - 1 into w3 and decerment address of string

    cmp     w3,w1                       // else if current char == passed char
    beq     found_lIO2                  // the character was found

    b       loop_lIO2                   // else continue searching

found_lIO2:
    sub     x0,x2,x0        // x0 = found character address - initial string address
    add     x0,x0,#1        // subtract 1 from (found character address - initial string address) because 
                            // the found character address is post incremented in the loop before exiting
    ret     lr              // return to caller

error_char_not_found_lIO2:
    mov     x0,#-1          // return -1, no instance of char found
    ret     lr              // return to caller

/*
String_lastIndexOf_3
Given a string to search and a substring to find, 
return the last index where the substring is found

parameters:
x0 - string address  (we will use to get index from final - initial string addresses)
x1 - substring address

local:
x2 - last string address
x3 - last substring address
x4 - current string character
x5 - current substr character

return:
x0 - index

not preserved:
x1, x2, x3, x4, x5
 */

String_lastIndexOf_3:
    str     LR,[SP,#-16]!       // push LR to the stack
    str     x0,[SP,#-16]!       // push string address to the stack

    bl      String_length       // get string length
    mov     x2,x0               // move string length into x2
    sub     x2,x2,#1            // subtract string length by 1 to get the last index of string

    ldr     x0,[SP],#16         // pop string address off the stack
    add     x2,x2,x0            // add string address to last string index to get the address of the last index of the string

    str     x0,[SP,#-16]!       // push string address to the stack
    mov     x0,x1               // move substring address to x0

    bl      String_length       // get substring length (switched in last pop)
    mov     x3,x0               // move substring length into x3
    sub     x3,x3,#1            // subtract substring length by 1 to get the last index of substring         
    add     x3,x3,x1            // add substring address to last substring index to get the address of the last index in the substring

    ldr     x0,[SP],#16         // pop string address off the stack
    ldr     LR,[SP],#16         // pop LR off the stack

    ldrb    w5,[x3],#-1         // load last character of substring into w4 and decrement last character address

// we are iterating from the back and checking if string last -> first chars == substr last -> first chars
substr_char_loop_lIO3:
    cmp     x2,x0                               // if address of next char to test in string == address of string
    blt     error_substr_char_not_found_lIO3    // the character is not in the string

    ldrb    w4,[x2],#-1                         // load character from back of string and decrement next character address

    cmp     w4,w5                               // else if current string char == current substr char
    beq     found_substr_char_lIO3              // a possible starting index for the substring was found

    b       substr_char_loop_lIO3               // else continue searching

found_substr_char_lIO3:
    stp     x2,x3,[SP,#-16]!                // push address of next char from back of string and address of next char from back fo substr to the stack

loop_substr_lIO3:
    cmp     x3,x1                           // if current substr address < substr address
    blt     found_substr_lIO3               // we have found the substr

    cmp     x2,x0                           // else if current string address < string address
    blt     error_substr_not_found_lIO3     // substr does not exist

    ldrb    w4,[x2],#-1                     // load next string char and decrement char string address    
    ldrb    w5,[x3],#-1                     // load next substr char and decrement char substr address

    cmp     w4,w5                           // else if current string char == current substr char
    beq     loop_substr_lIO3                // continue searching

    ldp     x2,x3,[SP],#16                  // else current string char != current substr char, pop adjusted back of string and back of substr addresses back in
    add     x3,x3,#1                        // we post decrement x1 to check next chars in substring, but we need to go back
                                            // to original loop and keep checking for the first char
    ldrb    w5,[x3],#1                      // load the first character from the substring to search for and decrement address of substring
    b       substr_char_loop_lIO3           // go back to first loop to find new char where a substr could start

found_substr_lIO3:
    add     SP,SP,#16           // we advance toward the beginning index of the substring, so we will already have it

    add     x2,x2,#1            // add 1 because of post decrement in substr_loop
    sub     x0,x2,x0            // x0 = found substr address - initial string address

    ret     lr                  // return to caller

error_substr_not_found_lIO3:
    add     SP,SP,#16           // just add 16

error_substr_char_not_found_lIO3:
    mov     x0,#-1              // move -1 into x0 as an error code not found
    ret     lr                  // return to caller

/*
String_concat
Given a string to copy to (CT string) and a string to copy (C String), return the address
of the CT string with the C string concatenated to the end of it

parameters:
x0 - address of string to be copied to (CT string)
x1 - address of string to copy (C String)

local:
x2 - string length
w3 - current character

return:
x0 - address of new string

AAPCS registers x19 - x29 are preserved (none others guaranteed)
*/

String_concat:
    str     X19,[SP, #-16]! // preserved required AAPCS registers
    str     X20,[SP, #-16]!
    str     X21,[SP, #-16]!
    str     X22,[SP, #-16]!
    str     X23,[SP, #-16]!
    str     X24,[SP, #-16]!
    str     X25,[SP, #-16]!
    str     X26,[SP, #-16]!
    str     X27,[SP, #-16]!
    str     X28,[SP, #-16]!
    str     X29,[SP, #-16]!

    str     LR,[SP,#-16]!       // push LR to the stack
    stp     x0,x1,[SP,#-16]!    // push address of CT string and C string to the stack

    bl      String_length       // get length of CT string
    mov     x2,x0               // move length of CT string into x2
    
    mov     x0,x1               // mov address of C string into x0
    bl      String_length       // get length of C string

    add     x0,x0,x2            // x0 = length of C string + length of CT string
    add     x0,x0,#1            // x0 = length sum + 1 to account for null terminator
    
    bl      malloc              // malloc - # of bytest in x0 -> addresss of dym alloc mem in x0

    ldp     x1,x2,[SP],#16      // pop address of CT string and address of C string off the stack
    ldr     LR,[SP],#16         // pop LR off the stack
    str     x0,[SP,#-16]!       // push address of dyn alloc mem to the stack

CT_copy_concat:   
    ldrb    w3,[x1],#1          // load character from CT string into w3

    cmp     w3,#0               // if current char == null terminator
    beq     C_copy              // go to copy C string

    strb    w3,[x0],#1          // else, we need to keep copying the CT string, so store character into dyn alloc mem
    b       CT_copy_concat      // go to top of loop to get new character

C_copy:
    ldrb    w3,[x2],#1          // load character from C string into w3
    strb    w3,[x0],#1          // store character into dyn alloc mem (before comparison because we will need to store the null terminator)

    cmp     w3,#0               // if current char == null terminator
    beq     complete_concat     // end concat

    b       C_copy              // else, go to top of loop to get new character

complete_concat:
    ldr     x0,[SP],#16         // pop address of dyn alloc mem off the stack

    ldr     X29,[SP],#16        // preserved required AAPCS registers
    ldr     X28,[SP],#16
    ldr     X27,[SP],#16
    ldr     X26,[SP],#16
    ldr     X25,[SP],#16
    ldr     X24,[SP],#16
    ldr     X23,[SP],#16
    ldr     X22,[SP],#16
    ldr     X21,[SP],#16
    ldr     X20,[SP],#16
    ldr     X19,[SP],#16

    ret     lr                  // return to caller

/*
String_replace
Given a string to work with, character to replace (CTR), and character to replace with (CTRW),
return the address of the string with the CTR replaced with the CTRW

parameters:
x0 - address of string
x1 - character to replace (CTR)
x2 - character to replace with (CTRW)

local:
x2 - moved CTR
x3 - moved CTRW
w4 - current character

return:
x0 - address of new string

AAPCS registers x19 - x29 are preserved (none others guaranteed)
*/

String_replace:
    str     X19,[SP, #-16]! // preserved required AAPCS registers
    str     X20,[SP, #-16]!
    str     X21,[SP, #-16]!
    str     X22,[SP, #-16]!
    str     X23,[SP, #-16]!
    str     X24,[SP, #-16]!
    str     X25,[SP, #-16]!
    str     X26,[SP, #-16]!
    str     X27,[SP, #-16]!
    str     X28,[SP, #-16]!
    str     X29,[SP, #-16]!

    stp     LR,x0,[SP,#-16]!    // push LR and address of string to the stack

    bl      String_length       // get length of string
    add     x0,x0,#1            // add 1 to length of string to account for null terminator

    bl      malloc              // malloc - # of bytest in x0 -> addresss of dym alloc mem in x0

    ldp     x2,x3,[SP],#16      // pop CTR and CTRW off the stack
    ldp     LR,x1,[SP],#16      // pop LR and address of string off the stack
    str     x0,[SP,#-16]!       // push address of dyn alloc mem to the stack

loop_replace:
    ldrb    w4,[x1],#1              // load character from string into w4

    cmp     w4,#0                   // if current char == null terminator
    beq     complete_replace        // end replace

    cmp     w4,w2                   // else if current char == CTRW
    beq     CTR_CTRW_swap_replace   // swap CTR with CTRW

    strb    w4,[x0],#1          // else store current char to dyn alloc mem
    b       loop_replace        // go to the top of the loop to get new character

CTR_CTRW_swap_replace:
    strb    w3,[x0],#1          // store CTRW in the spot of a CTR in the dyn alloc mem
    b       loop_replace        // go to the top of the loop to get new character

complete_replace:
    strb    w4,[x0]             // store null terminator (must do after loop as there is conditional regarding what is stored)
    ldr     x0,[SP],#16         // pop address of dyn alloc mem off the stack

    ldr     X29,[SP],#16        // preserved required AAPCS registers
    ldr     X28,[SP],#16
    ldr     X27,[SP],#16
    ldr     X26,[SP],#16
    ldr     X25,[SP],#16
    ldr     X24,[SP],#16
    ldr     X23,[SP],#16
    ldr     X22,[SP],#16
    ldr     X21,[SP],#16
    ldr     X20,[SP],#16
    ldr     X19,[SP],#16

    ret     lr                  // return to caller

/*
String_toLowerCase
Given a string to work with, return the string with all upper case letters
replaced with their corresponding lower case versions

parameters:
x0 - address of string to work with

local:
x1 - moved string address
x2 - current char

return:
x0 - address of new lowercase string

AAPCS registers x19 - x29 are preserved (none others guaranteed)
*/

String_toLowerCase:
    str     X19,[SP, #-16]! // preserved required AAPCS registers
    str     X20,[SP, #-16]!
    str     X21,[SP, #-16]!
    str     X22,[SP, #-16]!
    str     X23,[SP, #-16]!
    str     X24,[SP, #-16]!
    str     X25,[SP, #-16]!
    str     X26,[SP, #-16]!
    str     X27,[SP, #-16]!
    str     X28,[SP, #-16]!
    str     X29,[SP, #-16]!

    stp     LR,x0,[SP,#-16]!    // push LR and string address to the stack

    bl      String_length       // get length of string
    add     x0,x0,#1            // add 1 to length of string to account for null terminator

    bl      malloc              // malloc - # of bytest in x0 -> addresss of dym alloc mem in x0

    ldp     LR,x1,[SP],#16      // pop LR and string address off the stack
    str     x0,[SP,#-16]!       // push address of dyn alloc mem to the stack

loop_toLowerCase:
    ldrb    w2,[x1],#1                      // load character from string into w5

    cmp     w2,#'Z'                         // if letter > 'Z'
    bgt     eval_continue_end_toLowerCase   // copy unchanged character

    cmp     w2,#'A'                         // else if letter < 'A'
    blt     eval_continue_end_toLowerCase   // copy unchanged character
    
    add     w2,w2,#32                       // else letter is uppercase - convert to lowercase

eval_continue_end_toLowerCase:
    strb    w2,[x0],#1          // store character into dyn alloc mem

    cmp     w2,#0               // if current char != null terminator
    bne     loop_toLowerCase    // go to the top of the loop to get new character

    ldr     x0,[SP],#16         // pop address of dyn alloc mem off the stack

    ldr     X29,[SP],#16        // preserved required AAPCS registers
    ldr     X28,[SP],#16
    ldr     X27,[SP],#16
    ldr     X26,[SP],#16
    ldr     X25,[SP],#16
    ldr     X24,[SP],#16
    ldr     X23,[SP],#16
    ldr     X22,[SP],#16
    ldr     X21,[SP],#16
    ldr     X20,[SP],#16
    ldr     X19,[SP],#16

    ret     lr                  // return to caller

/*
String_toUpperCase
Given a string to work with, return the string with all lower case letters
replaced with their corresponding upper case versions

parameters:
x0 - address of string to work with

local:
x1 - moved string address
x2 - current char

return:
x0 - address of new uppercase string

AAPCS registers x19 - x29 are preserved (none others guaranteed)
*/

String_toUpperCase:
    str     X19,[SP, #-16]! // preserved required AAPCS registers
    str     X20,[SP, #-16]!
    str     X21,[SP, #-16]!
    str     X22,[SP, #-16]!
    str     X23,[SP, #-16]!
    str     X24,[SP, #-16]!
    str     X25,[SP, #-16]!
    str     X26,[SP, #-16]!
    str     X27,[SP, #-16]!
    str     X28,[SP, #-16]!
    str     X29,[SP, #-16]!

    stp     LR,x0,[SP,#-16]!    // push LR and string address to the stack

    bl      String_length       // get length of string
    add     x0,x0,#1            // add 1 to length of string to account for null terminator

    bl      malloc              // malloc - # of bytest in x0 -> addresss of dym alloc mem in x0

    ldp     LR,x1,[SP],#16      // pop LR and string address off the stack
    str     x0,[SP,#-16]!       // push address of dyn alloc mem to the stack

loop_toUpperCase:
    ldrb    w2,[x1],#1                      // load character from string into w5

    cmp     w2,#'z'                         // if letter > 'z'
    bgt     eval_continue_end_toUpperCase   // copy unchanged character

    cmp     w2,#'a'                         // else if letter < 'a'
    blt     eval_continue_end_toUpperCase   // copy unchanged character
    
    sub     w2,w2,#32                       // else letter is uppercase - convert to Uppercase

eval_continue_end_toUpperCase:
    strb    w2,[x0],#1          // store character into dyn alloc mem

    cmp     w2,#0               // if current char != null terminator
    bne     loop_toUpperCase    // go to the top of the loop to get new character

    ldr     x0,[SP],#16         // pop address of dyn alloc mem off the stack

    ldr     X29,[SP],#16        // preserved required AAPCS registers
    ldr     X28,[SP],#16
    ldr     X27,[SP],#16
    ldr     X26,[SP],#16
    ldr     X25,[SP],#16
    ldr     X24,[SP],#16
    ldr     X23,[SP],#16
    ldr     X22,[SP],#16
    ldr     X21,[SP],#16
    ldr     X20,[SP],#16
    ldr     X19,[SP],#16

    ret     lr                  // return to caller
    
    .end
