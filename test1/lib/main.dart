import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test1/API.dart';
import 'package:test1/Sign_up.dart';
import 'API.dart';
import 'package:test1/mainPage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'HomePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMART HOME GARDEN',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),

      home: const MyHomePage(title: 'SMART HOME GARDEN'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController cont = TextEditingController();
  TextEditingController cont2 = TextEditingController();

  String id = '';
  String pass = '';


  String username = '';
  String sentdata = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title, style: TextStyle(fontSize: 20, color: Colors.grey),),
        backgroundColor: Color(0xffb2dfdb),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: TextField(
                  controller: cont,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'user name',
                  ),
                )
            ),

            Container(
                margin: EdgeInsets.only(
                    left: 20, right: 20, bottom: 40, top: 10),
                child: TextField(
                  controller: cont2,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'password',
                  ),
                )
            ),


            Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 100),
              margin: EdgeInsets.symmetric(vertical: 10),
              color: Color(0xffE6EE9C),
              child: TextButton(
                onPressed: (){
                  userID send;
                  checkID(cont.text, cont2.text, context);
                },
                  child: Text("LOGIN", style: TextStyle(fontSize: 25, color: Colors.grey),),
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 90),
              margin: EdgeInsets.symmetric(vertical: 10),
              color: Color(0xffE6EE9C),
              child: Container(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => SignUP(title: 'smart home garden',)));
                  },
                  child: Text("SIGN UP",
                    style: TextStyle(fontSize: 25, color: Colors.grey),),
                ),
                ),
              ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}