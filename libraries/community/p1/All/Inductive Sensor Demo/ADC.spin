{{
*****************************************
* generic ADC driver v1.0               *
* Author: Beau Schwabe                  *
* Copyright (c) 2007 Parallax           *
* See end of file for terms of use.     *
*****************************************
}}
CON
    SDF = 6                     'sigma-delta feedback
    SDI = 7                     'sigma-delta input

PUB SigmaDelta (sample)
    cognew(@asm_entry, sample)   'launch assembly program in a COG

DAT
              org

asm_entry     mov       dira,#1<<SDF                    'make SDF pin an output

              movs      ctra,#SDI                       'POS W/FEEDBACK mode for CTRA
              movd      ctra,#SDF
              movi      ctra,#%01001_000
              mov       frqa,#1

              mov       asm_c,cnt                       'prepare for WAITCNT loop
              add       asm_c,asm_cycles

              
:loop         waitcnt   asm_c,asm_cycles                'wait for next CNT value
                                                        '(timing is determinant after WAITCNT)

              mov       asm_new,phsa                    'capture PHSA

              mov       asm_sample,asm_new              'compute sample from 'new' - 'old'
              sub       asm_sample,asm_old
              mov       asm_old,asm_new
              
              wrlong    asm_sample,par                  'write sample back to Spin variable "sample" 
                                                        '(WRLONG introduces timing indeterminancy here..)
                                                        '(..since it must sync to the HUB)
                                                        
              jmp       #:loop                          'wait for next sample

              

asm_cycles    long      $FFFF                           '(use $FFFF for 16-bit, $FFF for 12-bit, or $FF for 8-bit)

asm_c         res       1                               'uninitialized variables follow emitted data
asm_cnt       res       1
asm_new       res       1
asm_old       res       1
asm_sample    res       1
asm_temp      res       1

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