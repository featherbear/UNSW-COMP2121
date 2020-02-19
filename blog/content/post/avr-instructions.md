---
title: "AVR Instructions"
date: 2020-02-20T00:01:25+11:00

hiddenFromHomePage: false
postMetaInFooter: false

flowchartDiagrams:
  enable: false
  options: ""

sequenceDiagrams: 
  enable: false
  options: ""

---

## AVR Instruction Format

`brge` - BRanch if Greater than or Equal to. -> Uses the status registers

32 bit instructions

lds Rd, k
^ 16
^ 5

Loads 1 byte from the SRAM

### Instruction :: Add

`add Rd, Rr`

0001 01rd dddd rrrr

### Instruction :: Unconditional Branch -> 32 bit long

`jmp k`

PC <- k

1001 010k kkkk 110k kkkk kkkk kkkk kkkk

### Instruction: Conditional Branch

breq k

`-64 <= k < 63`

1111 00kk kkkk k001

## Instruction :: Multiply

`mul Rd, Rr` :: r1:r0 <- Rr\*Rd
Multiply the byte of register `Rd` by the byte of register `Rr`, and store the results in `r1` and `r0`.  
`r1` contains the first 8 bits (HI / MSB)  
`r0` contains the last 8 bits (LO / LSB)

Multiplying takes 2 cycles

## Instruction :: Load Immediate

- `ldi` `Rd`, `#number`\*
- `ldi R16, 25` -> Load the integer 25 into register 16

`ldi 1110 kkkk dddd kkkk`

In the instruction set for ldi, there are only 4 bits available for the register location.
We can therefore only have 2^4 -> 16 locations.  
AVR is developed such that these locations are respective of the upper 16 register (R16->R31).

## Instruction :: Compare

`cp Rd, Rr`

`Rd - Rr` -> Store into status register

## Instruction :: Compare Immediate

## Instruction :: Relative Jump
