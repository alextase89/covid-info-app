import 'dart:ui';
import 'package:covid/screen/countries_list.dart';
import 'package:covid/screen/worldwide_details.dart';
import 'package:covid/utils/constants.dart';
import 'package:covid/utils/http.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  runApp(new MaterialApp(
    home: new MyApp(),
    theme: ThemeData.dark(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return SplashScreen(
      seconds: 2,
      navigateAfterSeconds: new WorldWideDetails(),
      title: Text(
          "COVID 19",
          style: TextStyle(
              color: Colors.redAccent,
              fontSize: 30,
              fontWeight: FontWeight.bold
          ),
      ),
      image: Image.asset("assets/images/covid_splash.png"),
      backgroundColor: Colors.black38,
      photoSize: 100,
      loaderColor: Colors.white60,
    );
  }

}