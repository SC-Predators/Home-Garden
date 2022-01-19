#define TdsSensorPin A2
#define SCOUNT 30
#define VREF 5.0 
#define TRIG 8
#define ECHO 9

#include <ArduinoJson.h>



//공중에서 약 1000
//물속에서 280
float _MAX = 1000;
float _MIN = 280;

int analogBuffer[SCOUNT]; // store the analog value in the array, read from ADC
int analogBufferTemp[SCOUNT];
int analogBufferIndex = 0,copyIndex = 0;
float averageVoltage = 0,tdsValue = 0,temperature = 25;

int Relay = A5;




DynamicJsonDocument result_json(1024);

void setup() {
  Serial.begin(9600);
  pinMode(TdsSensorPin,INPUT);
  pinMode(TRIG, OUTPUT);
  pinMode(ECHO, INPUT);
  pinMode(Relay, OUTPUT);
  
  
}




// analog reference voltage(Volt) of the ADC
 // sum of sample point
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


 
void loop() {
  //초음파 센서
  long duration, distance;

  digitalWrite(TRIG, LOW);
  delayMicroseconds(2);
  digitalWrite(TRIG, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIG, LOW);
  
  duration = pulseIn (ECHO, HIGH);
  distance = duration * 17/1000;
  Serial.println(distance); 


  
  float Soil_moisture = analogRead(A0);// 토양 습도
  int soil = map(Soil_moisture,0,1023,0,7);
  int light = analogRead(A1); // 조도 값
  float ph = analogRead(A2); // 토양 산성도
  float humidity_rate = 100-((Soil_moisture-_MIN)/(_MAX-_MIN))*100;

  //센서 값 JSON 형식으로 출력
  result_json["soil_humid"] = soil; 
  result_json["light"] = light;
  result_json["ph"] = ph;
  result_json["depth"] = distance;

  
  
  serializeJson(result_json, Serial);      
  Serial.println("\n=================");
  delay(1000);

  if (soil > 4){
    // 물펌프 동작
    Serial.print("waterPump");
    digitalWrite(Relay, HIGH);
    delay(1000);
    digitalWrite(Relay, LOW);
  }
 
}
