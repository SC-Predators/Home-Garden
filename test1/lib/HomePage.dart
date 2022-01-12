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

  const home({Key? key, required this.title,
    required this.img,
    required this.humidity,
    required this.illuminace,
    required this.waterDepth,
    required this.ph}) : super(key: key);


  // final innerData inner;
  final String title;
  final String img;
  final int humidity;
  final int illuminace;
  final int waterDepth;
  final int ph;

  @override
  State<home> createState() => _home();
}


class _home extends State<home> {
  bool _isChecked1 = false;
  bool _isChecked2 = false;



  // innerData  in = getData(widget.title)

  @override
  Widget build(BuildContext context) {

    String url_picture = widget.img;
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
            Image.network(url_picture, width: 800,height: 200,),
            Container(

              child: Text("Humidity : ${widget.humidity}" ),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                  color: Color(0xffFFCCBC),
                  borderRadius: BorderRadius.circular(15.0)
              ),

            ),


            Container(
              child: Text("illuminate : ${widget.illuminace}"),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                  color: Color(0xffFFCCBC),
                  borderRadius: BorderRadius.circular(15.0)
              ),
            ),

            Container(
              child: Text("Water Depth : ${widget.waterDepth}" ),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                  color: Color(0xffFFCCBC),
                  borderRadius: BorderRadius.circular(15.0)
              ),
            ),

            Container(
              child: Text("Power of Hydrogen : ${widget.ph}" ),
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


