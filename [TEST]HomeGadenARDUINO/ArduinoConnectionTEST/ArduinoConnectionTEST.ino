// Include Libraries
#include "Arduino.h"
#include "NewPing.h"
#include "LDR.h"
#include "SoilMoisture.h"


// Pin Definitions
#define HCSR04_PIN_TRIG  3
#define HCSR04_PIN_ECHO 2
#define LDR_PIN_SIG A0
#define SOILMOISTURE_5V_PIN_SIG A1



// Global variables and defines
#define THRESHOLD_ldr   100
int ldrAverageLight;
// object initialization
NewPing hcsr04(HCSR04_PIN_TRIG,HCSR04_PIN_ECHO);
LDR ldr(LDR_PIN_SIG);
SoilMoisture soilMoisture_5v(SOILMOISTURE_5V_PIN_SIG);


// define vars for testing menu
const int timeout = 10000;       //define timeout of 10 sec
char menuOption = 0;
long time0;

// Setup the essentials for your circuit to work. It runs first every time your circuit is powered with electricity.
void setup() 
{
    // Setup Serial which is useful for debugging
    // Use the Serial Monitor to view printed messages
    Serial.begin(9600);
    while (!Serial) ; // wait for serial port to connect. Needed for native USB
    Serial.println("start");
    
    ldrAverageLight = ldr.readAverage();
    menuOption = menu();
    
}

// Main logic of your circuit. It defines the interaction between the components you selected. After setup, it runs over and over again, in an eternal loop.
void loop() 
{
    
    
    if(menuOption == '1') {
    // Ultrasonic Sensor - HC-SR04 - Test Code
    // Read distance measurment from UltraSonic sensor           
    int hcsr04Dist = hcsr04.ping_cm();
    delay(10);
    Serial.print(F("Distance: ")); Serial.print(hcsr04Dist); Serial.println(F("[cm]"));

    }
    else if(menuOption == '2') {
    // LDR (Mini Photocell) - Test Code
    // Get current light reading, substract the ambient value to detect light changes
    int ldrSample = ldr.read();
    int ldrDiff = abs(ldrAverageLight - ldrSample);
    Serial.print(F("Light Diff: ")); Serial.println(ldrDiff);

    }
    else if(menuOption == '3') {
    // Soil Moisture Sensor - Test Code
    int soilMoisture_5vVal = soilMoisture_5v.read();
    Serial.print(F("Val: ")); Serial.println(soilMoisture_5vVal);

    }
    
    if (millis() - time0 > timeout)
    {
        menuOption = menu();
    }
    
}



// Menu function for selecting the components to be tested
// Follow serial monitor for instrcutions
char menu()
{

    Serial.println(F("\nWhich component would you like to test?"));
    Serial.println(F("(1) Ultrasonic Sensor - HC-SR04"));
    Serial.println(F("(2) LDR (Mini Photocell)"));
    Serial.println(F("(3) Soil Moisture Sensor"));
    Serial.println(F("(menu) send anything else or press on board reset button\n"));
    while (!Serial.available());

    // Read data from serial monitor if received
    while (Serial.available()) 
    {
        char c = Serial.read();
        if (isAlphaNumeric(c)) 
        {   
            
            if(c == '1') 
          Serial.println(F("Now Testing Ultrasonic Sensor - HC-SR04"));
        else if(c == '2') 
          Serial.println(F("Now Testing LDR (Mini Photocell)"));
        else if(c == '3') 
          Serial.println(F("Now Testing Soil Moisture Sensor"));
            else
            {
                Serial.println(F("illegal input!"));
                return 0;
            }
            time0 = millis();
            return c;
        }
    }
}
