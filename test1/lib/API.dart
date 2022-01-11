import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test1/mainPage.dart';

// 로그인 정보 확인 - 성공여부/바코드/닉네임
void checkId (TextEditingController c1, TextEditingController c2, BuildContext context) async {
  var data = {
    "clientID": c1.text,
    "clientPW": c2.text
  };

  String url = "http://218.152.140.80:23628/app/users/log-in";
  var body = json.encode(data);

  http.Response res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body
  );


  if (res.statusCode == 200) {
    String responsebody = utf8.decode(res.bodyBytes);
    Map<String, dynamic> user = jsonDecode(responsebody);

    if (user['isSuccess'] == true) {
      userID senddata = userID(
          c1.text, user['result']['userStatus'], user['plantNickName']);
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => mainPage(userid: senddata)));
    }
    else
      print("FAIL");
  }
}


//아이디 중복 확인 - 중복 여부
void duplicateId (String id) async{
  var data = {
    "clientID" : id
  };

  String url = "http://218.152.140.80:23628/app/users/sign-up/checkID";
  var body = json.encode(data);

  http.Response res = await http.post(url,
  headers:  {"Content-Type": "application/json"},
  body: body
  );

  if(res.statusCode == 200) {
    String responsebody = utf8.decode (res.bodyBytes);
    Map <String, dynamic> user = jsonDecode(responsebody);
    print(user['result']);

      if(user['result'].toString() == 'true') {
        print("id 사용가능");
      }
      else {
        print("id 사용불가능");
      }
  }
}

//화원가입 - 마지막으로 회원정보 DB에 전송하기
void finishSignup (String barcode, String id, String password, String nickname, String mode, String illum, String humid) async {
  var data;
  if (mode == 'A') {
    data = {
      "homegarden_barcode": barcode,
      "clientID": id,
      "password": password,
      "plantNickName": nickname,
      "mode": mode
    };
  }
  else {
    data = {
      "homegarden_barcode": barcode,
      "clientID": id,
      "password": password,
      "plantNickName": nickname,
      "mode": mode,
      "desired_illuminance" : illum,
      "desired_humidity" : humid
    };
  }

  String url = "http://218.152.140.80:23628/app/users/sign-up/checkID";
  var body = json.encode(data);

  http.Response res = await http.post(url,
  headers:  {"Content-Type": "application/json"},
  body: body
  );

  if (res.statusCode == 200) {
    String responsebody = utf8.decode(res.bodyBytes);
    Map<String, dynamic> user = jsonDecode(responsebody);
    print(user['result']['userIdx']);

  }
}

// 홈화면 및 기록확인 화면 정보 가져오기 - 습도, 조도, 산성도, 높이, 이미지
Future<innerData> getData (String id) async {
  var data = {
    "clientID": id
  };
  String url = "http://218.152.140.80:23628/app/users/plant/present";
  var body = json.encode(data);
  http.Response res = await http.post(url,
      headers: {"Content-Type": "application/json"},
      body: body
  );

  if (res.statusCode == 200) {
    String reponsebody = utf8.decode(res.bodyBytes);
    Map<String, dynamic> user = jsonDecode(reponsebody);

    return innerData(user['result']['imgURL'], user['result']['humidity'],
        user['result']['illuminate'], user['result']['waterDepth'],
        user['result']['ph']);
  }
  else {
    print("데이터가 없습니다.");
    return innerData('img', 'humid', 'illuminate', 'waterDepth', 'ph');
  }
}

//