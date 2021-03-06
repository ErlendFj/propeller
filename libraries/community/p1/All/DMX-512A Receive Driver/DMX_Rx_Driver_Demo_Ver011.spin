''**************************************
''
''  DMX Rx Driver Demo Ver. 01.1
''
''  Timothy D. Swieter, E.I.
''  www.brilldea.com
''
''  Copyright (c) 2008 Timothy D. Swieter, E.I.
''  See end of file for terms of use.
''
''  Updated: March 20, 2008
''
''Description:
''This program uses the DMX_Rx_Driver to
''read and parse a DMX-512A stream of data.
''
''See the driver code for schematic and reference material
''      
''**************************************

CON               'Constants to be located here
'***************************************
'  Hardware related settings
'***************************************
  _clkmode = xtal1 + pll16x                             'Use the PLL to multiple the external clock by 16
  _xinfreq = 5_000_000                                  'An external clock of 5MHz. is used (80MHz. operation)

'***************************************
'  System Definitions      
'***************************************

  _OUTPUT       = 1             'Sets pin to output in DIRA register
  _INPUT        = 0             'Sets pin to input in DIRA register  
  _HIGH         = 1             'High=ON=1=3.3v DC
  _ON           = 1
  _LOW          = 0             'Low=OFF=0=0v DC
  _OFF          = 0
  _ENABLE       = 1             'Enable (turn on) function/mode
  _DISABLE      = 0             'Disable (turn off) function/mode

'***************************************
'  Program Definitions     
'***************************************

  _channel      = 1             'Channel to read        

VAR               'Variables to be located here

  byte  myvariable              'a variable to be manipulated by DMX

OBJ               'Object declaration to be located here

  DMX           : "DMX_Rx_Driver_Ver014.spin"

PUB main

'' This is the main routine where the magic happens

  'Start the object (replace the pin numbers with the correct pins for your setup
  DMX.start(10, 12)

  repeat
    'This line checks the start byte to ensure the data about to be
    'read is in fact dimmer data.  A more correct thing to do would be
    'to bring over an entire array at a time.
    if DMX.level(0) == 0
      myvariable := DMX.level(_channel)

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