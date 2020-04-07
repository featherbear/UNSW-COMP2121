---
title: "External Interrupts"
date: 2020-04-06T22:03:34+10:00

hiddenFromHomePage: false
postMetaInFooter: false

flowchartDiagrams:
  enable: false
  options: ""

sequenceDiagrams: 
  enable: false
  options: ""

---

* Triggered by the `INT7:0` pins.
* Will trigger even if the pins are triggered as outputs
  * Meaning, to trigger a softwre interrupt, set the data direction of `INTx` to an output pin, enable external interrupts for `INTx` and set `INTx` to 1
* Configurable to trigger by Falling Edge, Rising Edge, or Logic Level
  * External Interrupt Control Register A (`EICRA`) for `INT3:0`
  * External Interrupt Control Register B (`EICRB`) for `INT7:4`

# To enable an interrupt

* Set the I bit in SREG (`sei`)
* Set the `INTx` bit to 1 in `EIMSK`

# To activate an interrupt

* Interrupt must be enabled
* Associated pin must have a signal asserted

# EICR[AB] Registers

Each interrupt needs two bits to control its behaviour, hence why two 8-bit registers needed.  
_8 interrupts * 2 bits = 16 bits = 16 / 8 bits per register = 2 registers_.

|| ISC31 | ISC30 || ISC21 | ISC20 || ISC11 | ISC10 || ISC01 | ISC00 ||

|ISCn1|ISCn0|Description|
|:---:|:---:|:----------|
|0|0|Low level of INTn generates an INTR|
|0|1|Reserved|
|1|0|Falling edge of INTn generates an INTR|
|1|1|Rising edge of INTn generates an INTR|

# External Interrupt Flag Register

Bits on the register are set to 1 when an enabled interrupt is triggered