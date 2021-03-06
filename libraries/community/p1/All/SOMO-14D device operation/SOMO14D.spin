{{
***************************************
*        SOMO14D Object V1.0          *
* Author:  Gary Campbell              *
* Copyright (c) 2012 Gary Campbell    *
* See end of file for terms of use.   *    
* Started: 06-26-2012                 *
***************************************

Interface to 4dsystems SOMO-14D Embedded Audio Module.
See www.4dsystems.com.au for details.
The SOMO-14D is a tiny Audio-Sound module that
can play back pre-stored audio files such as voice
and music from a micro-SD memory card. The
module supports 4-bit ADPCM audio files with
sample rates from 6Khz up to 32Khz. By using the
freely available software tool, any WAVE(.wav) or
MP3(.mp3) file can be easily converted to the
ADPCM(.ad4) format which can then be can be
saved to a micro-SD memory card.

Propeller operates SOMO-14D in SERIAL MODE.
The SERIAL-MODE provides a simple 2-wire
interface to any micro-controller. The host micro
communicates with the module via the DATA and
CLK lines.
All commands are composed of single word (16
bit) data that must be clocked into the module in
a serial fashion (most significant bit first). The
clock rate is approximately 5Khz

Connection To Propeller is 4 pins...
          
        ┌──────────┐
        │ Propeller│
   ┌────┤P0(BUSY)  │      
   │┌───┤P1(DATA)  │       2GB microSD card
   ││┌──┤P2(CLK)   │       formatted FAT16
   │││┌─┤P3(RESET) │    
   ││││ └──────────┘  
   │││└──────────────┐
   │││  ┌─────────┐  │
   │││  ┤•┌ •├──┼──Optional AUDIO Out
   │││  ┤•│     │•├  │
   ││└──┤•│     │•├──┼──Speaker 8/16/32 Ohm 
   │└───┤•│     │•├──┼───┘        0.25W
   ┣────┤•└─────┘•├──┘
   │    ┤• SOMO  •├───┐
   │    ┤•  14D  •├─┐  VCC (3.3v nominal)
   │    └─────────┘ │   
   └─────┐  ┌──┻───┘
       470Ω      + 220uF/16V
        
--------------------------REVISION HISTORY--------------------------
 v1.1 - Updated mm/dd/yyyy to change ...bla, bla, bla
 
}}
CON

  CMD_PLAY_PAUSE        = $fffe
  CMD_STOP              = $ffff
  RESET_WRITE_DELAY_MS  = 5
  RESET_IDLE_DELAY_MS   = 300
  START_BIT_DELAY_MS    = 2
  STOP_BIT_DELAY_MS     = 2
  BIT_CLK_HIGH_DELAY_US = 100
  BIT_CLK_LOW_DELAY_US  = 100
  
VAR

  byte  BUSY
  byte  DATA
  byte  CLK
  byte  RESET

PUB Init(BUSYPin, DATAPin, CLKPin, RESETPin)

  BUSY  := BUSYPin  
  DATA  := DATAPin
  CLK   := CLKPin
  RESET := RESETPin 
  dira[BUSY]~                      ' BUSY is an input
  dira[DATA]~~                     ' DATA is an output
  outa[RESET] := 1                 ' set RESET high
  dira[CLK]~~                      ' CLK is an output
  outa[CLK] := 1                   ' set CLK high 
  dira[RESET]~~                    ' RESET is an output
  SetVolume(7)

PUB GetBusy | BusyState

  result := ina[BUSY]
  
PUB ResetDevice

  {{  RESET   5 mSec LOW / 300 mSec HIGH  }}
  outa[RESET] := 0
  waitcnt(clkfreq / 1000 * RESET_WRITE_DELAY_MS + cnt)
  outa[RESET] := 1
  waitcnt(clkfreq / 1000 * RESET_IDLE_DELAY_MS + cnt)
  
PUB SetVolume(LEVEL0TO7)

  Write($fff0+LEVEL0TO7)  ' 0 = low; 7 = high

PUB PlayAudioFile(NUMBER0TO511)

  Write(NUMBER0TO511)

PUB PlayPauseToggle

  Write(CMD_PLAY_PAUSE)  

PUB Stop

  Write(CMD_STOP)

PRI Write(Cmd16Bits)

  {        start    15   14   13      2    1    0   stop
      CLK   // 
     DATA  ─────── // ───────────
  }
   
  Cmd16Bits ><= 16  ' reverse the LS 16 bits so we send MSBit first
  StartBit
  repeat 15         ' send first 15 bits
    DataBit(Cmd16Bits)
    outa[CLK] := 0  ' prep for next bit
    waitcnt(clkfreq / 1_000_000 * BIT_CLK_LOW_DELAY_US + cnt)
    Cmd16Bits >>= 1
  DataBit(Cmd16Bits) ' send last bit but leave CLK high for STOP bit
  StopBit  

PRI StartBit

  {   CLK   2mSec LOW }

  outa[CLK] := 0
  waitcnt(clkfreq / 1_000 * START_BIT_DELAY_MS + cnt)

PRI DataBit(BitValue)

  {   CLK    100 uSec HIGH
      DATA  ─
  }

  outa[DATA] := BitValue
  outa[CLK]  := 1
  waitcnt(clkfreq / 1_000_000 * BIT_CLK_HIGH_DELAY_US + cnt) 

PRI StopBit

  {   CLK    2mSec HIGH }

  waitcnt(clkfreq / 1_000 * STOP_BIT_DELAY_MS + cnt)

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