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

class historyHome extends StatefulWidget {

  const historyHome({Key? key, required this.title, required this.ph, required this.humidity, required this.illuminance, required this.depth, required this.img})
      : super(key: key);
  // final innerData inner;
  final String title;
  final String humidity;
  final String illuminance;
  final String ph;
  final String depth;
  final String img;

  @override
  State<historyHome> createState() => _historyHome();
}


class _historyHome extends State<historyHome> {
  bool _isChecked1 = false;
  bool _isChecked2 = false;
  // var humidity = 20;
  // var illum = 20;
  // var ph = 20;
  // var depth = 20;
  // var bottomSelect = 3;



  // innerData  in = getData(widget.title)

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
            Image.network(widget.img, width: 800,height: 200,),
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
              child: Text("illuminate : ${widget.illuminance}"),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                  color: Color(0xffFFCCBC),
                  borderRadius: BorderRadius.circular(15.0)
              ),
            ),

            Container(
              child: Text("Water Depth : ${widget.depth}" ),
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


