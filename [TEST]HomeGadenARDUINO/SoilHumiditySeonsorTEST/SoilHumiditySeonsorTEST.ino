//토양센서의 A0를 아두이노의 A1에 연결하기
//공중에서 약 1000
//물속에서 280
#include <ArduinoJson.h>

float _MAX = 1000;
float _MIN = 280;
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
