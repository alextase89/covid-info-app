import 'package:covid/model/classes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
            _infoCard("Population", f.format(this.informationDetailsResponse.population)),
            _infoCard("Cases/Million", f.format(this.informationDetailsResponse.casesPerOneMillion)),
          ],
        ),
        Row(
          children: [
            _infoCard("Active Cases", f.format(this.informationDetailsResponse.active)),
            _infoCard("Deaths/Million", f.format(this.informationDetailsResponse.deathsPerOneMillion)),
          ],
        ),
        Row(
          children: [
            _infoCard("Critical", f.format(this.informationDetailsResponse.critical)),
            _infoCard("Critical/Million", f.format(this.informationDetailsResponse.criticalPerOneMillion)),
          ],
        ),
        Row(
          children: [
            _infoCard("Test", f.format(this.informationDetailsResponse.tests)),
            _infoCard("Test/Million", f.format(this.informationDetailsResponse.testsPerOneMillion)),
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
                  fontSize: 20,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
