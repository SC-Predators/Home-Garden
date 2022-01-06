import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test1/History.dart';
import 'package:test1/HomePage.dart';
import 'package:test1/Mode.dart';
import 'package:test1/Sign_up.dart';
import 'package:test1/control.dart';

class mainPage extends StatefulWidget {
  String title = 'tomato';
  mainPage({Key ? key}) : super(key: key);


  @override
  _mainPage createState() => _mainPage();
}

class _mainPage extends State<mainPage>{
  int _counter = 0;
  int _currentIndex = 0;
  final List<Widget> _children = [home(), myHistory(title: 'banana',), myMode(title: 'tomato',), myControl(title: 'potato')];

  void _onTap (int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  bool _isChecked1 = false;
  bool _isChecked2 = false;
  var humidity = 20;
  var illum = 20;
  var ph = 20;
  var depth = 20;
  var bottomSelect = 3;


  Widget build (BuildContext context) {
    return Scaffold(


      body: _children[_currentIndex],

        bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
      onTap: _onTap,
      currentIndex: _currentIndex,
      items: [
        new BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title : Text('home'),
        ),
        new BottomNavigationBarItem(
          icon: Icon(Icons.calendar_view_day),
          title : Text('history'),
        ),

        new BottomNavigationBarItem(
            icon: Icon(Icons.mode),
          title : Text('mode'),
        ),

        new BottomNavigationBarItem(
          icon: Icon(Icons.control_point),
          title : Text('controll'),
        ),
      ],
    ),
    );
  }


}