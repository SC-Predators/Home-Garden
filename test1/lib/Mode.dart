import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test1/API.dart';
import 'package:test1/Sign_up.dart';
import 'HomePage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class myMode extends StatefulWidget {
  final String title; // 닉네임 이름
  String presentMode;
  myMode({Key? key, required this.title, required this.presentMode}) : super(key: key);


  bool _manualCheck = false;
  bool _autoCheck = false;

  @override
  State<myMode> createState() => _myMode();


}

class _myMode extends State<myMode> {
  TextEditingController mode_illum = TextEditingController();
  TextEditingController mode_humidity = TextEditingController();

  Object? mode = 'auto';

  void fistMode() {
    if (widget.presentMode == 'A') {
      widget._autoCheck = true;
    }
    else {
      widget._manualCheck = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    fistMode();
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
                            ),
                          ),
                        )
                      ],
                    )
                ),
              Container( // SAVE 버튼
                  margin: EdgeInsets.only(top: 40),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 150),
                  color: Color(0xffFFF59D),
                  child: TextButton(
                    child: Text("SAVE",
                      style: TextStyle(fontSize: 20, color: Colors.grey),),
                    onPressed: () {
                      // saveMode(widget.title, mode, illuminace, humidity, context)

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


