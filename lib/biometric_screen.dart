import 'package:flutter/material.dart';
import 'package:lab8_203843/main.dart';
import 'package:lab8_203843/photo_album.dart';
import 'package:lab8_203843/pin_screen.dart';
import 'package:local_auth/local_auth.dart';

class Biometric extends StatelessWidget {
  final LocalAuthentication localAuth = LocalAuthentication();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () async {
          bool weCanCheckBiometrics = await localAuth.canCheckBiometrics;

          if(weCanCheckBiometrics){
            bool authenticated = await localAuth.authenticateWithBiometrics(localizedReason: "Authenticate to use the app");
            
            if(authenticated){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Album()));
            }
            
          }
          else
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Pin()));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Icon(
              Icons.fingerprint,
              size: 124.0,
            ),
            Text('Press the fingerprint icon to authenticate yourself')
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>MyApp())),
        child: Icon(Icons.home),
      ),
    );
  }
}