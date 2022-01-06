import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test1/Sign_up.dart';
import 'HomePage.dart';


class myMode extends StatefulWidget {
  const myMode({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<myMode> createState() => _myMode();
}

class _myMode extends State<myMode> {
  bool _autoCheck = false;
  bool _manualCheck = false;

  TextEditingController mode_illum = TextEditingController();
  TextEditingController mode_humidity = TextEditingController();

  Object? mode = 'auto';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title, style: TextStyle(fontSize: 20, color: Colors.grey),),
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
                  // RadioListTile(
                  //   title: Text('auto'),
                  //   value: 'auto',
                  //   groupValue: mode,
                  //   onChanged: (value) {
                  //     setState(() {
                  //       mode = value;
                  //     });
                  //   },
                  // ),

                  Container(
                    child: Checkbox(
                        value: _autoCheck,
                        onChanged: (value) {
                          setState(() {
                              _manualCheck = !value!;
                              _autoCheck = value!;
                              print("_autoCheck:" + _autoCheck.toString() + "\nmanualcheck:" + _manualCheck.toString());

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
                  child: Text("SAVE", style: TextStyle(fontSize:25, color: Colors.grey),),
                  onPressed: () {},
                )
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
