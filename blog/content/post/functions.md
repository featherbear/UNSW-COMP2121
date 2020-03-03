---
title: "Functions"
date: 2020-03-03T15:24:56+11:00

hiddenFromHomePage: false
postMetaInFooter: false

flowchartDiagrams:
  enable: false
  options: ""

sequenceDiagrams: 
  enable: false
  options: ""

---


0 ADD
1 MOV
2 LDI
3 BRANCH -2

BRANCH GOES TO 2, because the program counter is changed right after loading

FETCH DECODE SET EXECUTE

-- JMP is 2 words (2 16-bit long), but is still considered as one instruction

# Functions

* Functions are modular - which can increase readability and maintainability
* They are designed for reusability

* `call` will automatically `push` `PC` onto the stack, so that we can come back to it later.  
* The `ret`urn function will automatically `pop` the stack.

* Store the status register on the stack!!

## Register Conflicts!

Push previous values onto the stack, so that the called function can use those registers.  
When the function returns, restore the register values from the stack.  
  




1) Push return address
2) Push conflict registees
3) push variables
4) Push parameters

----
