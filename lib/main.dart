import 'package:flutter/material.dart';
import 'package:buscador_gifs/constant/Constant.dart';
import 'package:buscador_gifs/ui/home_page.dart';
import 'package:buscador_gifs/ui/splash_screen.dart';

void main() {
  runApp(MaterialApp(
debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        splash_screen: (BuildContext context) => SplashScreen(),
        home_screen: (BuildContext context) => HomePage(),
      },
    theme: ThemeData(hintColor:Colors.white),
  ));
}