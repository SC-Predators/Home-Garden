import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test1/HomePage.dart';
import 'package:test1/main.dart';
import 'package:test1/mainPage.dart';
import 'historyHomepage.dart';

// 로그인 정보 확인 - 성공여부/바코드/닉네임
 void checkID (String id, String pass, BuildContext context) async {
   if (id == '' || pass == '' ){ // 사용자 입력 값이 없을 시 경고창 알림
     showDialog(
         context: context,
         barrierDismissible: false,
         builder: (BuildContext context) {
           return AlertDialog(
             title: Text('알림'),
             content: SingleChildScrollView(
                 child: ListBody(
                   children: [
                     Text('ID 및 Password를 입력해주세요.'),
                   ],
                 )
             ),
             actions: <Widget>[
               FlatButton(
                   onPressed: () {
                     Navigator.of(context).pop();
                   },
                   child: Text('ok')
               )
             ],
           );
         }
     );
   }

   else { // 사용자 입력 확인 시 정보 확인
     userID send;
     var data = {
       "clientID": id,
       "clientPW": pass
     };

     String url = "http://218.152.140.80:23628/app/users/log-in";
     var body = json.encode(data);

     http.Response res = await http.post(url,
         headers: {"Content-Type": "application/json"},
         body: body
     );

     if (res.statusCode == 200) { // API 통신 성공 시
       String responsebody = utf8.decode(res.bodyBytes);
       Map <String, dynamic> user = jsonDecode(responsebody);
       print(user);


       if (user['isSuccess'] == false) { // 로그인 정보 불일치
         showDialog(
             context: context,
             barrierDismissible: false,
             builder: (BuildContext context) {
               return AlertDialog(
                 title: Text('알림'),
                 content: SingleChildScrollView(
                     child: ListBody(
                       children: [
                         Text('로그인 정보가 불일치합니다.'),
                       ],
                     )
                 ),
                 actions: <Widget>[
                   FlatButton(
                       onPressed: () {
                         Navigator.of(context).pop();
                       },
                       child: Text('ok')
                   )
                 ],
               );
             }
         );
       }
       else { // 로그인 정보 일치
         userID send = userID(
             id, user['result']['userStatus'], user['result']['plantNickName']);
         showData(send, id, context); // 아이디에 따라 닉네임, 모드 정보 가져오기
       }
     }

     else { // 통신 실패 시
       showDialog(
           context: context,
           barrierDismissible: false,
           builder: (BuildContext context) {
             return AlertDialog(
               title: Text('알림'),
               content: SingleChildScrollView(
                   child: ListBody(
                     children: [
                       Text('연결이 불가능합니다.\n다시 시도해주세요'),
                     ],
                   )
               ),
               actions: <Widget>[
                 FlatButton(
                     onPressed: () {
                       Navigator.of(context).pop();
                     },
                     child: Text('ok')
                 )
               ],
             );
           }
       );
       print("fail");
     }
   }
}



//아이디 중복 확인 - 중복 여부
void duplicateId (String id, BuildContext context) async {
  if (id == '') { // 사용자 입력이 없을 시
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('알림'),
            content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text('ID를 입력해주세요'),
                  ],
                )
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('ok')
              )
            ],
          );
        }
    );
  }

  else { // 사용자 입력 정보 확인 시 중복 확인
    var data = {
      "clientID": id
    };

    String url = "http://218.152.140.80:23628/app/users/sign-up/checkID";
    var body = json.encode(data);

    http.Response res = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: body
    );

    if (res.statusCode == 200) { // 통신 성공
      String responsebody = utf8.decode(res.bodyBytes);
      Map <String, dynamic> user = jsonDecode(responsebody);
      print(user['result']);

      if (user['result'].toString() == 'true') {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('알림'),
                content: SingleChildScrollView(
                    child: ListBody(
                      children: [
                        Text('사용가능한 ID 입니다.'),
                      ],
                    )
                ),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('ok')
                  )
                ],
              );
            }
        );
        print("id 사용가능");
      }

      else {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('알림'),
                content: SingleChildScrollView(
                    child: ListBody(
                      children: [
                        Text('사용불가능한 ID 입니다.\n다시 입력해주세요'),
                      ],
                    )
                ),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('ok')
                  )
                ],
              );
            }
        );

        print("id 사용불가능");
      }
    }
  }
}

//화원가입 - 마지막으로 회원정보 DB에 전송하기
void finishSignup(String barcode, String id, String password, String nickname, bool mode, String illum, String humid, BuildContext context) async {
  if (barcode != '' && id != '' && password != '' && nickname != '') {
    var data;
    if (mode == true) {
      data = {
        "homegarden_barcode": barcode,
        "clientID": id,
        "password": password,
        "plantNickName": nickname,
        "mode": 'A'
      };
    }
    else {
      if (illum != '' && humid != '') {
        data = {
          "homegarden_barcode": barcode,
          "clientID": id,
          "password": password,
          "plantNickName": nickname,
          "mode": 'M',
          "desired_illuminance": illum,
          "desired_humidity": humid
        };
      }
    }
    print(data);

    String url = "http://218.152.140.80:23628/app/users/sign-up";
    var body = json.encode(data);

    http.Response res = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: body
    );

    if (res.statusCode == 200) {
      String responsebody = utf8.decode(res.bodyBytes);
      Map<String, dynamic> user = jsonDecode(responsebody);
      print(user);

      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('알림'),
              content: SingleChildScrollView(
                  child: ListBody(
                    children: [
                      Text('회원가입에 성공하였습니다.'),
                    ],
                  )
              ),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('ok')
                )
              ],
            );
          }
      );
    }
    // Navigator.push(context, MaterialPageRoute(builder: (_) => MyHomePage(title: 'SMART HOME GARDEN',)));
  }
  else {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('알림'),
            content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text('정보를 입력하세요'),
                  ],
                )
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('ok')
              )
            ],
          );
        }
    );
  }
}


