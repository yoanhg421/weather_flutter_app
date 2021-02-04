import 'package:flutter/material.dart';
import 'package:weather_flutter_app/main_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.from(
        colorScheme: ColorScheme.dark(
          primary: Colors.deepPurple.shade900,
          secondary: Colors.deepPurpleAccent,
          background: Color(0xFF0F0F3A),
        ),
        textTheme: TextTheme(
          bodyText2: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 15,
              color: Color(0xFFACACBA)),
        ),
      ),
      initialRoute: MainPage.routeName,
      routes: {
        MainPage.routeName: (context) => MainPage(),
      },
    );
  }
}
