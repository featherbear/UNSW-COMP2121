---
title: "Introduction"
date: 2020-02-18T15:12:39+11:00

hiddenFromHomePage: false
postMetaInFooter: false

flowchartDiagrams:
  enable: false
  options: ""

sequenceDiagrams: 
  enable: false
  options: ""

---


USER PERSPECTIVE

* Labs -> Read before lab session
* Labs -> Do at home

* Group project due week 10

3pm wednesday consulation

# Atmel AVR

* 8-bit RISC Architecture
  * Reduced Instruction Set Computer
  * Most instructions have a fixed length of 16-bits
  * Most instructions take 1 clock cycle to execute
* Load-store memory access architecture
  * All calculations performed on registers
* Two stage instruciton pipelining
* Internal program memory memory and data memory
* Peripherals - PWM, ADC, EEPROM, UART

## Registers

* 32 8-bit registers :: R0 -> R31
* Some instructions only work on R16 -> R31 (encoding limitation) **************************************
* `ldi` `Rd`, `#number`*
* `ldi R16, 25` -> Load the integer 25 into register 16
* Most operations performed within the register

\\ address, data, instruction
\\ instruction, target, args
op code, addr, arg(s)

--

## Arithmetic Calculation (1/4)

`z = 2x - xy - x^2`

Where all data including products from multiplications are 8-bit unsigned numbers.  
`x`, `y`, `z` are stored in registers `r2`, `r3`, `r4`.

2-bit x 2-bit = a 4-bit number  
8-bit x 8-bit = a 18-bit number  

But `z` is 8-bits, not 16!

Assume `x`, `y` < 16 (4-bits)

mul Rd, Rr :: r1:r0 <- Rr*Rd
r1 -> first 8 bits -> HI || MSB
r0 -> last 8 bits -> LO || LSB

ldi 1110 kkkk dddd kkkk

In the instruction set for ldi, there are only 4 bits available for the register location
We can therefore only have 2^4 -> 16 locations
AVR is developed such that these locations are respective of the upper 16 register (R16->R31)
**********************


Binary -> Hex | Split bits into 4s; then translate each 4-bit pair to hexadecimal


## Arithmetic Calculation (2/4)

z = 2x - xy - x^2

multiplying takes 2 cycles

could improve by factoring out x, removing the number of multiplications
could use r4 instead of r5 for temporary variables
