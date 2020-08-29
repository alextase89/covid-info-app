import 'dart:ui';
import 'package:covid/screen/information_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:splashscreen/splashscreen.dart';

import 'i18n/main.i18n.dart';

void main() {
  runApp(MaterialApp(
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: [
      const Locale('en', "US"),
      const Locale('es', "UY"),
    ],
    home: new I18n(
      child: new MyApp()
    ),
    theme: ThemeData.dark(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      navigateAfterSeconds: InformationDetails(isWorldWide: true),
      title: Text(
          "COVID-19",
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
      loadingText: Text(
        "Loading World and Countries Information...".i18n,
        style: TextStyle(
            color: Colors.redAccent,
            fontSize: 15
        ),
      )
    );
  }

}