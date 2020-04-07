---
title: "Interrupts"
date: 2020-03-11T13:58:34+11:00

hiddenFromHomePage: false
postMetaInFooter: false

flowchartDiagrams:
  enable: false
  options: ""

sequenceDiagrams: 
  enable: false
  options: ""

---

# What is an Interrupt?

An interrupt is a signal which causes the microprocessor to switch tasks.  
It can be considered as a function

# Assigning functions to interrupts

## Interrupt Vector Table (IVT)

The Interrupt Vector Table holds the map of which interrupts call which Interrupt Service Routine

## Interrupt Service Routines (ISR)

The ISR is the function that is executed when an interrupt is executed.  
To return from these routines, we use the `reti` instruction, compared to the usual `ret`.

# CPU Interaction

## Polling

* Software queries the I/O device
* No extra hardware needed
* Not efficient

## Interrupt

* I/O devices generate signals to request services from CPU
* Need extra hardware to implement
* Efficient

# Interrupt Systems

Interrupt systems implement interrupt services, performing the three tasks

* Recognise interrupt events
* Respond to the interrupt
* Resume the previous task

---

The CPU polls the status registers of all devices.  
When it has found an interrupt flag, it will perform a selecton algorithm to find the corresponding service routine

# Priority Resolution

When multiple interrupts occur at the same time, which one is done first?

## Daisy Chain Priority Resolution

When the CPU emits the INTA (INTerrupt Acknowledge) signal, the first device which receives it does not pass the INTA signal to the other devices until later. This device puts its vector onto the data bus and finishes it operation before passing the INTA signal.

# Separate IRQ Lines

Each Interrupt Request line is assigned a fixed priority.  

IRQ0 > IRQ1 > IRQ2 > etc

# Hierarchical Prioritisation

Higher priority interrupts are allowed, whilst lower ones are masked (dismissed)

# Non-maskable Interrupts

Cannot disable these interrupts.  
_Used for important events such as power failures._

# Performing the Interrupt

To transfer execution control to the Interrupt Service Routine (ISR).  

It takes time from when the IRQ is generated, to the time the ISR is executed.  
This time delay is known as the `interrupt latency`.  
It will take at least 5 clock cycles.  
Two for saving the PC, and three for jumping to the ISR.

* Hardware saves the return address (next intstruction to perform after the ISR is finished)
* Hardware saves registers

* Non-nested ISRs will dismiss any new interrupts
* Nested ISRs will allow new interrupts

## AVR

AVR does not have a software interrupt, so we need to virtualise an external interrupt to trigger it.  
_(PORTA into PINA?)_

To enable an interrupt, the Global Interrupt Enable bit needs to be set.  
This is the `I` bit in the status bit, and can be enabled with `sei`.  
To turn off, we can use `cli`.  

In AVR, when an interrupt is finished, the CPU will interrupt at least one more instruction (where the PC is), before any other interrupt is served.

# Interrupt Vectors

Each interrupt is 4-bytes (2 words) longo, conntaining an instruction to be executed when the interrupt has been accepted.  
The lower the memory address of the vectory, the higher its priority.

# Inside an Interrupt

When an interrupt occurs, the Global Interrupt Enable bit is often cleared - disabling other interrupts from happening.  
For the case of nested interrupts, this GEI bit is kept high.  

When the `reti` instruction is executed the GEI bit is restored