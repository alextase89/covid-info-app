import 'package:charts_flutter/flutter.dart';
import 'package:covid/utils/util.dart';

class InformationDetailsResponse {
  int cases;
  int todayCases;
  int deaths;
  int todayDeaths;
  int recovered;
  int todayRecovered;
  int active;
  int critical;
  int tests;
  int population;
  double casesPerOneMillion;
  double deathsPerOneMillion;
  double testsPerOneMillion;
  double criticalPerOneMillion;

  InformationDetailsResponse({
    this.cases,
    this.todayCases,
    this.deaths,
    this.todayDeaths,
    this.recovered,
    this.todayRecovered,
    this.active,
    this.critical,
    this.tests,
    this.population,
    this.casesPerOneMillion,
    this.deathsPerOneMillion,
    this.testsPerOneMillion,
    this.criticalPerOneMillion
  });

  factory InformationDetailsResponse.fromJson(Map<String, dynamic> json) =>
      InformationDetailsResponse(
          cases: json["cases"],
          todayCases: json["todayCases"],
          deaths: json["deaths"],
          todayDeaths: json["todayDeaths"],
          recovered: json["recovered"],
          todayRecovered: json["todayRecovered"],
          active: json["active"],
          critical: json["critical"],
          tests: json["tests"],
          population: json["population"],
          casesPerOneMillion: double.tryParse(json["casesPerOneMillion"].toString()),
          deathsPerOneMillion: double.tryParse(json["deathsPerOneMillion"].toString()),
          testsPerOneMillion: double.tryParse(json["testsPerOneMillion"].toString()),
          criticalPerOneMillion: double.tryParse(json["criticalPerOneMillion"].toString())
      );
}

class CountryInfo {
  final String name;
  final String code;

  CountryInfo({this.name, this.code});

  factory CountryInfo.fromJson(Map<String, dynamic> json) =>
       CountryInfo(
          name: json["country"],
          code: toLowerCase(json["countryInfo"]["iso2"])
      );
}

class Record {
  DateTime date;
  int cases;

  Record(this.date, this.cases);
}

class PointValue{
  Color bgColor;
  String text;
  int index;

  PointValue({this.text, this.bgColor, this.index});
}