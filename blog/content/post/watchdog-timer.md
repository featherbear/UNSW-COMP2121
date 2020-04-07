---
title: "Watchdog Timer"
date: 2020-04-06T21:53:11+10:00

hiddenFromHomePage: false
postMetaInFooter: false

flowchartDiagrams:
  enable: false
  options: ""

sequenceDiagrams: 
  enable: false
  options: ""

---

The Watchdog Timer is a peripheral IO device in the ATMega2560.  

It is a counter device that can be controlled to produce different time intervals (_8 different periods determined by `WDP2`, `WDP1` and `WDP0` bits in `WDTCSR`_).

It can be enabled by modifying the `WDCE` and `WDE` bits in the Watchdog Timer Control Register (`WDTCSR`)

# Uses

## Software Crash Detection

* This device generates a Watchdog Reset interrupt when its period expires.  
* Watchdog Reset Flag (`WDRF`) is set in the MCU Control Register (`MCUCSR`).
* Program needs to reset the timer using the `wdr` instruction