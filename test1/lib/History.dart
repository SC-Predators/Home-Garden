import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test1/Sign_up.dart';
import 'HomePage.dart';


class myHistory extends StatefulWidget {
  const myHistory({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<myHistory> createState() => _MyHistory();
}

class _MyHistory extends State<myHistory> {

  int bottomSelect = 0;

  final List<int> Mitems = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  Object? M_select = 1;
  final List<int> Ditems = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    24,
    25,
    26,
    27,
    28,
    29,
    30,
    31
  ];


  Object? D_select = 1;
  Object? C_select = 1;
  final List<String> min_items = ['00', '30'];
  Object? m_select = '00';

  // final List<int> Ditems;
  // for (int i = 1; i >= 31; i++){
  // Ditems.add(i);
  // }


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
              alignment: Alignment(-0.6, 0.7),
              child: Text("Select Date", style: TextStyle(fontSize: 25),),
            ),

            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(20),
                    child: DropdownButton(
                      value: M_select,
                      items: Mitems.map(
                              (value) {
                            return DropdownMenuItem(
                                value: value,
                                child: Text(value.toString()));
                          }
                      ).toList(),

                      onChanged: (value) {
                        setState(() {
                          M_select = value;
                          print(M_select.toString() + "\n");
                        });
                      },

                    ),
                  ),

                  Container(
                    margin: EdgeInsets.all(20),
                    child: Text("month"),
                  ),


                  Container(
                    margin: EdgeInsets.all(20),
                    child: DropdownButton(
                      value: D_select,
                      items: Ditems.map(
                              (value) {
                            return DropdownMenuItem(
                                value: value,
                                child: Text(value.toString()));
                          }
                      ).toList(),


                      onChanged: (value) {
                        setState(() {
                          D_select = value;
                          print(D_select.toString() + "\n");
                        });
                      },
                    ),
                  ),

                  Container(
                      margin: EdgeInsets.all(20),
                      child: Text("date")
                  ),

                ],
              ),

            ),

            Container(
              alignment: Alignment(-0.6, 0.7),
              margin: EdgeInsets.only(top: 50),
              child: Text("Select Time", style: TextStyle(fontSize: 25),),
            ),

            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(

                    margin: EdgeInsets.all(20),
                    child: DropdownButton(
                      value: C_select,
                      items: Mitems.map(
                              (value) {
                            return DropdownMenuItem(
                                value: value,
                                child: Text(value.toString()));
                          }
                      ).toList(),

                      onChanged: (value) {
                        setState(() {
                          C_select = value;
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Text("clock"),
                  ),

                  Container(
                    margin: EdgeInsets.all(20),
                    child: DropdownButton(
                      value: m_select,
                      items: min_items.map(
                              (value) {
                            return DropdownMenuItem(
                                value: value,
                                child: Text(value));
                          }
                      ).toList(),

                      onChanged: (value) {
                        setState(() {
                          m_select = value;
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Text("minute"),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 150),
              margin: EdgeInsets.only(top: 50),
              color: Color(0xffFFF59D),
              // child: OutlinedButton(
              //   onPressed: () {
              //     Navigator.push(
              //         context, MaterialPageRoute(builder: (_) => SignUP()));
              //   },
              child: TextButton(
                onPressed: (){
                  setState(() {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => home()));
                  });
                },
                child: Text("OK", style: TextStyle(fontSize: 20, color: Colors.grey), ),
              ),
            ),
          ],
        ),
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
