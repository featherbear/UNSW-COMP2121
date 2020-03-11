---
title: "I/O Addressing"
date: 2020-03-11T13:21:12+11:00

hiddenFromHomePage: false
postMetaInFooter: false

flowchartDiagrams:
  enable: false
  options: ""

sequenceDiagrams: 
  enable: false
  options: ""

---

* 32 Registers
* 64 I/O Registers
* 416 External I/O Registers
* Internal SRAM
* External SRAM

---

# Memory Mapped I/O

## Advantages

* Simpler CPU design
* No special instructions for I/O acesss

## Disadvantages

* Reduce the amount of available space for applications
* Decoder needs to decode the entire memory space

---

# Separate I/O

* Extra control signals (IO/_M) is needed to prevent both memory and I/O from using the bus at the same time
  * IO/!M -> HIGH -> IO
  * IO/!M -> LOW -> MEM

# I/O Synchronisation

* CPU is much faster than I/O devices, and so there needs to be a way to synchronise CPU and I/O devices.

* Software Synchronisation
  * Real-time synchronisation
    * Use software delay to match CPU to the timing requirements of the I/O device
      * ie using `nop` instructions
      * Wastes CPU time
  * Polling
    * Wait and loop
      * `DATA_READY` bit in the status register
* Hardware Synchronisation
  * Handshaking I/O
    * Device will assert a WAIT signal
  

  
