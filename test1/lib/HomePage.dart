import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:test1/API.dart';
import 'History.dart';
import 'main.dart';

class innerData {
  String humidity;
  String illum;
  String ph;
  String depth;

  innerData(this.humidity, this.illum, this.ph, this.depth);
}

class home extends StatefulWidget {

  const home({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<home> createState() => _home();
}


class _home extends State<home> {
  bool _isChecked1 = false;
  bool _isChecked2 = false;
  // var humidity = 20;
  // var illum = 20;
  // var ph = 20;
  // var depth = 20;
  // var bottomSelect = 3;

  String url_picture = 'https://homegarden-images.s3.ap-northeast-2.amazonaws.com/jjh63360/2022-01-04+04-05-50.jpeg';

  // innerData  in = getData(widget.title)

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
            Image.network(url_picture, width: 800,height: 200,),
            Container(

              child: Text("Humidity : " ),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                  color: Color(0xffFFCCBC),
                  borderRadius: BorderRadius.circular(15.0)
              ),

            ),


            Container(
              child: Text("illuminate : "),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                  color: Color(0xffFFCCBC),
                  borderRadius: BorderRadius.circular(15.0)
              ),
            ),

            Container(
              child: Text("Water Depth : " ),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                  color: Color(0xffFFCCBC),
                  borderRadius: BorderRadius.circular(15.0)
              ),
            ),

            Container(
              child: Text("Power of Hydrogen : " ),
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


