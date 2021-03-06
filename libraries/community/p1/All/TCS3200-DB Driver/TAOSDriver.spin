{
TAOS sensor driver.

Pins:
S2 = PinE
S3 = PinF
out = PinC
LED = PinE



}
CON

taosS2 = 2        'Alter at will.
taosS3 = 3
LED = 1

'OUT (PinC) is connected to pin 0

PUB getRed(pin)
  return period(pin,1)

PUB getGreen(pin)
  return period(pin,3)

PUB getBlue(pin)
  return period(pin,2)

PUB getClear(pin)
  return period(pin,0)

PRI period(Pin, color) : Microseconds | cnt1, cnt2
  ''returns microseconds, has cnt1, cnt2 internal vars
  ''input is taos OUT pin connected on microcontroller Ppin
  ''color: 0 = clear, 1 = red, 2 = blue, 3 = green
  
  dira[Pin]~ 'this is the frequency uc input pin (OUT on the taos)
  dira[taosS2]~~ 'color selection set them to output
  dira[taosS3]~~
  dira[LED]~~
  outa[LED]~~ 'Have the LED on while this method is running
  if color == 0
    outa[taosS2]~~
    outa[taosS3]~
  if color == 1
    outa[taosS2]~
    outa[taosS3]~
  if color == 2
    outa[taosS2]~
    outa[taosS3]~~
  if color == 3
    outa[taosS2]~~
    outa[taosS3]~~
    
  waitpne(0, |< Pin, 0) ' Wait For Pin To Go HIGH
  cnt1 := cnt ' Store Current Counter Value
  waitpeq(0, |< Pin, 0) ' Wait For Pin To Go LOW
  cnt2 := cnt ' Store New Counter Value
  Microseconds := (||(cnt1 - cnt2) / (clkfreq / 1_000_000)) >> 1 ' Return Time in s
  outa[LED]~

DAT  
'Future code for color recognition

{PUB getColor(pin) : color

  if isNearTo(getRed(pin),redRed,10)
    return string("Red")
  else
    return string("Unrecognised")

PRI isNearTo(x,y,proximity) : a

  if x > (y-proximity) and x < (y+proximity)
    return true
  else
    return false}