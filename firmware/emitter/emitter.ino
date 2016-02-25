/**
  Emit serial data as IR pulses.

  Dr. Orion Lawlor, lawlor@alaska.edu, 2016-02-02
  This file is Public Domain.
*/
#include "IRserial.h"


// Shooter ID:
int hit_code=0x5A;

// Pin where the trigger (shorted to ground) is connected:
int trigger_pin=4;

// Noiseproof message encoding sequence:
enum {nseq=2};
int seq[nseq]={0x00,0xff};


void setup()
{
	Serial.begin(57600);
	Serial.println("Sending IR pulses");
	pinMode(13,OUTPUT);

	IRsend_setup();  
  pinMode(trigger_pin,INPUT_PULLUP);
}


void loop() {
  bool shoot=false;
  if (digitalRead(trigger_pin)==0) shoot=true;
  if (shoot) {
    digitalWrite(13,HIGH);
    for (int repeat=0;repeat<10;repeat++) {
      for (int s=0;s<nseq;s++)
      	IRsend_message<8>(hit_code^seq[s]);
      delay(5); // delay between each signal burst
    }
    Serial.print("Shooting as ");
    Serial.println(hit_code,HEX);
  }
  digitalWrite(13,LOW);
	
	delay(10); // delay between each button check
}

