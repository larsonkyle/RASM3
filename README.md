# RASM3: String Functions

ASSIGNMENT DETAILS:
You will work on this assignment in teams of 2. You can decide which methods you will write and which methods your
partner will write. One of you will put your methods into String1.s and the other will put his/her methods into String2.s.

All returned values are in the X0 register: dwords returned in X0, words returned in W0. All reference variables are
returned in the X0 register since they are always addresses.
In EVERY case, if the method returns String, you must return the address of a dynamically allocated string of bytes
within the method.

FUNCTION DETAILS:
To view each function's Description, See String1/String1.s or String2/String2.s files respectively.

Each function strictly adheres to AAPCS standards

Function List:
  in  file String1.s
  -  String_length(string1:String):int
  -  String_equals(string1:String,string2:String):boolean (byte)
  -  String_equalsIgnoreCase(string1:String,string2:String):boolean (byte)
  -  String_copy(string1:String):String => +String_copy(lpStringToCopy:dword):dword
  -  String_substring_1(string1:String,beginIndex:int,endIndex:int):String
  -  String_substring_2(string1:String,beginIndex:int):String
  -  String_charAt(string1:String,position:int):char (byte)
  -  String_startsWith_1(string1:String,strPrefix:String, pos:int):boolean
  -  String_startsWith_2(string1:String, strPrefix:String):boolean
  -  String_endsWith(string1:String, suffix:String):boolean

  in  file String1.s
  -  String_length(string1:String):int
  -  String_indexOf_1(string1:String,ch:char):int
  -  String_indexOf_2(string1:String,ch:char,fromIndex:int):int
  -  String_indexOf_3(string1:String, str:String):int
  -  String_lastIndexOf_1(string1:String, ch:char):int
  -  String_lastIndexOf_2(string1:String,ch:char,fromIndex:int):int
  -  String _lastIndexOf_3(string1:String,str:String):int
  -  String_concat(string1:String,str:String):String
  -  String_replace(string1:String,oldChar:char,newChar:char):String
  -  String_toLowerCase(string1:String):String
  -  String_toUpperCase(string1:String):String
