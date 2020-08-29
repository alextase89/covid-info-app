import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class InfoCard extends StatelessWidget {
  final double paddingTopBottom;
  final String title;
  final int value;
  final double valueFontSize;
  final Color valueColor;

  InfoCard(
      {this.paddingTopBottom,
      this.title,
      this.value,
      this.valueFontSize,
      this.valueColor});

  @override
  Widget build(BuildContext context) {
    var f = new NumberFormat("#,###", "en_US");
    return Card(
        elevation: 10,
        child: Column(children: [
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: this.paddingTopBottom),
                      child: Text(
                        this.title,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      child: Text(
                        f.format(value),
                        style: TextStyle(
                            fontSize: this.valueFontSize,
                            color: this.valueColor,
                            fontWeight: FontWeight.bold),
                      ),
                      padding: EdgeInsets.only(bottom: this.paddingTopBottom),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                    Container(
                        margin: const EdgeInsets.only(bottom: 5.0, right: 8.0),
                        child: Icon(FontAwesomeIcons.syncAlt, color: Colors.blueGrey, size: 15)
                    )
                  ])
              )
            ],
          )
        ]));
  }
}