// 홈화면 및 기록확인 화면 정보 가져오기 - 습도, 조도, 산성도, 높이, 이미지
void getData (String id, BuildContext context, String _title) async {
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
  }
  else {
    print("데이터가 없습니다.");
  }
}

//기록 가져오기 -- 날짜 시간 보내면 이미지, 온도, 조도, 산성도 가져오기

void getHistory (String title, String id, String month, String date, String hour, String minute , BuildContext context) async{
  print(month);
  var data = {
    "clientID": id,
    "month": month,
    "date": date,
    "hour": hour,
    "minute": minute
  };


  String url = 'http://218.152.140.80:23628/app/users/plant/history';
  var body = json.encode(data);

  http.Response res = await http.post(url,
      headers:  {"Content-Type": "application/json"},
      body: body
  );
  print(res.statusCode);
  if(res.statusCode == 200) {
    String responsebody = utf8.decode (res.bodyBytes);
    Map <String, dynamic> user = jsonDecode(responsebody);
    print(user);


    Navigator.push(context, MaterialPageRoute(builder: (_) => historyHome(title : title,
        ph:user['result']['ph'].toString(),
      humidity: user['result']['humidity'].toString(),
      illuminance: user['result']['illuminate'].toString(),
      depth: user['result']['waterDepth'].toString(),
      img: user['result']['imgURL'].toString(),)));
  }

  else {
    print("getHistory fail");
  }
}

//현재 상태 확인 용
void showData (userID sent, String id, BuildContext context) async{
  userID send;
  var data = {
    "clientID" : id,
  };

  String url = "http://218.152.140.80:23628/app/users/plant/present";
  var body = json.encode(data);


  http.Response res = await http.post(url,
      headers:  {"Content-Type": "application/json"},
      body: body
  );

  if(res.statusCode == 200) {
    String responsebody = utf8.decode (res.bodyBytes);
    Map <String, dynamic> user = jsonDecode(responsebody);
    print(user);
    if (user['result']['humidity'] == null || user['result']['illuminate'] == null ||
        user['result']['waterDepth'] == null || user['result']['ph'] == null ||
        user['result']['imgURL'] == null){
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('알림'),
              content: SingleChildScrollView(
                  child: ListBody(
                    children: [
                      Text('장치 상태가 기록되지 않았습니다.'),
                    ],
                  )
              ),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('ok')
                )
              ],
            );
          }
      );

    }
    else {
      Navigator.push(context, MaterialPageRoute(builder: (_) =>
          mainPage(userid: sent,
            humid: user['result']['humidity'],
            illum: user['result']['illuminate'],
            depth: user['result']['waterDepth'],
            ph: user['result']['ph'],
            img: user['result']['imgURL'],)));
    }
  }

  else {
    print("showData fail");
  }
}

//장치 제어 화면 - 사용자 지정 작동 정보 전송

void controlData (String id, bool led, bool water) async {
  String led_present = '';
  String water_present = '';

  if (led == true)
    led_present = 'on';
  else
    led_present = 'off';

  if (water == true)
    water_present = 'on';
  else
    water_present = 'off';

  var data = {
    "clientID": id,
    "light": led_present,
    "water": water_present
  };

  String url = "https://sxo1vvu9ai.execute-api.ap-northeast-2.amazonaws.com/app/users/plant/active";
  var body = json.encode(data);


  http.Response res = await http.post(url,
      headers: {"Content-Type": "application/json"},
      body: body
  );

  if (res.statusCode == 200) {
    String responsebody = utf8.decode(res.bodyBytes);
    Map <String, dynamic> user = jsonDecode(responsebody);
    print(user);
  }
  else
    print('controlData fail');
}

//모드 변경...모드 상태 가져오기
void finishMode (String id, String mode, String illum, String humid, BuildContext context) async {
  userID send;
  var data = {
    "clientID": id,
    "mode": mode,
    "illuminace": illum,
    "humidity": humid
  };

  String url = "http://218.152.140.80:23628/app/users/plant/mode";
  var body = json.encode(data);

  http.Response res = await http.patch(url,
      headers: {"Content-Type": "application/json"},
      body: body
  );

  if (res.statusCode == 200) {
    String responsebody = utf8.decode(res.bodyBytes);
    Map <String, dynamic> user = jsonDecode(responsebody);
    print(user);
    if (user['isSuccess'] == false) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('알림'),
              content: SingleChildScrollView(
                  child: ListBody(
                    children: [
                      Text('연결에 실패하였습니다\n다시 시도해주세요'),
                    ],
                  )
              ),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('ok')
                )
              ],
            );
          }
      );
    }

    else {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('알림'),
              content: SingleChildScrollView(
                  child: ListBody(
                    children: [
                      Text('정보를 변경하였습니다.'),
                    ],
                  )
              ),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('ok')
                )
              ],
            );
          }
      );
    }
  }
}
