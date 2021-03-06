import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test1/API.dart';
import 'package:test1/Sign_up.dart';
import 'HomePage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class modeData { // 현재 모드 정보를 담은 class
  String mode;
  String light;
  String humid;

  modeData(this.mode, this.humid, this.light);
}

class myMode extends StatefulWidget { // 현재 모드 및 모드관련 정보
  final String title; // 닉네임 이름
  String id;
  String presentMode;
  String presentHumid;
  String presentLight;

  myMode({Key? key, required this.title, required this.id, required this.presentMode, required this.presentHumid, required this.presentLight}) : super(key: key);

  bool _manualCheck = false;
  bool _autoCheck = false;

  @override
  State<myMode> createState() => _myMode();


}

class _myMode extends State<myMode> {
  TextEditingController mode_illum = TextEditingController();
  TextEditingController mode_humidity = TextEditingController();

  Object? mode = 'auto';


  void firstMode() { // 가져온 상태에 따라 checkBox 상태 표시
    if (widget.presentMode == 'A') widget._autoCheck = true;

    else widget._manualCheck = true;
  }


  @override
  Widget build(BuildContext context) {
    firstMode();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title, style: TextStyle(fontSize: 20, color: Colors.grey),),
        backgroundColor: Color(0xffb2dfdb),
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Checkbox(
                          value: widget._autoCheck,
                          onChanged: (value) {
                            setState(() {
                              widget._manualCheck = !(value!);
                              widget._autoCheck = (value)!;
                              if (widget._autoCheck == true)
                                widget.presentMode = 'A';
                              else
                                widget.presentMode = 'M';
                            });
                          }
                      ),
                    ),
                    Container(
                      child: Text("Auto Mode"),
                    ),
                  ],
                ),
              ),


              Container( // 자동/수동 체크박스
                  child: Row(

                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Checkbox(
                            value: widget._manualCheck,
                            onChanged: (value) {
                              setState(() {
                                widget._manualCheck = (value)!;
                                widget._autoCheck = !(value!);
                                if (widget._autoCheck == true)
                                  widget.presentMode = 'A';
                                else
                                  widget.presentMode = 'M';
                              });
                            }
                        ),
                      ),
                      Container(
                        child: Text("Manual Mode"),
                      )
                    ],
                  )
              ),

                if (widget._manualCheck == true)
                Container(
                    child: Column(
                      children: <Widget>[
                        Container( // 조도 텍스트 필드
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: TextField(
                            controller: mode_illum,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Illuminance",
                              hintText: widget.presentLight.toString(),
                            ),
                          ),
                        ),

                        Container( // 습도 텍스트필드
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: TextField(
                            controller: mode_humidity,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Humidity",
                              hintText: widget.presentHumid.toString(),
                            ),
                          ),
                        )
                      ],
                    )
                ),

              Container( // SAVE 버튼
                  margin: EdgeInsets.only(top: 40),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 130),
                  color: Color(0xffFFF59D),
                  child: TextButton(
                    child: Text("SAVE",
                      style: TextStyle(fontSize: 20, color: Colors.grey),),
                    onPressed: () {
                      // saveMode(widget.title, mode, illuminace, humidity, context)
                      print("before : ${widget.presentMode}");
                      if(widget._autoCheck == true) widget.presentMode = 'A';
                      else widget.presentMode = 'M';
                      print("after : ${widget.presentMode}");
                      finishMode(widget.id, widget.presentMode, mode_illum.text, mode_humidity.text, context);

                    },
                  )
              ),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


