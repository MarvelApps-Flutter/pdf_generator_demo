import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final Map<int, Color> color =
  {
    50: Colors.indigoAccent.shade700,
    100:Colors.indigoAccent.shade700,
    200:Colors.indigoAccent.shade700,
    300:Colors.indigoAccent.shade700,
    400:Colors.indigoAccent.shade700,
    500:Colors.indigoAccent.shade700,
    600:Colors.indigoAccent.shade700,
    700:Colors.indigoAccent.shade700,
    800:Colors.indigoAccent.shade700,
    900:Colors.indigoAccent.shade700,
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Pdf Generator Module',
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFF304ffe, color),
      ),
      home: const SplashScreen(),
    );
  }
}

