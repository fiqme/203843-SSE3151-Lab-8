import 'package:flutter/material.dart';
import 'package:lab8_203843/main.dart';
import 'package:lab8_203843/photo_album.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class Pin extends StatelessWidget {

  final String actualPasscode = '1234';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pin Code',
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Please enter passcode',
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(height: 30.0,),
                PinCodeTextField(
                  appContext: context,
                  length: 4,
                  onChanged: (value){
                    print(value);
                  },
                  pinTheme: PinTheme(
                    inactiveColor: Colors.black,
                    activeColor: Colors.lightBlue,
                  ),
                  onCompleted: (value){
                    if(value == actualPasscode){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Album()));
                    }
                    else{
                      print('Invalid pin');
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>MyApp())),
        child: Icon(Icons.home),
      ),
      ),
    );
  }
}