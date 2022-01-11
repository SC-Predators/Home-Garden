//토양센서의 A0를 아두이노의 A1에 연결하기

void setup() {
  Serial.begin(9600);
}
 
void loop() {
  
  int Soil_moisture = analogRead(A1);  
  Serial.println(Soil_moisture);        
  delay(100);
  
}
