import 'package:covid/model/classes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../i18n/main.i18n.dart';

class ExtraInfoCard extends StatelessWidget {
  InformationDetailsResponse informationDetailsResponse;

  ExtraInfoCard({this.informationDetailsResponse});

  @override
  Widget build(BuildContext context) {
    var f = new NumberFormat("#,###", "en_US");
    return Card(
      elevation: 10,
      child: Column(children: [
        Row(
          children: [
            _infoCard("Population".i18n, f.format(this.informationDetailsResponse.population)),
            _infoCard("Cases/Million".i18n, f.format(this.informationDetailsResponse.casesPerOneMillion)),
          ],
        ),
        Row(
          children: [
            _infoCard("Active cases".i18n, f.format(this.informationDetailsResponse.active)),
            _infoCard("Deaths/Million".i18n, f.format(this.informationDetailsResponse.deathsPerOneMillion)),
          ],
        ),
        Row(
          children: [
            _infoCard("Critical".i18n, f.format(this.informationDetailsResponse.critical)),
            _infoCard("Critical/Million".i18n, f.format(this.informationDetailsResponse.criticalPerOneMillion)),
          ],
        ),
        Row(
          children: [
            _infoCard("Tests".i18n, f.format(this.informationDetailsResponse.tests)),
            _infoCard("Tests/Million".i18n, f.format(this.informationDetailsResponse.testsPerOneMillion)),
          ],
        ),
      ]),
    );
  }

  Widget _infoCard(String title, String value){
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 8, left: 15),
            child: Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 3, left: 15, bottom: 8),
            child: Text(
              value,
              style: TextStyle(
                  fontSize: 22,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
