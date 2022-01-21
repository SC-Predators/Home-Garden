import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test1/API.dart';
import 'package:test1/Sign_up.dart';
import 'HomePage.dart';


class myControl extends StatefulWidget {
  const myControl({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<myControl> createState() => _myControl();
}

class _myControl extends State<myControl> {
  bool _autoCheck = false;
  bool _manualCheck = false;

  TextEditingController mode_illum = TextEditingController();
  TextEditingController mode_humidity = TextEditingController();

  Object? mode = 'auto';
  bool _watercheck_on = false;
  bool _watercheck_off = true;
  bool _ledcheck_on = false;
  bool _ledcheck_off = true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title, style: TextStyle(fontSize: 20, color: Colors.grey),),
        backgroundColor: Color(0xffb2dfdb),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 100),
              child: Text("Give Water", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
            ),

            Container(
              margin: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Checkbox(value: _watercheck_on
                      , onChanged: (value){
                    setState(() {
                      _watercheck_off = !(value!);
                      _watercheck_on= (value)!;
                    });
                      }),
                  Container(
                    margin: EdgeInsets.only(right: 100),
                    child: Text('ON'),
                  ),

                  Checkbox(value: _watercheck_off
                      , onChanged: (value){
                        setState(() {
                          _watercheck_on = !(value!);
                          _watercheck_off= (value)!;
                        });
                      }),
                  Text("OFF"),

                ],
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: 50),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 100),
              child: Text("LED Trun ON/OFF", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
            ),


            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Checkbox(value: _ledcheck_on
                      , onChanged: (value){
                        setState(() {
                          _ledcheck_off = !(value!);
                          _ledcheck_on= value!;
                        });
                      }),
                  Container(
                    margin: EdgeInsets.only(right: 100),
                    child: Text('ON'),
                  ),


                  Checkbox(value: _ledcheck_off
                      , onChanged: (value){
                        setState(() {
                          _ledcheck_on = !(value!);
                          _ledcheck_off= value!;
                        });
                      }),
                  Text("OFF"),

                ],
              ),
            ),

            Container( // SAVE 버튼
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 125),
                color: Color(0xffFFF59D),
                child: TextButton(
                  child: Text("ACTUAL",
                    style: TextStyle(fontSize: 25, color: Colors.grey),),
                  onPressed: () {
                    saveControl(widget.title, widget.title, _ledcheck_on, _watercheck_on, context);
                  },
                )
            ),

          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
