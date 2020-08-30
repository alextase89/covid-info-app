import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NotFountScreen extends StatelessWidget {
  final String text;
  final bool isMainScreen;

  NotFountScreen({this.text, this.isMainScreen});

  @override
  Widget build(BuildContext context) {
    return new Column(children: [
      Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.only(top: !this.isMainScreen ? 10 : MediaQuery.of(context).size.height / 3),
                    child: Icon(
                      FontAwesomeIcons.frown,
                      size: this.isMainScreen ? 130 : 110,
                      color: Colors.redAccent,
                    )),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    this.text,
                    style: TextStyle(fontSize: this.isMainScreen ? 20 : 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ]);
  }
}
