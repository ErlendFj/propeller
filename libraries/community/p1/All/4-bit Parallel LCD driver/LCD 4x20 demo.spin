{{┌──────────────────────────────────────────┐
  │ Parallel 4 x 20 LCD demo                 │   
  │ Author: Chris Gadd                       │   
  │ Copyright (c) 2013 Chris Gadd            │   
  │ See end of file for terms of use.        │                                                         
  └──────────────────────────────────────────┘

  A short demonstration of my parallel LCD driver using a 4 x 20 display in 4-bit mode
   Full details in LCD driver object
  
}}                   
CON
_clkmode = xtal1 + pll16x                                               
_xinfreq = 5_000_000

'LCD pins
RS_pin   = 23                                           '  RS  - low for commands, high for text 
RW_pin   = 22                                           '  R/W - low for write, high for read    
E_pin    = 21                                           '  E   - clocks the data lines           
D4_pin   = 16                                           '  D4 through D7 must be connected to consecutive pins
'D5      = 17                                           '     with D4 on the low pin 
'D6      = 18
'D7      = 19
                                                                                                     
OBJ
  LCD : "LCD SPIN driver - 4x20"                         
  
PUB Main | i
  waitcnt(cnt + clkfreq)


  LCD.start(E_pin,RW_pin,RS_pin,D4_pin)

  LCD.str(string("Hello world!"))                                                          ' Send a string
  waitcnt(clkfreq * 2 + cnt)

  LCD.scroll_r(string("This LCD driver supports scrolling text,"),1)                       ' Scroll line 1 right            
  LCD.scroll_r(string("independently       "),2)                                           ' Scroll line 2 right
  LCD.scroll_r(string("on all              "),3)
  LCD.scroll_r(string("four lines.         "),4)
  
  waitcnt(cnt + clkfreq)
  LCD.scroll_all(string("or all lines        "),"R",(string("simultaneously      ")),"R",(string("in both             ")),"L",(string("directions.         ")),"L") ' Scroll lines 1 & 2 right, 2 & 3 left
  waitcnt(cnt + clkfreq * 2)

  LCD.scroll_up(string("Scroll up"))
  repeat 4
    waitcnt(cnt + clkfreq / 2)
    LCD.scroll_up(0)

  LCD.scroll_down(string("and scroll down"))
  repeat 4
    waitcnt(cnt + clkfreq / 2)
    LCD.scroll_down(0)

  LCD.clear
  LCD.str(string("Also blinking"))                                                                      
  LCD.blink(3)                                                                             ' blink display 3 times
  LCD.move(2,1)
  LCD.str(string("on each line."))
  LCD.blink_ind(2,0)                                                                       ' blink line 2 indefinitely               
    
DAT                     
{{
┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                                   TERMS OF USE: MIT License                                                  │                                                            
├──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation    │ 
│files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,    │
│modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software│
│is furnished to do so, subject to the following conditions:                                                                   │
│                                                                                                                              │
│The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.│
│                                                                                                                              │
│THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE          │
│WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR         │
│COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,   │
│ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                         │
└──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
}}            