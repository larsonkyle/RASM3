    .global _start
    
    .data
    
s1:                     .asciz      "Cat in the hat."
s2:                     .asciz      "Green eggs and ham."
s3:                     .asciz      "cat in the hat."
s4:                     .asciz      "cat in the hat."

szFirstInst:            .asciz      "13. String_indexOf_1(s2,'g')            = "
szFirstInstAfter:       .asciz      "14. String_indexOf_2(s2,'g',9)          = "
szFirstInstSub:         .asciz      "15. String_indexOf_3(s2,\"eggs\")         = "
szLastInst:             .asciz      "16. String_lastIndexOf_1(s2,'g')        = "
szLastInstBefore:       .asciz      "17. String_lastIndexOf_2(s2,'g',6)      = "
szLastInstSub:          .asciz      "18. String_lastIndexOf_3(s2,\"egg\")      = "
szConcatStrWithSub:     .asciz      "19. String_concat(s1, \" \"); String_concat(s1, s2) =  "
szReplace:              .asciz      "20. String_replace(s1,'a','o')          = "
szStringLowerCase:      .asciz      "21. String_toLowerCase(s1)              = "
szStringUpperCase:      .asciz      "22. String_toUpperCase(s1)              = "

subStr1:                .asciz      "eggs"
substr2:                .asciz      "egg"
substr3:                .asciz      " "

strPointer:             .quad       8

szNumBuf:               .skip       20

chLF:  .byte 0xa

    .text

Print_integer:
    str     LR,[SP,#-16]!
    ldr     x1,=szNumBuf
    bl      int64asc 
    ldr     x0,=szNumBuf 
    bl      putstring
    ldr     x0,=chLF
    bl      putch
    ldr     LR,[SP],#16      
    ret     lr    

//main:
_start:
    bl  test1

    //indexOf_1
    ldr     x0,=szFirstInst
    bl      putstring

    ldr     x0,=s2
    mov     x1,#'g'

    bl      String_indexOf_1
    bl      Print_integer
    
     //indexOf_2
    ldr     x0,=szFirstInstAfter
    bl      putstring

    ldr     x0,=s2
    mov     x1,#'g'
    mov     x2,#9

    bl      String_indexOf_2
    bl      Print_integer

    //indexOf_3
    ldr     x0,=szFirstInstSub
    bl      putstring

    ldr     x0,=s2
    ldr     x1,=subStr1

    bl      String_indexOf_3
    bl      Print_integer
    
    //lastIndexOf_1
    ldr     x0,=szLastInst
    bl      putstring

    ldr     x0,=s2  
    mov     x1,#'g'    

    bl      String_lastIndexOf_1
    bl      Print_integer

    //lastIndexOf_2
    ldr     x0,=szLastInstBefore
    bl      putstring

    ldr     x0,=s2
    mov     x1,#'g'    
    mov     x2,#6

    bl      String_lastIndexOf_2
    bl      Print_integer
   
    //lastIndexOf_3
    ldr     x0,=szLastInstSub
    bl      putstring

    ldr     x0,=s2  
    ldr     x1,=substr2   

    bl      String_lastIndexOf_3
    bl      Print_integer

    //replace
    ldr     x0,=szReplace
    bl      putstring

    ldr     x0,=s1
    mov     x1,#'a'
    mov     x2,#'o'

    bl      String_replace
    ldr     x1,=strPointer

    str     x0,[x1]
    bl      putstring

    ldr     x0,=chLF
    bl      putch

    //toLowerCase
    ldr     x0,=szStringLowerCase
    bl      putstring

    ldr     x0,=strPointer
    ldr     x0,[x0]

    bl      String_toLowerCase
    str     x0,[SP,#-16]!

    ldr     x0,=strPointer
    ldr     x0,[x0]
    bl      free

    ldr     x1,=strPointer
    ldr     x0,[SP],#16

    str     x0,[x1]
    bl      putstring

    ldr     x0,=chLF
    bl      putch
    
    //toUpperCase
    ldr     x0,=szStringUpperCase
    bl      putstring

    ldr     x0,=strPointer
    ldr     x0,[x0]

    bl      String_toUpperCase
    str     x0,[SP,#-16]!

    ldr     x0,=strPointer
    ldr     x0,[x0]
    bl      free

    ldr     x1,=strPointer
    ldr     x0,[SP],#16

    str     x0,[x1]
    bl      putstring

    ldr     x0,=chLF
    bl      putch

    //concat 1
    ldr     x0,=szConcatStrWithSub
    bl      putstring

    ldr     x0,=strPointer
    ldr     x0,[x0]
    ldr     x1,=substr3

    bl      String_concat
    str     x0,[SP,#-16]!
    
    ldr     x0,=strPointer
    ldr     x0,[x0]
    bl      free

    ldr     x1,=strPointer
    ldr     x0,[SP],#16

    str     x0,[x1]

    //concat 2
    ldr     x1,=s2

    bl      String_concat
    str     x0,[SP,#-16]!

    ldr     x0,=strPointer
    ldr     x0,[x0]
    bl      free

    ldr     x1,=strPointer
    ldr     x0,[SP],#16
    str     x0,[x1]
    bl      putstring

    ldr     x0,=chLF
    bl      putch

    ldr     x0,=strPointer
    ldr     x0,[x0]
    bl      free
    
end:
    mov     x0,#0
    mov     X8,#93
    svc     0

    .end
