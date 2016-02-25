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


// Noiseproof encoding sequence:
enum {nseq=2};
int seq[nseq]={0x00,0xff};

int message_rx=-1;
void IRrecv_message(int msg_rx)
{
  digitalWrite(13,HIGH); // blink on incoming data
  message_rx=msg_rx;
}

int recv_bytes=0;
int recv_byte[nseq];

void loop() {  
  digitalWrite(13,LOW);

  message_rx=-1;
  IRrecv_poll<8>();
  if (message_rx==-1) {
     /* no data */
    if (IRrecv_bit_error_count) { // debug:
      Serial.print("B"); // bit error
      IRrecv_bit_error_count=0;
      recv_bytes=0;
    }
  }
  else {
    if (recv_bytes==0) {
      Serial.println(); 
    }
    Serial.print(" "); 
    Serial.print(message_rx,HEX);
    int m=message_rx^seq[recv_bytes];
    Serial.print("->"); 
    Serial.print(m,HEX);
    if (m&0x80) {
      recv_bytes=0; // bad byte--should have high bit clear
      Serial.print("(bad) "); 
    }
    else { // good data:
      Serial.print("(ok) "); 
      recv_byte[recv_bytes++]=m;
      if (recv_bytes>=2) {
        if (recv_byte[0]==recv_byte[1]) {
          Serial.print(" ---> HIT BY: "); 
          Serial.println(m,HEX);
        }
        recv_bytes=0;
      }
    }
  }
}

