---
title: "Stack"
date: 2020-03-03T15:18:11+11:00

hiddenFromHomePage: false
postMetaInFooter: false

flowchartDiagrams:
  enable: false
  options: ""

sequenceDiagrams: 
  enable: false
  options: ""

---

0x0000
registers, io, maps
0x0200
v heap

^ stack
0xFFFF


Stack pointer points to the NEXT free value

# Stack Operations

* PUSH an item to the stack - `push r[0-31]`
* POP an item from the stack - `pop r[0-31]`

POP items in the **reverse** order that they were pushed in.  
Also ensure that there are the same number of `push` and `pop` statements.  


