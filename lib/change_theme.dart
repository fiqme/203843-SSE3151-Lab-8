import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lab8_203843/theme.dart';

class NewTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Theme'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            TextButton(
                onPressed: () => _themeChanger.setTheme(ThemeData.dark()),
                child: Text('Dark Theme')),
            TextButton(
                onPressed: () => _themeChanger.setTheme(ThemeData.light()),
                child: Text('Light Theme')),
          ],
        ),
      ),
    );
  }
}
