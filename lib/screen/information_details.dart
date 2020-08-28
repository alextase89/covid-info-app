import 'package:covid/model/classes.dart';
import 'package:covid/screen/common/extra_info_card.dart';
import 'package:covid/screen/common/info_card.dart';
import 'package:covid/screen/common/loading.dart';
import 'package:covid/screen/countries_list.dart';
import 'package:covid/screen/widgets/chart_historical.dart';
import 'package:covid/screen/widgets/chart_historical_days.dart';
import 'package:covid/utils/constants.dart';
import 'package:covid/utils/http.dart';
import 'package:covid/utils/sprintf.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InformationDetails extends StatefulWidget {
  final bool isWorldWide;
  final CountryInfo countryInfo;
  InformationDetails({this.isWorldWide, this.countryInfo});

  @override
  State<InformationDetails> createState() => _InformationDetailsState(this.isWorldWide, this.countryInfo);
}

class _InformationDetailsState extends State<InformationDetails> {
  SharedPreferences _prefs;
  final bool isWorldWide;
  final CountryInfo countryInfo;
  InformationDetailsResponse infoDetails;
  var _loadingInProgress = false;
  List<Record> cases = [];
  List<Record> deaths = [];
  List<Record> recovered = [];
  List<String> _favorites = [];

  _InformationDetailsState(this.isWorldWide, this.countryInfo);

  @override
  void initState() {
    super.initState();
    _loadingInProgress = true;
    _loadDataAndPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          child: Row(
            children:[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
              ),
              this.isWorldWide
                  ? Container(child: Icon(FontAwesomeIcons.globe))
                  : Container(
                      width: 48.0,
                      height: 50.0,
                      child: Image.asset(
                      'icons/flags/png/2.5x/' + this.countryInfo.code + '.png',
                      package: 'country_icons')
                  ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
              ),
              Container(
                  child: Text(this.isWorldWide
                      ? "WorldWide Details"
                      : this.countryInfo.name,
                  style: TextStyle(fontSize: 20),
                )
              )
            ],
          ),
        ),
          actions: !this.isWorldWide && !this._loadingInProgress
              ? [
                  IconButton(
                    icon: Icon(
                        _favorites.contains(countryInfo.code)
                            ? Icons.favorite
                            : Icons.favorite_border),
                        onPressed: _setFav)

                ]
              : null
      ),
      body: _loadingInProgress
          ? loadingWidget
          : _buildDetailsView(context),

      floatingActionButton: this.isWorldWide
          ? SpeedDial(
              // both default to 16
              marginRight: 18,
              marginBottom: 20,
              animatedIcon: AnimatedIcons.menu_close,
              animatedIconTheme: IconThemeData(size: 22.0),
              // this is ignored if animatedIcon is non null
              // child: Icon(Icons.add),
              visible: true,
              // If true user is forced to close dial manually
              // by tapping main button and overlay is not rendered.
              closeManually: false,
              curve: Curves.bounceIn,
              overlayColor: Colors.black,
              overlayOpacity: 0.5,
              backgroundColor: Colors.blueGrey,
              foregroundColor: Colors.black,
              elevation: 8.0,
              shape: CircleBorder(),
              children: [
                SpeedDialChild(
                    child: Icon(Icons.favorite),
                    backgroundColor: Colors.blueGrey,
                    foregroundColor: Colors.white,
                    label: "Favourites",
                    labelStyle: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),
                    labelBackgroundColor: Colors.blueGrey,
                    onTap: _seeFavCountryList
                ),
                SpeedDialChild(
                  child: Icon(FontAwesomeIcons.globeAmericas),
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white,
                  label: "Countries List",
                  labelStyle: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),
                  labelBackgroundColor: Colors.blueGrey,
                  onTap: _seeCountryList,
                ),
              ],
            )
        : null,
    );
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
                        value: infoDetails.cases,
                        valueColor: Colors.blue,
                        valueFontSize: 60),
                    back: new InfoCard(
                        paddingTopBottom: 20,
                        title: "Today cases",
                        value: infoDetails.todayCases,
                        valueColor: Colors.blue,
                        valueFontSize: 60)),
                Row(
                  children: [
                    Flexible(
                      child: FlipCard(
                          front: new InfoCard(
                              paddingTopBottom: 15,
                              title: "Recovered",
                              value: infoDetails.recovered,
                              valueColor: Colors.green,
                              valueFontSize: 33),
                          back: new InfoCard(
                              paddingTopBottom: 15,
                              title: "Today recovered",
                              value: infoDetails.todayRecovered,
                              valueColor: Colors.green,
                              valueFontSize: 33)),
                    ),
                    Flexible(
                      child: FlipCard(
                          front: new InfoCard(
                              paddingTopBottom: 15,
                              title: "Deaths",
                              value: infoDetails.deaths,
                              valueColor: Colors.redAccent,
                              valueFontSize: 33),
                          back: new InfoCard(
                              paddingTopBottom: 15,
                              title: "Today deaths",
                              value: infoDetails.todayDeaths,
                              valueColor: Colors.redAccent,
                              valueFontSize: 33)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      child: ExtraInfoCard(informationDetailsResponse: this.infoDetails),
                    ),
                  ],
                ),
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    height: MediaQuery.of(context).size.height / 2,
                    child: HistoricalPerDayChart.drawChartPerDay(
                        this.cases, this.deaths, this.recovered, "Historical Totals Daily")
                ),

                Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    height: MediaQuery.of(context).size.height / 2,
                    child: HistoricalTotalsChart.drawChart(
                        this.cases, this.deaths, this.recovered, "Historical Totals")
                ),
              ]),
        ),
      ),
    );
  }

  void _loadDataAndPreferences() async{
    _prefs = await SharedPreferences.getInstance();

    String detailsUrl = this.isWorldWide
        ? WW_DETAILS_URL
        : sprintf(COUNTRY_DETAILS_URL, [this.countryInfo.code]);
    await restClient.get(detailsUrl).then((value) =>
        {this.infoDetails = InformationDetailsResponse.fromJson(value.data)});

    String historicalUrl = this.isWorldWide
        ? WW_HISTORICAL_URL
        : sprintf(COUNTRY_HISTORICAL_URL, [this.countryInfo.code]);
    await restClient.get(historicalUrl).then((value) => {
          this.cases = _historicalRecords(value.data, "cases"),
          this.deaths = _historicalRecords(value.data, "deaths"),
          this.recovered = _historicalRecords(value.data, "recovered")
        });

    if (this._prefs != null &&
        this.infoDetails != null &&
        this.cases != null &&
        this.deaths != null &&
        this.recovered != null) {
      if(mounted) {
        setState(() {
          this._loadingInProgress = false;
          this._favorites = (_prefs.getStringList("country_fav") ?? []);
        });
      }
    }
  }

  List<Record> _historicalRecords(Map<String, dynamic> json, String type) {
    Map<String, dynamic> list = this.isWorldWide
        ? json[type]
        : json["timeline"][type];
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

  _seeCountryList(){
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return new CountryList(isFav: false);
          }
      ),
    );
  }

  _seeFavCountryList(){
    List<String> favorites = (_prefs.getStringList("country_fav") ?? []);
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return new CountryList(countryCodes: favorites, isFav: true);
          }
      ),
    );
  }

  void _setFav(){
    setState(() {
      if(_favorites.contains(countryInfo.code)){
        _favorites.remove(countryInfo.code);
      } else{
        _favorites.add(countryInfo.code);
      }
      _prefs.setStringList("country_fav", _favorites);
    });
  }
}