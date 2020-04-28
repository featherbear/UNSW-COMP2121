---
title: "Pulse-Width Modulation (PWM)"
date: 2020-04-28T22:30:42+10:00

hiddenFromHomePage: false
postMetaInFooter: false

flowchartDiagrams:
  enable: false
  options: ""

sequenceDiagrams: 
  enable: false
  options: ""

---

PWM is a way of digitally encoding analog signals.  
A low-pass filter is required to smoothen the input signal and eliminate noise in the PWM signal

The output voltage is proportional to the pulse width.

By systematically turning on and off rapidly in a given time, the output of that given time can be controlled. By doing so, the average voltage supplied to an LED or a Motor could be controlled.

i.e. a 75% duty cycle on a 10V source will be 12V.  
i.e. a 50% duty cycle on a 10V source will be 6V.

In AVR, we can generate a PWM signal using timers set to a PWM mode.  

* CTC Mode (Clear Timer on Compare Match) - Timer goes back to 0 when it matches the compare register
* Fast PWM - Timer goes up with overflow - On at 0, off when `TCTn` matches the compare register
* Phase Correct PWM - Timer goes up and down - On/off when `TCTn` matches the compare register

