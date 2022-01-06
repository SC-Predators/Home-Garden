import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:flutter/src/widgets/container.dart';
import 'History.dart';

class home extends StatelessWidget {
  String name = "My Potato";
  bool _isChecked1 = false;
  bool _isChecked2 = false;
  var humidity = 20;
  var illum = 20;
  var ph = 20;
  var depth = 20;
  var bottomSelect = 3;

  String url_picture = 'https://homegarden-images.s3.ap-northeast-2.amazonaws.com/jjh63360/2022-01-04+04-05-50.jpeg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(name, style: TextStyle(fontSize: 20, color: Colors.grey),),
        backgroundColor: Color(0xffF3E5F5),
      ),


      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(url_picture, width: 800,height: 200,),
            Container(

              child: Text("Humidity : ${humidity}"),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                  color: Color(0xffFFCCBC),
                  borderRadius: BorderRadius.circular(15.0)
              ),

            ),


            Container(
              child: Text("illuminate : ${illum}"),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                  color: Color(0xffFFCCBC),
                  borderRadius: BorderRadius.circular(15.0)
              ),
            ),

            Container(
              child: Text("Water Depth : ${depth}"),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                  color: Color(0xffFFCCBC),
                  borderRadius: BorderRadius.circular(15.0)
              ),
            ),

            Container(
              child: Text("Power of Hydrogen : ${ph}"),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                  color: Color(0xffFFCCBC),
                  borderRadius: BorderRadius.circular(15.0)
              ),
            ),
          ],
        ),
      ),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}


