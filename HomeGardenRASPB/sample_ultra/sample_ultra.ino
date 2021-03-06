int echo = 8;
int trig= 6;

void setup() {
  Serial.begin(9600);
  // trig를 출력모드로 설정, echo를 입력모드로 설정
  pinMode(trig, OUTPUT);
  pinMode(echo, INPUT);
}

void loop() {

  
  // 초음파를 보낸다. 다 보내면 echo가 HIGH 상태로 대기하게 된다.
    digitalWrite(trig, LOW);
    digitalWrite(echo, LOW);
    delayMicroseconds(2);
    digitalWrite(trig, HIGH);
    delayMicroseconds(10);
    digitalWrite(trig, LOW);

  
  // echoPin 이 HIGH를 유지한 시간을 저장 한다.
    unsigned long duration = pulseIn(echo, HIGH); 
  // HIGH 였을 때 시간(초음파가 보냈다가 다시 들어온 시간)을 가지고 거리를 계산 한다.
  float distance = ((float)(340 * duration) / 10000) / 2;  
  
  Serial.print(distance);
  Serial.println("cm");
  // 수정한 값을 출력
  delay(500);
}
