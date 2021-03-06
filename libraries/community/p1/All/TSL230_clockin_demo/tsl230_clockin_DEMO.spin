{{ 
┌─────────────────────────────────────┬────────────────┬─────────────────────┬───────────────┐
│ TSL230 Clockin Demo                 │ BR             │ (C)2009             │ 17Jan2009     │
├─────────────────────────────────────┴────────────────┴─────────────────────┴───────────────┤
│ Demo uses TSL230 to drive propeller's XI (clock in) pin.   The result is a propeller       │
│ whose clock speed automatically changes in response to lighting conditions.  The demo      │
│ blinks 3 LEDs at different rates.  Can see TSL230's clock rate change by shining a light   │
│ on the device and observing the change in LED blink rate.                                  │
│                                                                                            │
│ This experiment has been tried two ways, both seem to work OK.                             │
│ •Method 1: set TSL230 pin 7 high such that the TSL230's output is a nice 50% duty cycle    │
│  square wave with a PLLdiv of 2X. Max TSL230 freq out is ~800KHz.                          │
│ •Method 2: tie pin 7 to GND to use the raw pulse output of the TSL230 (no PLL). This       │
│  results in a clock signal with 2X the frequency at <50% duty cycle.  Max TSL230 input     │
│  frequency to prop XIN pin ~1.6MHz.                                                        │
│                                                                                            │
│ NOTES:                                                                                     │
│ •The Propeller data sheet states that the Prop PLL min frequency input is 4MHz, so this    │
│  example has the Propeller PLL turned off.                                                 │
│ •A quick look at the TSL230's output pulse train reveals that the pulse train with no      │
│  PLLdiv (TSL230 pin 7 GND) looks something like this:                                      │
│          │
│                                                                                        │
│   400-500ns typical          Min interpulse = 600ns (bright light)                         │
│                              Max interpulse = 1 sec (dark)                                 │
│   ▶The pulse interval is relatively constant and is in the 400-500ns range.  Note that     │
│    the above figure intentionally shows variation in pulse width.                          │
│   ▶The interpulse interval is dependent on light intensity and varies from about 600ns     │
│    at full saturation up to ~1 sec in complete darkness.                                   │
│ •TSL230's pulse train with 2X PLLdiv (TSL230 pin 7 high):                                  │
│     │
│                                                                                          │
│     ~1250ns min (bright light)                                                             │
│                                                                                            │
│ See end of file for terms of use.                                                          │
└────────────────────────────────────────────────────────────────────────────────────────────┘
                                                                               
 SCHEMATIC:
───────────────────────────────────────────     ──────────────────────────────                 
          ┌──────────┐                           3X:
 3.3V ──│1 o      8│─────┐ GND                     
          │          │                                                      
 3.3V ──│2        7│──── 3.3V  or gnd                     100 Ω  LED     
          │    []    │                              ledpinX ──────────┐
      ┌──│3  TSL   6│──── Prop XI pin                                    
      │   │   230    │                                                   GND
  GND ┣──│4        5│──┘ 3.3V           
         └──────────┘                    
───────────────────────────────────────────     ───────────────────────────────                
}}
'FIXME: why doesn't this work:  clkset(RCSLOW,20_000)


CON
  _clkmode = rcfast               
' _xinfreq = 12_000_000
'hardware constants
  ledpin0        = 21                                 
  ledpin1        = 22                                 
  ledpin2        = 23                                 
'software constants
  reps           = posx
  rate0          = 10     'hz
  rate1          = 100    'hz
  rate2          = 1000   'hz


OBJ
  blink[3] : "blinker"                                'instantiate 3 blinker ojects

  
PUB Go
  blink[0].start(ledpin0,clkfreq/rate0,reps)          'start leds blinking
  blink[1].start(ledpin1,clkfreq/rate1,reps)         
  blink[2].start(ledpin2,clkfreq/rate2,reps)         

  repeat
    waitcnt(clkfreq*5 + cnt)
    clkset(%00100010,1_000_000)                       'xin

'   waitcnt(clkfreq*5 + cnt)
'   clkset(%00000001,20_000)                          'rcslow

'   waitcnt(clkfreq*5 + cnt)
'   clkset(%00000000,12_000_000)                      'rcfast


dat  

{{

┌────────────────────────────────────────────────────────────────────────────────────────────┐
│                                     TERMS OF USE: MIT License                              │                                                            
├────────────────────────────────────────────────────────────────────────────────────────────┤
│Permission is hereby granted, free of charge, to any person obtaining a copy of this        │
│software and associated documentation files (the "Software"), to deal in the Software       │
│without restriction, including without limitation the rights to use, copy, modify, merge,   │
│publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons  │
│to whom the Software is furnished to do so, subject to the following conditions:            │
│                                                                                            │                         
│The above copyright notice and this permission notice shall be included in all copies or    │
│substantial portions of the Software.                                                       │
│                                                                                            │                         
│THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,         │
│INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR    │
│PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE   │
│FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR        │
│OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER      │                                │
│DEALINGS IN THE SOFTWARE.                                                                   │
└────────────────────────────────────────────────────────────────────────────────────────────┘
}}