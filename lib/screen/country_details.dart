import 'package:covid/model/classes.dart';
import 'package:covid/screen/common/info_card.dart';
import 'package:covid/screen/widgets/chart.dart';
import 'package:covid/utils/constants.dart';
import 'package:covid/utils/http.dart';
import 'package:covid/utils/sprintf.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/loading.dart';

class CountryDetails extends StatefulWidget {
  final CountryInfo country;

  CountryDetails(this.country);

  @override
  State<CountryDetails> createState() => _CountryDetailsState(this.country);
}

class _CountryDetailsState extends State<CountryDetails> {
  SharedPreferences _prefs;
  CountryInfo country;
  CountryDetailsResponse countryDetails;
  var _loadingInProgress = false;
  List<Record> cases = [];
  List<Record> deaths = [];
  List<Record> recovered = [];
  List<String> _favorites = [];

  _CountryDetailsState(this.country);

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _seeCountryDetails();
    _loadingInProgress = true;
  }

  void _loadPreferences() async{
    _prefs = await SharedPreferences.getInstance();
    _favorites = (_prefs.getStringList("country_fav") ?? []);
  }

  @override
  Widget build(BuildContext context) {
    bool isFav = _favorites.contains(country.code);
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          child: Row(children: [
            Container(
              width: 48.0,
              height: 50.0,
              child: Image.asset(
                  'icons/flags/png/2.5x/' + country.code + '.png',
                  package: 'country_icons'),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
            ),
            Container(
                child: Text(
              country.name,
              style: TextStyle(fontSize: 20),
            )),
          ]),
        ),
        actions: [
          IconButton(icon: Icon(isFav ? Icons.favorite : Icons.favorite_border), onPressed: _setFav)
        ],
      ),
      body: _loadingInProgress
          ? loadingWidget
          : _buildDetailsView(context),
    );
  }

  void _setFav(){
    setState(() {
      if(_favorites.contains(country.code)){
          _favorites.remove(country.code);
      } else{
          _favorites.add(country.code);
      }
      _prefs.setStringList("country_fav", _favorites);
    });
  }

  Widget _buildDetailsView(BuildContext context) {
    return SingleChildScrollView(
      child: AnimationLimiter(
        child: Column(
          children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 375),
              childAnimationBuilder: (widget) => SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(
                      child: widget,
                    ),
                  ),
              children: [
                FlipCard(
                    front: new InfoCard(
                        paddingTopBottom: 20,
                        title: "Total cases",
                        value: countryDetails.cases,
                        valueColor: Colors.blue,
                        valueFontSize: 70),
                    back: new InfoCard(
                        paddingTopBottom: 20,
                        title: "Today cases",
                        value: countryDetails.todayCases,
                        valueColor: Colors.blue,
                        valueFontSize: 70)),
                Row(
                  children: [
                    Flexible(
                      child: FlipCard(
                          front: new InfoCard(
                              paddingTopBottom: 15,
                              title: "Recovered",
                              value: countryDetails.recovered,
                              valueColor: Colors.green,
                              valueFontSize: 45),
                          back: new InfoCard(
                              paddingTopBottom: 15,
                              title: "Today recovered",
                              value: countryDetails.todayRecovered,
                              valueColor: Colors.green,
                              valueFontSize: 45)),
                    ),
                    Flexible(
                      child: FlipCard(
                          front: new InfoCard(
                              paddingTopBottom: 15,
                              title: "Deaths",
                              value: countryDetails.deaths,
                              valueColor: Colors.redAccent,
                              valueFontSize: 45),
                          back: new InfoCard(
                              paddingTopBottom: 15,
                              title: "Today deaths",
                              value: countryDetails.todayDeaths,
                              valueColor: Colors.redAccent,
                              valueFontSize: 45)),
                    ),
                  ],
                ),
                Container(
                    height: MediaQuery.of(context).size.height / 2,
                    child: StackedAreaCustomColorLineChart.drawChart(
                        this.cases, this.deaths, this.recovered))
              ]),
        ),
      ),
    );
  }

  void _seeCountryDetails() async {
    var countryIso2 = country.code.toUpperCase();
    var serviceUrl = sprintf(COUNTRY_DETAILS_URL, [countryIso2]);
    await restClient.get(serviceUrl).then((value) =>
        {this.countryDetails = CountryDetailsResponse.fromJson(value.data)});

    var historicalUrl = sprintf(COUNTRY_HISTORICAL_URL, [countryIso2]);
    await restClient.get(historicalUrl).then((value) => {
          this.cases = _historicalRecords(value.data, "cases"),
          this.deaths = _historicalRecords(value.data, "deaths"),
          this.recovered = _historicalRecords(value.data, "recovered")
        });

    if (this.countryDetails != null &&
        this.cases != null &&
        this.deaths != null &&
        this.recovered != null) {
      setState(() {
        this._loadingInProgress = false;
      });
    }
  }

  List<Record> _historicalRecords(Map<String, dynamic> json, String type) {
    Map<String, dynamic> list = json["timeline"][type];
    List<Record> records = [];
    list.forEach((key, value) {
      List<String> dateArray = key.split("/");
      int cases = int.parse(value.toString());
      records.add(Record(
          new DateTime(int.parse(dateArray[2]), int.parse(dateArray[0]),
              int.parse(dateArray[1])),
          cases));
    });
    return records;
  }
}
