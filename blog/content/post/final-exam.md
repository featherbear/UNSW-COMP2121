---
title: "Final Exam"
date: 2020-05-09T15:23:10+10:00

hiddenFromHomePage: true
postMetaInFooter: false

flowchartDiagrams:
  enable: false
  options: ""

sequenceDiagrams: 
  enable: false
  options: ""

---

[Attempt](./attempt.html)

# Question 8

```
func1() -> 11 * 100
func2() -> 570 + max(func4(), func5()) -> 570 + 70

func3() -> 21 * 40

max(func1(), func2()) + func3()

ANS = 11*100 + 21*40
```

# Question 17

## Python interpretation

```
p = 0x33
count = 0
max = 0xffff4345
fin = False

  
def increase():
  global p, count, max, fin
  count += 1
  if count == max:
    fin = True


def run():
  global p, count, max, fin
      
  carry = (0b10000000 & p) >> 7
  p = 0xFF & (p << 1)
  
  while fin == False:
    if carry == 0:
      increase()
    else:
      p = 0xFF & (p + 1)
      increase()
```      

## By hand, and finding patterns

```
00110011 -> 01100110 (0) - c = 1
01100110 -> 11001100 (0) - c = 2
11001100 -> 10011000 (1) - 10011001 - c = 3
10011001 -> 00110010 (1) - 00110011 - c = 4

00110011 -> 01100110 (0) - c = 5
01100110 -> 11001100 (0) - c = 6
11001100 -> 10011000 (1) - 10011001 - c = 7
10011001 -> 00110010 (1) - 00110011 - c = 8
```

