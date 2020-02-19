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

* USER PERSPECTIVE

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

* 32 8-bit registers :: `R0` -> `R31`
* Most operations performed within the register
* Some instructions only work on `R16` -> `R31` (encoding limitation)

## Instruction :: Load Immediate

* `ldi` `Rd`, `#number`*
* `ldi R16, 25` -> Load the integer 25 into register 16

`ldi 1110 kkkk dddd kkkk`

In the instruction set for ldi, there are only 4 bits available for the register location.
We can therefore only have 2^4 -> 16 locations.  
AVR is developed such that these locations are respective of the upper 16 register (R16->R31).  

<!-- \\ address, data, instruction
\\ instruction, target, args
op code, addr, arg(s) -->

## Instruction :: Multiply

`mul Rd, Rr` :: r1:r0 <- Rr*Rd
Multiply the byte of register `Rd` by the byte of register `Rr`, and store the results in `r1` and `r0`.  
`r1` contains the first 8 bits (HI / MSB)  
`r0` contains the last 8 bits (LO / LSB)

Multiplying takes 2 cycles

## Arithmetic Calculation

Consider having to write the following equation in assembly language: `z = 2x - xy - x^2`

Where all data including products from multiplications are 8-bit unsigned numbers.  
`x`, `y`, `z` are stored in registers `r2`, `r3`, `r4`.

> A 2-bit number x 2-bit number = a 4-bit number  
> A 8-bit number x 8-bit number = a 18-bit number  

**But**, `z` is 8-bits, not 16!  
For now assume `x`, `y` < 16 (4-bits)

<!-- Binary -> Hex | Split bits into 4s; then translate each 4-bit pair to hexadecimal -->

Could improve by factoring out `x`, removing the number of multiplications.  
Could use `r4` instead of `r5` for temporary variables.

## Registers

X Register - R27:R26
Y Register - R29:R28
Z Register - R31:R30
<!--          ^ MSB     -->
<!--              ^ LSB -->

Typically used as pointers (16 bits)

Special registers for iput and output

### I/O Registers

* 64+416 8-bit registers
* Used for input/output instructions
* The first 64 IO registers have two addresses :: I/O addresses and memory addresses

#### The Status Register (SREG)

The Status Register is an 8-bit wide register that keeps track of the previous arithmetic instruction.  
Automatically updated

| I | T | H | S | V | N | Z | C |
|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
|Global Interrupt Enable|

I -  
T -  
H - Half Carry  
S - Sign Bit  
V -   
N -   
Z - Zero Result  
C - Carry  

### Address Spaces

Data memory

Program Memory - Program

EEPROM Memory - ie startup / bootloader
-> Electrically Erasable Programmable ROM

---

## Data Memory Space

* `r0` mapped to data memory 0x0000
* `r31` mapped to data memory 0x001F

* The first 32 + 46+416 == 512 registers are all internal

* Highest memory location is defined as `RAMEND`

## Program Memory Space

* 16-bit flash memory

TODO: Notes

## EEPROM

TODO: Notes

## AVR Instruction Format

`brge` - BRanch if Greater than or Equal to. -> Uses the status registers
