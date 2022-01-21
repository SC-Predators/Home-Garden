import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test1/API.dart';
import 'main.dart';
import 'dart:convert';

class SignUP extends StatefulWidget{
  SignUP({Key? key, required this.title}) : super(key: key);
  String title;

  @override
  State<SignUP> createState() => _SignUP();
}

class _SignUP extends State<SignUP> {
  bool _autoChecked = true;
  bool _manualChecked = false;

  TextEditingController IDcontroll = TextEditingController();
  TextEditingController Passcontroll = TextEditingController();
  TextEditingController Plantcontroll = TextEditingController();
  TextEditingController Barcodecontroll = TextEditingController();
  TextEditingController illumcontroll = TextEditingController();
  TextEditingController humicontroll = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xffb2dfdb),
        title: Text("SMART HOME GARDEN",
          style: TextStyle(fontSize: 20, color: Colors.grey),),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[

            Container(
              child: Row(
                children: <Widget>[
                  Container(
                    width: 300,
                    margin: EdgeInsets.only(
                        left: 20, top: 20, right: 10, bottom: 10),
                    child: TextField(
                      controller: IDcontroll,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "User name",

                      ),
                    ),
                  ),

                  Container(
                    child: TextButton(
                      onPressed: () {
                        duplicateId(IDcontroll.text, context);
                      },
                      child: Text("중복확인",
                        style: TextStyle(fontSize: 15, color: Colors.grey),),
                    ),
                  ),
                ],
              ),
            ),


            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: TextField(
                controller: Passcontroll,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Password",
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: TextField(
                controller: Barcodecontroll,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Barcode",
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: TextField(
                controller: Plantcontroll,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Plant name",
                ),
              ),
            ),

            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Checkbox(
                        value: _autoChecked,
                        onChanged: (value) {
                          setState(() {
                            _manualChecked = !(value!);
                            _autoChecked = (value)!;
                          });
                        }
                    ),
                  ),
                  Text("AUTO"),

                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: Checkbox(
                              value: _manualChecked,
                              onChanged: (value) {
                                setState(() {
                                  _autoChecked = !(value!);
                                  _manualChecked = (value)!;
                                });
                              }
                          ),
                        ),


                        Text("MANUAL"),

                      ],
                    ),
                  ),
                ],
              ),
            ),
            if ( _manualChecked == true)

              Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: TextField(
                          controller: illumcontroll,
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
                          controller: humicontroll,
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
              color: Color(0xffFFF59D),
              padding: EdgeInsets.symmetric(vertical: 3, horizontal: 150),
              margin: EdgeInsets.symmetric(vertical: 10),
              child: TextButton(
                onPressed: (){
                  finishSignup (Barcodecontroll.text, IDcontroll.text, Passcontroll.text, Plantcontroll.text, _autoChecked, illumcontroll.text, humicontroll.text, context);
                },
                child: Text("FINISH",
                  style: TextStyle(fontSize: 20, color: Colors.grey),),
              ),
            ),
          ],
        ),
      ),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}


