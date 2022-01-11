import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test1/Sign_up.dart';
import 'HomePage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class myMode extends StatefulWidget {
  final String title; // 닉네임 이름
  myMode({Key? key, required this.title}) : super(key: key);

  @override
  State<myMode> createState() => _myMode();

}



class _myMode extends State<myMode> {
  TextEditingController mode_illum = TextEditingController();
  TextEditingController mode_humidity = TextEditingController();

  Object? mode = 'auto';

  bool _autoCheck = false;
  bool _manualCheck = true;


  void getMode(final String id) async {
    print("getMode");
    var data = {
      "clientID": id
    };
    String url = "http://218.152.140.80:23628/app/users/plant/mode";
    var body = json.encode(data);
    http.Response res = await http.post(url,
        body: body);
      print("///");

      String response = utf8.decode(res.bodyBytes);
      Map<String, dynamic> user = jsonDecode(response);

      print(user['isSuccess']);
      if (user['result']['mode'] == 'M') {
        print("today");
        _autoCheck = true;
        _manualCheck = false;
      }

  }


  @override
  Widget build(BuildContext context) {
    getMode(widget.title);
    return Scaffold(

      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title, style: TextStyle(fontSize: 20, color: Colors.grey),),
        backgroundColor: Color(0xffF3E5F5),
      ),

      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(

                    child: Checkbox(

                        value: _autoCheck,
                        onChanged: (value) {
                          setState(() {
                            _manualCheck = !value!;
                            _autoCheck = value!;
                            print("_autoCheck:" + _autoCheck.toString() +
                                "\nmanualcheck:" + _manualCheck.toString());
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
            Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Checkbox(
                          value: _manualCheck,
                          onChanged: (value) {
                            setState(() {
                              if (myMode == 'A') {
                                _autoCheck = true;
                                _manualCheck = false;
                              }
                              _manualCheck = value!;
                              _autoCheck = !value!;
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

            if (_manualCheck == true)

              Container(
                  child: Column(
                    children: <Widget>[
                      Container(
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

                      Container(
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
            Container(
                margin: EdgeInsets.only(top: 40),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 150),
                color: Color(0xffFFF59D),
                child: TextButton(
                  child: Text("SAVE",
                    style: TextStyle(fontSize: 25, color: Colors.grey),),
                  onPressed: () {},
                )
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
