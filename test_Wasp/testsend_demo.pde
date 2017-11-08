

#include <WaspXBee802.h>
#include <WaspFrame.h>
#include <WaspSensorEvent_v20.h>

// Destination MAC address
//////////////////////////////////////////
char RX_ADDRESS[] = "0013A20040F5BBFD";
//////////////////////////////////////////

// define variable
uint8_t error;

//string pressure value
char pr_str[20]="AAAA";
char Send_ID[20]="node_1";
char Receive_ID[20]="node_2";


void setup()
{
  // init USB port
   USB.ON();  // init USB port
  PWR.setSensorPower(SENS_3V3,SENS_ON);
  delay(50);
  PWR.setSensorPower(SENS_5V,SENS_ON);
  delay(50);
  
  USB.println(F("Node Example"));

  // set Waspmote identifier
  frame.setID("node_1");


  // init XBee
  xbee802.ON();

}


void loop()
{ 

  //////////////////////////
  // 1. create frame
  //////////////////////////  

  // 1.1. create new frame
  frame.createFrame(ASCII);  

  // 1.2. add frame fields
  frame.addSensor(SENSOR_STR, Send_ID);
  frame.addSensor(SENSOR_STR, Receive_ID);
  frame.addSensor(SENSOR_STR, pr_str);
  
  
  //USB.println(F("\n1. Created frame to be sent"));
  frame.showFrame();

  //////////////////////////
  // 2. send packet
  //////////////////////////  

  // send XBee packet
  error = xbee802.send( RX_ADDRESS, frame.buffer, frame.length );   
  
  //USB.println(F("\n2. Send a packet to the RX node: "));
  
  // check TX flag
  if( error == 0 )
  {
    USB.println(F("send ok"));
    USB.println(pr_str);

    // blink green LED
    Utils.blinkGreenLED();    
  }
  else 
  {
    USB.println(F("send error"));
    
    // blink red LED
    Utils.blinkRedLED();  
  }
  
  // wait for 5 seconds
  USB.println(F("\n----------------------------------"));
  delay(5000);

}




