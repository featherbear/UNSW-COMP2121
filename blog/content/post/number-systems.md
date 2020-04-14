---
title: "Number Systems and Encoding"
date: 2020-04-14T17:58:45+10:00

hiddenFromHomePage: false
postMetaInFooter: false

flowchartDiagrams:
  enable: false
  options: ""

sequenceDiagrams: 
  enable: false
  options: ""

---

# Number Systems

All numbers can be represented as sums of the powers of their base/radix.  

For example

* Base 10: 3597 = 3 * 10^3 + 5 * 10^2 + 9 * 10^1 + 7 * 10^0
* Base 16: F24B = 15 * 16^3 + 2 * 16^2 + 4 * 16^1 + 11 * 16^0
* Base 2: 1011 = 1 * 2^3 + 0 * 2^2 + 1 * 2^1 + 1 * 2^0

## Concept: Subtraction

Subtraction is the addition of a number's additive inverse.

`a - b = a + (-b)`

## Two's Complement

In binary arithmetic, the _two's complement_ of a number is its additive inverse.  

For an `n`-digit number, its two's complement is: `b* = 2^n - b`  
We can simplify this as `~b - 1` (Flip all the bits and subtract 1, and keep only `n` LSBs)

### Overflow Detection

In a n-bit two's complement system

* Positive Overflow occurs when: a + b > 2^(n-1) - 1
* Negative Overflow occurs when: -a -b < 2^n - 1

## Floating Point Numbers - IEEE 754 FP

[Read here](https://featherbear.github.io/UNSW-COMP1521/blog/post/data_representation/#floating-point-numbers)
