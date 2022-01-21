import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test1/API.dart';
import 'package:test1/History.dart';
import 'package:test1/HomePage.dart';
import 'package:test1/Mode.dart';
import 'package:test1/Sign_up.dart';
import 'package:test1/control.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class userID {
  String userId= '';
  String userMode = '';
  String nickname = '';

  userID(this.userId, this.userMode, this.nickname);
}

// class innerData {
//   String img;
//   String humid;
//   String illuminate;
//   String waterDepth;
//   String ph;
//
//   innerData(this.img, this.humid, this.illuminate, this.waterDepth, this.ph);
//
// }


class mainPage extends StatefulWidget {

  final userID userid;
  mainPage({required this.userid, required this.humid, required this.illum, required this.depth, required this.ph, required this.img});
  final int humid;
  final int illum;
  final int depth;
  final int ph;
  final String img;

  @override
  State<mainPage> createState() => _mainPage();
}

class _mainPage extends State<mainPage>{

  int _counter = 0;
  int _currentIndex = 0;

  bool _isChecked1 = false;
  bool _isChecked2 = false;
  String humidity = '0';
  String illum = '0';
  String ph = '0';
  String depth = '0';
  String bottomSelect = '0';
  String mode = 'C';

  void _onTap (int index) async {
    setState(() {
      _currentIndex = index;
      print(_currentIndex);
    });
  }


  Widget build (BuildContext context) {
    print("사용자 모드 : ");
    print(widget.userid.userMode);

    final List<Widget> _children = [
      home(id: widget.userid.userId, title: widget.userid.nickname, humidity: widget.humid, illuminace: widget.illum, waterDepth: widget.depth, ph: widget.ph,img: widget.img,),
      myHistory(title: widget.userid.nickname, userid: widget.userid.userId,), // 오늘 날짜 전달?
      myMode(title: widget.userid.nickname, presentMode: widget.userid.userMode,), // 현재 모드 전달
      myControl(title: widget.userid.nickname)]; // 현재 장치 모드 전달
    return Scaffold(
      body: _children[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Color(0xff80cbc4),
        type: BottomNavigationBarType.fixed,
        onTap: _onTap,
        currentIndex: _currentIndex,
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('home'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.calendar_view_day),
            title: Text('history'),
          ),

          new BottomNavigationBarItem(
            icon: Icon(Icons.mode),
            title: Text('mode'),
          ),

          new BottomNavigationBarItem(
            icon: Icon(Icons.control_point),
            title: Text('controll'),
          ),
        ],
      ),
    );
  }
}