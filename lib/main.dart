import 'package:flutter/material.dart';
import 'package:roastcalc/home.dart';
import 'package:roastcalc/theme_config.dart';

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // remove debug manner
      debugShowCheckedModeBanner: false,

      // light theme fetched
      theme: themeConfig(.light),
      // dark theme fetched
      darkTheme: themeConfig(.dark),

      // home screen set
      home: Home(),
    );
  }
}
