#define TdsSensorPin A1
#define SCOUNT 30
#define VREF 5.0 

#include <ArduinoJson.h>



//공중에서 약 1000
//물속에서 280
float _MAX = 1000;
float _MIN = 280;

int analogBuffer[SCOUNT]; // store the analog value in the array, read from ADC
int analogBufferTemp[SCOUNT];
int analogBufferIndex = 0,copyIndex = 0;
float averageVoltage = 0,tdsValue = 0,temperature = 25;

DynamicJsonDocument result_json(1024);

void setup() {
  Serial.begin(9600);
}
 
void loop() {
  
  float Soil_moisture = analogRead(A1);  
  int light = analogRead(A0);
  float humidity_rate = 100-((Soil_moisture-_MIN)/(_MAX-_MIN))*100;
  
  result_json["soil_humid"] = humidity_rate;
  result_json["light"] = light;
  
  serializeJson(result_json, Serial);      
  Serial.println("\n=================");
  delay(1000);
  
}
































// analog reference voltage(Volt) of the ADC
 // sum of sample point
void setup()
{
Serial.begin(115200);
pinMode(TdsSensorPin,INPUT);
}
void loop()
{
static unsigned long analogSampleTimepoint = millis();
if(millis()-analogSampleTimepoint > 40U) //every 40 milliseconds,read the analog value from the ADC
{
analogSampleTimepoint = millis();
analogBuffer[analogBufferIndex] = analogRead(TdsSensorPin); //read the analog value and store into the buffer
analogBufferIndex++;
if(analogBufferIndex == SCOUNT)
analogBufferIndex = 0;
}
static unsigned long printTimepoint = millis();
if(millis()-printTimepoint > 800U)
{
printTimepoint = millis();
for(copyIndex=0;copyIndex<SCOUNT;copyIndex++)
analogBufferTemp[copyIndex]= analogBuffer[copyIndex];
averageVoltage = getMedianNum(analogBufferTemp,SCOUNT) * (float)VREF/ 1024.0; // read the analog value more stable by the median filtering algorithm, and convert to voltage value
float compensationCoefficient=1.0+0.02*(temperature-25.0); //temperature compensation formula: fFinalResult(25^C) = fFinalResult(current)/(1.0+0.02*(fTP-25.0));
float compensationVolatge=averageVoltage/compensationCoefficient; //temperature compensation
tdsValue=(133.42*compensationVolatge*compensationVolatge*compensationVolatge - 255.86*compensationVolatge*compensationVolatge + 857.39*compensationVolatge)*0.5; //convert voltage value to tds value
Serial.print("voltage:");
Serial.print(averageVoltage,2);
Serial.print("V ");
Serial.print("TDS Value:");
Serial.print(tdsValue,0);
Serial.println("ppm");
}
}
int getMedianNum(int bArray[], int iFilterLen)
{
int bTab[iFilterLen];
for (byte i = 0; i<iFilterLen; i++)
bTab[i] = bArray[i];
int i, j, bTemp;
for (j = 0; j < iFilterLen - 1; j++)
{
for (i = 0; i < iFilterLen - j - 1; i++)
{
if (bTab[i] > bTab[i + 1])
{
bTemp = bTab[i];
bTab[i] = bTab[i + 1];
bTab[i + 1] = bTemp;
}
}
}
if ((iFilterLen & 1) > 0)
bTemp = bTab[(iFilterLen - 1) / 2];
else
bTemp = (bTab[iFilterLen / 2] + bTab[iFilterLen / 2 - 1]) / 2;
return bTemp;
}
