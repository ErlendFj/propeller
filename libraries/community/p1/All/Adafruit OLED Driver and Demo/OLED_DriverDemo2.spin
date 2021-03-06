{{      
**************************************
* Adafruit OLED 128x32 or 128x64     *
* Display Demo                       *
* Author: Thomas P. Sullivan         *
* See end of file for terms of use.  *
* 12/16/2012                         *
**************************************

 -----------------REVISION HISTORY-----------------
 v1.00 - Original Version - 12/16/2012 
 v1.01 - Changes to support both the x32 and x64 displays - 12/27/2012 

}}

CON
  _clkmode = xtal1 + pll16x                           
  _xinfreq = 5_000_000

  CS    = 7
  RST   = 6
  DC    = 5
  CLK   = 4
  DATA  = 3

{{
     ┌─────────────────────────┐         ┌─────────────────────────┐ 
     │                         │         │                         │ 
     │         Adafruit        │         │         Adafruit        │ 
     │          128x32         │         │          128x64         │ 
     │       OLED Display      │         │       OLED Display      │ 
     │                         │         │                         │ 
     │   RST   CLK   VIN   GND │         │   RST   CLK   VIN   GND │ 
     │ CS   D/C   DATA  3.3    │         │ CS   D/C   DATA  3.3    │ 
     └─┬──┬──┬──┬──┬──┬──┬──┬──┘         └─┬──┬──┬──┬──┬──┬──┬──┬──┘ 
       │  │  │  │  │  │  │  │              │  │  │  │  │  │  │  │    
     ┌─┴──┴──┴──┴──┴──┴──┴──┴──┐         ┌─┴──┴──┴──┴──┴──┴──┴──┴──┐ 
     │ P7 P6 P5 P4 P3 NC V GND │         │ P7 P6 P5 P4 P3 NC V GND │ 
     │                   D     │         │                   D     │ 
     │                   D     │         │                   D     │ 
     │                         │         │                         │ 
     │                         │         │                         │ 
     │        Parallax         │         │        Parallax         │ 
     │  Propeller Demo Board   │         │  Propeller Demo Board   │ 
     └─────────────────────────┘         └─────────────────────────┘ 
}}

OBJ
  OLED    :     "OLED_AsmFast"       ''OLED dedicated SPI engine in Assembly
  NUM     :     "Numbers"

VAR
  long qq
  byte tstr[32]

PUB SPI_DEMO|h,i,j,k,q,r,s,count

  ''****************
  ''128x32 OLED Demo
  ''****************

  ''*************
  ''Init the OLED
  ''*************
  OLED.Init(CS,DC,DATA,CLK,RST,OLED#SSD1306_SWITCHCAPVCC,OLED#TYPE_128X64)

  ''For random number generation
  q:=12
  r:=200
  count := 1  'For display inversion control
  repeat

    ''**********************************
    ''Display the Adafruit Splash Screen
    ''**********************************
    OLED.clearDisplay
    OLED.AutoUpdateOff
    bytemove(OLED.getBuffer,OLED.getSplash,OLED#LCD_BUFFER_SIZE_BOTH_TYPES)  
    OLED.updateDisplay
    waitcnt(clkfreq*3+cnt)
    count++
    if(count&$1)
      OLED.invertDisplay(true)
    else  
      OLED.invertDisplay(false)
    OLED.updateDisplay
    waitcnt(clkfreq*3+cnt)

    ''******************************************
    ''Write random 5x7 characters to the display
    ''******************************************
    'AutoUpdate Off for more speed
    OLED.AutoUpdateOff
    OLED.clearDisplay
    repeat 1024
      if (OLED.GetDisplayType==OLED#TYPE_128X32)
        OLED.Write5x7Char(GetRandomChar,||k?//4,||q?//16)
      else
        OLED.Write5x7Char(GetRandomChar,||k?//8,||q?//16)
      OLED.updateDisplay

    ''******************************************************
    ''Display the contents of memory. Display the address as
    ''Hex, the value at that memory location as Hex and the
    ''value in memory as two lines of binary numbers (2*16)
    ''******************************************************
    OLED.AutoUpdateOff
    OLED.clearDisplay
    repeat q from 0 to 512 step 16
      bytemove(@tstr,NUM.ToStr(||WORD[q+2],NUM#BIN17),20)
      OLED.write4x16String(@tstr[1],16,0,0)
      bytemove(@tstr,NUM.ToStr(||WORD[q+0],NUM#BIN17),20)
      OLED.write4x16String(@tstr[1],16,1,0)
      bytemove(@tstr,NUM.ToStr(||WORD[q+6],NUM#BIN17),20)
      OLED.write4x16String(@tstr[1],16,2,0)
      bytemove(@tstr,NUM.ToStr(||WORD[q+4],NUM#BIN17),20)
      OLED.write4x16String(@tstr[1],16,3,0)
      if (OLED.GetDisplayType==OLED#TYPE_128X64)
        bytemove(@tstr,NUM.ToStr(||WORD[q+10],NUM#BIN17),20)
        OLED.write4x16String(@tstr[1],16,4,0)
        bytemove(@tstr,NUM.ToStr(||WORD[q+8],NUM#BIN17),20)
        OLED.write4x16String(@tstr[1],16,5,0)
        bytemove(@tstr,NUM.ToStr(||WORD[q+14],NUM#BIN17),20)
        OLED.write4x16String(@tstr[1],16,6,0)
        bytemove(@tstr,NUM.ToStr(||WORD[q+12],NUM#BIN17),20)
        OLED.write4x16String(@tstr[1],16,7,0)

      OLED.updateDisplay
      waitcnt(clkfreq/10+cnt)
      
    ''****************************************************
    ''Scrolling Parallax - 16x32 Font, 1 line 8 characters
    ''****************************************************
    OLED.AutoUpdateOn
    OLED.clearDisplay
    OLED.write1x8String(String("Parallax"),strsize(String("Parallax")))
    if (OLED.GetDisplayType==OLED#TYPE_128X64)
      OLED.write2x8String(String("  Inc.  "),strsize(String("  Inc.  ")),1)
    waitcnt(clkfreq+cnt)
    OLED.startscrollleft(0,31)
    waitcnt(clkfreq*4+cnt)
    OLED.startscrollright(0,31)
    waitcnt(clkfreq*4+cnt)
    OLED.stopscroll
    waitcnt(clkfreq+cnt)

    ''******************************************
    ''Display a few screens full of random lines
    ''drawn end-to-end
    ''******************************************
    OLED.AutoUpdateOn
    repeat 5
      OLED.clearDisplay
    ' 'Start in the center of the screen
      j:=64
      k:=16
      repeat s from 1 to 100
        h:=||(q?//OLED.GetDisplayWidth)
        i:=||(r?//OLED.GetDisplayHeight)
        OLED.line(j,k,h,i,1)
        j:=h
        k:=i

    ''******************************************
    ''Display a few screens full of random boxes
    ''******************************************
    OLED.AutoUpdateOn
    repeat 5
      OLED.clearDisplay
    ' 'Start in the center of the screen
      j:=64
      k:=16
      repeat s from 1 to 50
        h:=||(q?//OLED.GetDisplayWidth)
        i:=||(r?//OLED.GetDisplayHeight)
        OLED.box(j,k,h,i,1)
        j:=h
        k:=i

            
PUB GetRandomChar|c
  repeat
    c:= ((||qq?) + 32) & $07F
  while((c<0)AND(C<128))  

  return c

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