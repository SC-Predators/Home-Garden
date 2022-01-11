//토양센서의 A0를 아두이노의 A1에 연결하기
//공중에서 약 1000
//물속에서 280

float _MAX = 1000;
float _MIN = 280;

void setup() {
  Serial.begin(9600);
}
 
void loop() {
  
  float Soil_moisture = analogRead(A1);  
  float humidity_rate = 100-((Soil_moisture-_MIN)/(_MAX-_MIN))*100;
  Serial.println(Soil_moisture);
  Serial.println(humidity_rate);        
  Serial.println("=================");
  delay(1000);
  
}
