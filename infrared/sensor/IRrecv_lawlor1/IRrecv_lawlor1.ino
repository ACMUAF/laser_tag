/* Dump TSOP382 / TSOP62 / Vishay IR Receiver data,
  as either 'lawlor1' encoding, or raw microsecond timings.

  Dr. Orion Lawlor, lawlor@alaska.edu, 2015-11-14 (Public Domain)
*/

// Pin connected to TSOP output line:
int tsop_pin=4;
int tsop_gnd=5;
int tsop_power=6;

void setup() {
  Serial.begin(57600);
  Serial.println("IR output pulses:");
  pinMode(tsop_pin,INPUT);
  
  // Add soft power, so you can plug the sensor in directly:
  pinMode(tsop_gnd,OUTPUT);
  digitalWrite(tsop_gnd,LOW);
  pinMode(tsop_power,OUTPUT);
  digitalWrite(tsop_power,HIGH);
}


enum {max_change=100};
unsigned int changes[max_change];
unsigned int last_lawlorval=0;

void loop() {

// Repeated digitalReads to count changes on pin:
  int last_v=1;
  long last_t=0;
  int c=0; // current change index
  unsigned int leash=0;
  while (leash<10000) {
    int v=digitalRead(tsop_pin);
    if (v!=last_v) { // ch-ch-changes
      long cur_t=micros();
      if (last_t!=0) {
        changes[c++]=cur_t-last_t;
        if (c>=max_change) break;
      }
      leash=0;
      last_t=cur_t;
      last_v=v;
    }
    leash++;
  }

// Decode and print stored changes:
  if (c>0) { // print all saved durations as raw values
    bool printraw=false;

    bool lawlordecode=true;
    unsigned int lawlorval=0, lawlormask=1;
    if (c<8) lawlordecode=false;
    for (int ci=0;ci<c;ci++) {
      if (changes[ci]<200) lawlordecode=false;
      else if (changes[ci]<450) { } // 0, do nothing
      else if (changes[ci]<900) { // 1, add mask to value
        lawlorval=lawlorval|lawlormask;
      }
      else lawlordecode=false;
      lawlormask=lawlormask<<1;
    }
    if (lawlordecode) {
      Serial.print(lawlorval,HEX);
      Serial.println();
      if (lawlorval!=(0xff&(last_lawlorval+1))) {
        Serial.println("NON-SEQUENTIAL VALUE");
      }
      last_lawlorval=lawlorval;
    } else { // bad decode
      printraw=true;
    }
    
    if (printraw) {
      Serial.println("Raw_us ");
      for (int ci=0;ci<c;ci++) {
        Serial.print(changes[ci]);
        if (ci&1)
          Serial.print(" ");
        else
          Serial.print("/"); // low time / high time
      }
      Serial.println();

      // Estimate for some IR remotes:
      for (int ci=0;ci<c;ci+=2) {
        if (changes[ci]>2800) Serial.print("S");
        else if (changes[ci]>changes[ci+1]) Serial.print("1");
        else  Serial.print("0");
      }
      Serial.println();
    }

    
  }
  else { // no changes detected
    Serial.println("-");
  }
}


