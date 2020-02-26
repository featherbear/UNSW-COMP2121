---
title: "Introduction"
date: 2020-02-25T15:05:14+11:00

hiddenFromHomePage: false
postMetaInFooter: false

flowchartDiagrams:
  enable: false
  options: ""

sequenceDiagrams: 
  enable: false
  options: ""

---

Case sensitive

# Define directives

* `.def temp = r15`
  * Maps `temp` to `r15`
  * Preprocesses
* Constants
  * .EQU A = B
* Variable
  * .SET
* Comments `;[Text]`

.org -> origin
.cseg -> code segment
.dseg -> data segment
.db
---

```
.dseg
.org 0x100 ; from address 0x100

vartab .BYTE 4; reserve 4 bytes in SRAM from address 0x100
.cseg; Start code segment (Default start location 0x0000)

const: .DW 10, 0x10, 0b10, -1
; Write 10, 16, 2, -1 in program memory, each value takes 2 bytes
...

.DB -> store byte in data <s>program</s> memory
.DW -> store word in data <s>program</s> memory

.BYTE -> Store in data memory

.include "m2560def.inc"

----

Alignment - extra null pads
--

 

 Constant values -> program memory

 Can put expression -> ldi r26, low(label + 0x0ff0)
                                          operator
                                    operand


TODO: Extra functions


$A0 == 0xA0

cp
cpc - carry after previous `cp`
