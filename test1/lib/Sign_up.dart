import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart';


class SignUP extends StatefulWidget{
  SignUP({Key? key}) : super(key: key);

  @override
  Sign_up createState() => Sign_up();

}

class Sign_up extends State<SignUP> {
  String name = "Smart Home Garden";
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
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xffF3E5F5),
        title: Text("Smart Home Garden", style: TextStyle(fontSize: 20, color: Colors.grey),),
      ),

      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
              child: TextField(
                controller: IDcontroll,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "User name",
                ),
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
                            _manualChecked = !value!;
                            _autoChecked = value!;
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
                                  _autoChecked = !value!;
                                  _manualChecked = value!;
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
              padding: EdgeInsets.symmetric(vertical: 3,horizontal: 150),
              margin: EdgeInsets.symmetric(vertical: 10),
              // child: ElevatedButton(
              //   child: Text("FINISH"),
              //   onPressed: () {
              //     Navigator.pop(context);
              //   },
              //
              // ),

              child: TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text("FINISH", style: TextStyle(fontSize: 20, color: Colors.grey),),
              ),
            ),
          ],
        ),
      ),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}


