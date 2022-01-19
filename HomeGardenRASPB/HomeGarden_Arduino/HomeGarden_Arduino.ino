#define TdsSensorPin A2
#define SCOUNT 30
#define VREF 5.0 
#define TRIG 8
#define ECHO 9
#define Relay 12
#include <ArduinoJson.h>



//공중에서 약 1000
//물속에서 280
float _MAX = 1000;
float _MIN = 280;
String relay_state;
char ch;
  

DynamicJsonDocument result_json(1024);

void setup() {
  Serial.begin(9600);
  pinMode(TdsSensorPin,INPUT);
  pinMode(TRIG, OUTPUT);
  pinMode(ECHO, INPUT);
  pinMode(Relay, OUTPUT);
}

 
void loop() {
  relay_state = digitalRead(Relay);
  
  //초음파 센서
  long duration, distance;

  digitalWrite(TRIG, LOW);
  delayMicroseconds(2);
  digitalWrite(TRIG, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIG, LOW);
  
  duration = pulseIn (ECHO, HIGH);
  distance = duration * 17/1000;


  
  float Soil_moisture = analogRead(A0);// 토양 습도
  int soil = map(Soil_moisture,0,1023,0,7);
  int light = analogRead(A1); // 조도 값
  float ph = analogRead(A2); // 토양 산성도
  float humidity_rate = 100-((Soil_moisture-_MIN)/(_MAX-_MIN))*100;

  //센서 값 JSON 형식으로 출력
  result_json["soil_humid"] = humidity_rate; 
  result_json["light"] = light;
  result_json["ph"] = ph;
  result_json["depth"] = distance;

  if(Serial.available()){
    ch = Serial.read();
    Serial.print("ch: " + ch);
  }


  if (ch=='w'){
    // 물펌프 동작
    //Serial.print("waterPumpOn");
    digitalWrite(Relay, HIGH);
  }
  else if(ch=='s') {
    //Serial.print("waterPumpOff");
    digitalWrite(Relay, LOW);
  }
  
  result_json["pumpState"] = digitalRead(Relay);

  serializeJson(result_json, Serial);      
  Serial.println("\n=================");
  delay(1000);

  
  
}
