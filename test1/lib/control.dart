import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        backgroundColor: Color(0xffF3E5F5),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 100),
              child: Text("Give Water"),
            ),

            Container(
              margin: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Checkbox(value: _watercheck_on
                      , onChanged: (value){
                    setState(() {
                      _watercheck_off = !value!;
                      _watercheck_on= value!;
                    });
                      }),
                  Container(
                    margin: EdgeInsets.only(right: 100),
                    child: Text('ON'),
                  ),

                  Checkbox(value: _watercheck_off
                      , onChanged: (value){
                        setState(() {
                          _watercheck_on = !value!;
                          _watercheck_off= value!;
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
              child: Text("LED Trun ON/OFF", style: TextStyle(fontSize: 20, color: Colors.redAccent),),
            ),


            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Checkbox(value: _ledcheck_on
                      , onChanged: (value){
                        setState(() {
                          _ledcheck_off = !value!;
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
                          _ledcheck_on = !value!;
                          _ledcheck_off= value!;
                        });
                      }),
                  Text("OFF"),

                ],
              ),
            ),

          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
