import 'package:flutter/material.dart';
import 'package:lab8_203843/biometric_screen.dart';

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('Welcome Page'),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to Photo Album App!',
            ),
            Text(
              'Press the button below to proceed.',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>Biometric())),
        child: Icon(Icons.fingerprint),
      ),
    );
  }
}