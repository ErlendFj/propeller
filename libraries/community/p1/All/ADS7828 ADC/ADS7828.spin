'' Simple ADS7828 object.
'' Copyright 2008, Jonathan Peakall. Feel free to PM me if you have questions
'' Permission is given to do whatever you want with this program. See below for details.
'' This program requires the files "basic_i2c_driver" and "pc_interface".
'' Make sure to set the adc address and clock pin in the CON section.
'' Note that the adc data line must be one pin higher than the clock pin,
'' and there needs to be a 4.7k pullup on the clock pin. Pin 11
'' of the ADS7828 needs to be tied to the analog ground.
''
'' This program reads a specified channel of the ADS7828 in single ended
'' mode, using an external Vref on pin 10.
''
'' Most significant 4 bits(7-4) of address are always %1001. Read or write bit
'' is bit 0
''  MS4  ADDR
''  |  |  ||
'' %1001_0110 <- read/write bit
'' Command byte
'' Single/Differential mode (0 = diff, 1 = single ended)
''   |Address bits
''   |||| Power down bits
''   |||| ||
''  %XXXX_XXXX << last 2 bits unused

CON
    _clkmode = xtal1 + pll16x
    _xinfreq = 5_000_000

    ' PropTerm
    #0, WHITE,CYAN,RED,PINK,BLUE,GREEN,YELLOW,GRAY
    
   ' ADC
   adcCLK       = 6     ' adcData = 7
   adcAddr      = %0110 ' Address pins both pulled high
   adcAddrMask  = %1001
   adcCmdMask   = %0111

VAR

word adcResult
long adcACK
byte adcChan

OBJ

term            : "PC_Interface" 
adc             : "Basic_I2C_Driver"    

PUB init
  term.start(31,30) ' Start Propterm object
  term.str(string("ADS7828 test...")) 'Splash screen
  wait_ms(1000)
  term.out(0)   ' Clear screen

  adcChan := 7  ' Select adc channel to be read (0-7)
  adc.initialize(adcClK) ' Init adc

  repeat  ' Read channel and display results
    read_adc(adcChan)
    term.str(string("ADC result: "))
    term.dec(adcResult)
    wait_ms(500)
    term.out(0)



pub read_adc(channel) : adcRes | adcByte
  ' Take channel and translate to the ADS7828 address code 
  channel := lookupz(channel:%1000,%1001,%1010,%1011,%1100,%1101,%1110,%1111) << 4 | adcCmdMask
  adcByte :=adcAddrMask << 4 | adcAddr 
  adc.start(adcClK)                     
  adc.write(adcClK,adcByte) ' Send address and write bit
  adcByte := channel << 4 | adcCmdMask
  adc.write(adcClK,adcByte) ' Send channel and adc config
  adc.stop(adcClK)
  adc.start(adcClK)
  adcByte := adcAddrMask <<4 | adcAddr | 1
  adc.write(adcClK,adcByte) ' Send address and read bit
  adcresult.byte[1] := adc.read(adcClK,adcAck) ' Get result
  adcresult.byte[0] := adc.read(adcClK,adcAck)
  adc.stop(adcClK)  
 
PUB wait_ms(ms) ' Pause routine 
  waitcnt(cnt+(clkfreq / 1_000) * ms)
RETURN
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