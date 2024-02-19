import 'package:flutter/material.dart';
import 'package:news/screens/HomeScreen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  runApp(const MyApp());
}

/* stateful widget은 두 부분으로 구성됨
위젯: 적은 양의 코드  */
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}
