import 'package:covid/utils/util.dart';

class WorldWideDetailsResponse {
  int cases;
  int todayCases;
  int deaths;
  int todayDeaths;
  int recovered;
  int todayRecovered;
  int active;
  int critical;
  int tests;
  List<Record> casesW = [];
  List<Record> deathsW = [];
  List<Record> recoveredW = [];

  WorldWideDetailsResponse({
    this.cases,
    this.todayCases,
    this.deaths,
    this.todayDeaths,
    this.recovered,
    this.todayRecovered,
    this.active,
    this.critical,
    this.tests,
    this.casesW,
    this.deathsW,
    this.recoveredW,
  });

  factory WorldWideDetailsResponse.fromJson(Map<String, dynamic> json) =>
      WorldWideDetailsResponse(
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


class CountryDetailsResponse {
  CountryInfo countryInfo;
  int cases;
  int todayCases;
  int deaths;
  int todayDeaths;
  int recovered;
  int todayRecovered;
  int active;
  int critical;
  int tests;

  CountryDetailsResponse({
    this.countryInfo,
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

  factory CountryDetailsResponse.fromJson(Map<String, dynamic> json) =>
      CountryDetailsResponse(
          countryInfo: CountryInfo.fromJson(json),
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


class Record {
  DateTime date;
  int cases;

  Record(this.date, this.cases);
}