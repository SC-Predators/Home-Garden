String income="Hello World!";
 
void setup() {
  Serial.begin(9600);//Baudrate을 9600으로 시리얼 통신.
}
 
void loop() {
  while(Serial.available()){   //시리얼에 읽을 값이 있으면
    income += (char)Serial.read(); //income안에 해당 내용 저장
  }
   
  if(income != 0){ //income에 내용이 있으면
    Serial.print(income);//시리얼에 해당 내용 전송
    income =""; //전송한 income내용 초기화
  }
  delay(10);
}


출처: https://hinco.tistory.com/4 [생각 정리소]String income="";
 
void setup() {
  Serial.begin(9600);//Baudrate을 9600으로 시리얼 통신.
}
 
void loop() {
  while(Serial.available()){   //시리얼에 읽을 값이 있으면
    income += (char)Serial.read(); //income안에 해당 내용 저장
  }
   
  if(income != 0){ //income에 내용이 있으면
    Serial.print(income);//시리얼에 해당 내용 전송
    income =""; //전송한 income내용 초기화
  }
  delay(10);
}
