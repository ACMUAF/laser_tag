/**
  Use IRsend library to modulate and send infrared blinks.
  The exact pin used for output depends on the Arduino used,
  but for the Mega the LED's power is on pin 9.

  Encoding is 'lawlor1':
    300 microsecond pulse is 0
    600 microsecond pulse is 1
  Both marks and spaces are used to encode data this way.

  Dr. Orion Lawlor, lawlor@alaska.edu, 2015-11-14 
  This file is Public Domain.
  The IRremote library is LGPL.
*/
#include "notIRremote.h"

// Send IR pulses to pin 9 (on mega, see IRremoteInt for other Arduinos)
IRsend irsend;

void setup()
{
  Serial.begin(57600);
  Serial.println("Sending IR pulses");
  pinMode(13,OUTPUT);
}

// Send this byte of data as IR blinks
void sendbits(IRsend &s,int v,int nbit) {
  for (int bit=0;bit<nbit;bit+=2) {
    if (v&1) s.mark(600); else s.mark(300);
    if (v&2) s.space(600); else s.space(300);
    v=v>>2; // down to next 2 bits
  }
}

int message=0xF0;
void loop() {
  
  Serial.println(message);
  digitalWrite(13,HIGH);
  int duty=125;
  irsend.enableIROut(38,duty); // run at this kHz and duty cycle
  sendbits(irsend,message,9);

  // Send RSSI blips?
/*
  for (int i = 0; i < 10; i++) {
    irsend.mark(300);
    irsend.space(300);
  }
  */
  digitalWrite(13,LOW);

  delay(100); // delay between each signal burst

  message++;
  if (message>0xff) message=0;
}

