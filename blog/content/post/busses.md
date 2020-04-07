---
title: "Busses"
date: 2020-03-10T15:07:11+11:00

hiddenFromHomePage: false
postMetaInFooter: false

flowchartDiagrams:
  enable: false
  options: ""

sequenceDiagrams: 
  enable: false
  options: ""

---

# What are busses?

Busses are collections of wires through which data is transmitted from one of sources to destinations

* data-bus
* address-buss
* control-bus -> Read, write, turn on, turn off, first n bits, last n bits

# Why do we have busses?

Busses allow us to connect several sources to several destinations (routing), therefore minimising the needed number of physical connections.

# Characteristics

* Bus width (bits)
  * How much data can be transmitted at a time
* Clock speed (MHz)
  * How often data can be transferred on the busses

# Input Interface

Tri-state gates to select which interfaces are disabled.  
So that only one interface will be enabled

74LS139 Decoder takes in 2 pins (A1,A0)

O0, O1, O2, O3 turned on/off depending on the values of A1 and A0

# CPU Timing

Address bus WRITE, data bus write, WRITE signal

# Set Register

`ser` -> Set all bits to 1

DDRA -> All 1 bits are OUTPUTs
INPUT -> PIN
OUTPUT -> PORT
