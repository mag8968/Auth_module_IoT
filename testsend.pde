

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
char pr_str[20];


void setup()
{
  // init USB port
  USB.ON();
  //USB.println(F("Complete example (TX node)"));

  // set Waspmote identifier
  frame.setID("node_TX");

  // init XBee
  xbee802.ON();

}


void loop()
{ 


  int pr_value;
    {
    SensorEventv20.ON();
    delay(10);
    pr_value = SensorEventv20.readValue(SENS_SOCKET2, SENS_RESISTIVE);

   Utils.long2array(pr_value, pr_str);
    //Utils.float2String (pr_value, pr_str, 0);
    }
  //////////////////////////
  // 1. create frame
  //////////////////////////  

  // 1.1. create new frame
  frame.createFrame(ASCII);  

  // 1.2. add frame fields
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
    USB.println(pr_value);

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




