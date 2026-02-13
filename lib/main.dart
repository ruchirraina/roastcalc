import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:roastcalc/services/history_storage.dart';
import 'package:roastcalc/home.dart';
import 'package:roastcalc/services/theme_config.dart';

void main() async {
  // ensure binding initialisation so we can make use of SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();

  // get SharedPreferences instance
  await HistoryStorage.init();

  // allow only vertical up orientation
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MainApp());
}

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
