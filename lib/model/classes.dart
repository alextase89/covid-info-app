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

  InformationDetailsResponse({
    this.cases,
    this.todayCases,
    this.deaths,
    this.todayDeaths,
    this.recovered,
    this.todayRecovered,
    this.active,
    this.critical,
    this.tests
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
          tests: json["tests"]);
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