import 'package:covid/model/classes.dart';
import 'package:covid/screen/common/info_card.dart';
import 'package:covid/screen/common/loading.dart';
import 'package:covid/screen/countries_list.dart';
import 'package:covid/screen/fav_countries_list.dart';
import 'package:covid/screen/widgets/chart.dart';
import 'package:covid/utils/constants.dart';
import 'package:covid/utils/http.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class WorldWideDetails extends StatefulWidget {
  WorldWideDetails();

  @override
  State<WorldWideDetails> createState() => _WorldWideDetailsState();
}

class _WorldWideDetailsState extends State<WorldWideDetails> {
  WorldWideDetailsResponse worldDetails;
  var _loadingInProgress = false;
  List<Record> casesW = [];
  List<Record> deathsW = [];
  List<Record> recoveredW = [];

  _WorldWideDetailsState();

  @override
  void initState() {
    super.initState();
    _seeWorldDetails();
    _loadingInProgress = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          child: Row(children:[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
            ),
            Container(
                child: Text(
              "WorldWide Details",
              style: TextStyle(fontSize: 20),
            )
            )],
          ),
        ),
      ),
      body: _loadingInProgress
          ? loadingWidget
          : _buildDetailsView(context),

      floatingActionButton: SpeedDial(
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
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.black,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
              child: Icon(Icons.favorite),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: _seeFavCountryList
          ),
          SpeedDialChild(
            child: Icon(Icons.format_list_bulleted),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: _seeCountryList,
          ),
        ],
      ),
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
                        value: worldDetails.cases,
                        valueColor: Colors.blue,
                        valueFontSize: 60),
                    back: new InfoCard(
                        paddingTopBottom: 20,
                        title: "Today cases",
                        value: worldDetails.todayCases,
                        valueColor: Colors.blue,
                        valueFontSize: 60)),
                Row(
                  children: [
                    Flexible(
                      child: FlipCard(
                          front: new InfoCard(
                              paddingTopBottom: 15,
                              title: "Recovered",
                              value: worldDetails.recovered,
                              valueColor: Colors.green,
                              valueFontSize: 35),
                          back: new InfoCard(
                              paddingTopBottom: 15,
                              title: "Today recovered",
                              value: worldDetails.todayRecovered,
                              valueColor: Colors.green,
                              valueFontSize: 35)),
                    ),
                    Flexible(
                      child: FlipCard(
                          front: new InfoCard(
                              paddingTopBottom: 15,
                              title: "Deaths",
                              value: worldDetails.deaths,
                              valueColor: Colors.redAccent,
                              valueFontSize: 35),
                          back: new InfoCard(
                              paddingTopBottom: 15,
                              title: "Today deaths",
                              value: worldDetails.todayDeaths,
                              valueColor: Colors.redAccent,
                              valueFontSize: 35)),
                    ),
                  ],
                ),
                Container(
                    height: MediaQuery.of(context).size.height / 2,
                    child: StackedAreaCustomColorLineChart.drawChart(
                        this.casesW, this.deathsW, this.recoveredW)),
              ]),
        ),
      ),
    );
  }

  void _seeWorldDetails() async {
    await restClient.get(WW_DETAILS_URL).then((value) =>
        {this.worldDetails = WorldWideDetailsResponse.fromJson(value.data)});

    await restClient.get(WW_HISTORICAL_URL).then((value) => {
          this.casesW = _historicalRecords(value.data, "cases"),
          this.deathsW = _historicalRecords(value.data, "deaths"),
          this.recoveredW = _historicalRecords(value.data, "recovered")
        });

    if (this.worldDetails != null &&
        this.casesW != null &&
        this.deathsW != null &&
        this.recoveredW != null) {
      setState(() {
        this._loadingInProgress = false;
      });
    }
  }

  List<Record> _historicalRecords(Map<String, dynamic> json, String type) {
    Map<String, dynamic> list = json[type];
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
            return new CountryList();
          }
      ),
    );
  }

  _seeFavCountryList(){
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return new FavCountryList();
          }
      ),
    );
  }
}