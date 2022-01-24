import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test1/HomePage.dart';
import 'package:test1/Mode.dart';
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
         print(user['result']['desired_light'] is int);
         userID send = userID(
             id, user['result']['moode'], user['result']['desired_humidity'].toString(), user['result']['desired_light'].toString(), user['result']['plantNickName']);
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
        "mode": 'A',

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
// 시간있으면 수정하기 --- 제대로 작도하는거 xxxx
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
void getHistory (String title, String id, String month, String date, String hour, String minute , BuildContext context) async {

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
      headers: {"Content-Type": "application/json"},
      body: body
  );
  print(res.statusCode);
  if (res.statusCode == 200) {
    String responsebody = utf8.decode(res.bodyBytes);
    Map <String, dynamic> user = jsonDecode(responsebody);

    if (user['result']['humidity'] == null ||
        user['result']['illuminate'] == null ||
        user['result']['waterDepth'] == null || user['result']['ph'] == null ||
        user['result']['imgURL'] == null) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('알림'),
              content: SingleChildScrollView(
                  child: ListBody(
                    children: [
                      Text('기록된 장치 정보가 없습니다.'),
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
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => // 해당하는 날짜의 기록정보가 있는 화면으로 전환
          historyHome(title: title,
            ph: user['result']['ph'].toString(),
            humidity: user['result']['humidity'].toString(),
            illuminance: user['result']['illuminate'].toString(),
            depth: user['result']['waterDepth'].toString(),
            img: user['result']['imgURL'].toString(),)));
    }
  }

  else { // 연결 실패
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

    print("getHistory fail");
  }
}
//현재 상태 확인 용
void showData (userID sent, String id, BuildContext context) async {
  userID send;
  var data = {
    "clientID": id,
  };

  String url = "http://218.152.140.80:23628/app/users/plant/present";
  var body = json.encode(data);


  http.Response res = await http.post(url,
      headers: {"Content-Type": "application/json"},
      body: body
  );

  if (res.statusCode == 200) {
    String responsebody = utf8.decode(res.bodyBytes);
    Map <String, dynamic> user = jsonDecode(responsebody);
    print(user);
    // 현재 장치 정보가 없는 경우
    if (user['result']['humidity'] == null || user['result']['illuminate'] == null ||
        user['result']['waterDepth'] == null || user['result']['ph'] == null || user['result']['imgURL'] == null) {
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
            humid: user['result']['humidity'].toString(),
            illum: user['result']['illuminate'].toString(),
            depth: user['result']['waterDepth'].toString(),
            ph: user['result']['ph'].toString(),
            img: user['result']['imgURL'].toString(),)));
    }
  }

  else {
    print("showData fail");
  }
}


//모드 변경 -> 변경된 모드 저장하기

void finishMode (String id, String mode, String illum, String humid, BuildContext context) async {
  userID send;

  var data = {
    "clientID": id,
    "mode": mode,
    "illuminance": illum,
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
    if (user['result'] == "변경실패") {
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

//mode 페이지 작동시 새로 정보 가져오기
Future<modeData> getPresentMode (int index, String title, String id, BuildContext context) async {
  if (index == 2) { // bottom navigation 바에서 모드화면 입력 시에만 연결
    userID send;
    var data = {
      "clientID": id,
    };

    String url = "http://218.152.140.80:23628/app/users/plant/mode";
    var body = json.encode(data);

    http.Response res = await http.post(url,
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

      else { // 연결성공 시
        print("getPresentMode success");

        return modeData(
            user['result']['mode'], user['result']['humidity'].toString(), user['result']['illuminance'].toString());
      }
    };
  }
  print("getPresentMode fail");
  return modeData('C', '0', '0');
}

// 사용자 장치 제어 상태 전송하기
 void saveControl (String title, String nickName, bool led, bool water, BuildContext context) async {
   userID send;
   String _light, _water;

   if (led == true)
     _light = 'on';
   else
     _light = 'off';

   if (water == true)
     _water = 'on';
   else
     _water = 'off';

   var data = {
     "clientID": nickName,
     "light": _light,
     "water": _water
   };

   String url = "https://sxo1vvu9ai.execute-api.ap-northeast-2.amazonaws.com//app/users/plant/active";
   var body = json.encode(data);

   http.Response res = await http.post(url,
       headers: {"Content-Type": "application/json"},
       body: body
   );

   if (res.statusCode == 200) {}

   // 상태 변경 성공 시
   showDialog(
       context: context,
       barrierDismissible: false,
       builder: (BuildContext context) {
         return AlertDialog(
           title: Text('알림'),
           content: SingleChildScrollView(
               child: ListBody(
                 children: [
                   Text('상태가 변경되었습니다.'),
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