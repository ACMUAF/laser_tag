/**
  Receive serial-formatted IR pulses.

  Dr. Orion Lawlor, lawlor@alaska.edu, 2016-02-02
  This file is Public Domain.
*/
#include "IRserial.h"


void setup()
{
  Serial.begin(57600);
  Serial.println("Reading IR pulses");
  pinMode(13,OUTPUT);

  IRrecv_setup();
  IRsend_setup();  
}


int message=0x5A;
int message_rx=-1;
void IRrecv_message(int msg_rx)
{
  digitalWrite(13,HIGH); // blink on incoming data
  message_rx=msg_rx;
}

int test_good=0;
int test_bad=0;
int test_count=-1;

void loop() {  
    if (test_count++>=4000) {
      Serial.println();
      Serial.println();
      Serial.print("Experiment results at ");
      Serial.print(IRrecv_bit_time);
      Serial.print(" us/bit: ");
      Serial.print(test_bad*1000.0/(test_good+test_bad));
      Serial.print(" bit errors/kbit ");
      Serial.print(test_good*100.0/(test_good+test_bad));
      Serial.print(" %OK ");
      Serial.print(test_good);
      Serial.print(" good ");
      Serial.print(test_bad);
      Serial.println(" bad ");
      Serial.println();
      test_count=test_good=test_bad=0;
    }

  digitalWrite(13,LOW);

  message_rx=-1;
  IRrecv_poll<8>();
  if (message_rx==-1) {
     /* no data--do nothing */
    if (IRrecv_bit_error_count) { // debug:
      Serial.println();
      Serial.print(" TX: ");
      Serial.print(message,HEX);
      Serial.print(" Detected bit error: ");
      Serial.print(IRrecv_bit_error_count);
      Serial.print(" at bit ");
      Serial.print(IRrecv_bit_error_number);
      IRrecv_dump();
      IRrecv_bit_error_count=0;
      test_bad++;
    }
  }
  else {
    if (message_rx==(0xff&(message+1))) {
      Serial.print("."); // OK
      if (message==0) Serial.println();
      test_good++;
      digitalWrite(13,HIGH); // light LED on good data
    }
    else { // silently delivered wrong value
      Serial.print("X"); // bad
      test_bad++;
    }
    message=message_rx;
 }


  delay(5); // delay between each poll for data
}

