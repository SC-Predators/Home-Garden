import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test1/Sign_up.dart';
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

  String username = '';

  @override
  Widget build(BuildContext context) {
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
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: TextField(
                  controller: cont,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'user name',
                  ),
                  onChanged: (text) {
                    username = text;
                  },
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
                  onChanged: (text) {
                    username = text;
                  },
                )
            ),

            // OutlinedButton(
            //     onPressed: (){
            //       title : 'my tomato';
            //       Navigator.push(context, MaterialPageRoute(builder: (_)  => mainPage()));
            //
            //     },
            //     child: Padding(
            //       padding: EdgeInsets.symmetric(vertical: 20, horizontal: 28),
            //       child:Text("LOGIN"),
            //     ),
            //
            // ),

            Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 100),
              margin: EdgeInsets.symmetric(vertical: 10),
              color: Color(0xffE6EE9C),
              child: TextButton(
                onPressed: () {
                // async {
                //
                //   var data = {
                //     "clientID" : "jjh63360",
                //     "clientPW" : "123@"
                //   };
                //   String url = "http://218.152.140.80:23628/app/users/log-in";
                //
                //   var body = json.encode(data);
                //   http.Response res = await http.post(url,
                //     headers: {"Content-Type" : "application/json"},
                //     body: body
                //   );
                //   print(res.statusCode);
                //   print(res.body);

                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => mainPage()));
                },
                child: Text(
                  "LOGIN", style: TextStyle(fontSize: 25, color: Colors.grey),),
                // style: TextButton.styleFrom(
                //   backgroundColor: Colors.amberAccent,
                // ),

              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 90),
              margin: EdgeInsets.symmetric(vertical: 10),
              color: Color(0xffE6EE9C),
              child: Container(
                // child:OutlinedButton(
                //   onPressed: (){
                //     Navigator.push(context, MaterialPageRoute(builder: (_) => SignUP()));
                //   },
                //   child: Padding(
                //     padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                //     child:Text("SIGN UP"),
                //   ),
                // ),

                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => SignUP()));
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
