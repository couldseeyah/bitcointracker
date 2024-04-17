import 'package:flutter/material.dart';
import 'price_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
          primaryColor: Color(0xFF03D3CF),
          appBarTheme: AppBarTheme(
            color: Color(0xFF03D3CF),
          ),
          scaffoldBackgroundColor: Colors.white),
      home: PriceScreen(),
    );
  }
}
