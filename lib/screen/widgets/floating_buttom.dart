import 'package:covid/screen/countries_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class FloatingCountriesButtom extends StatelessWidget {
  bool dialVisible = true;

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      elevation: 10,
      backgroundColor: Colors.blue,
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      visible: dialVisible,
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
          child: CircleAvatar(
            radius: 40.0,
            child: ClipRRect(
              child: Image(
                image: AssetImage('icons/flags/png/2.5x/cu.png',
                    package: 'country_icons'),
              ),
            ),
          ),
          labelWidget: Container(
            color: Colors.blue,
            margin: EdgeInsets.only(right: 2),
            padding: EdgeInsets.all(6),
            child: Text('Cuba'),
          ),
        ),
        SpeedDialChild(
          child: Icon(Icons.brush, color: Colors.white),
          backgroundColor: Colors.green,
          onTap: () => print('SECOND CHILD'),
          label: 'Second Child',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.green,
        ),
        SpeedDialChild(
          child: Icon(Icons.format_list_bulleted, color: Colors.white),
          backgroundColor: Colors.blue,
          onTap: () => print('THIRD CHILD'),
          labelWidget: Container(
            color: Colors.blue,
            margin: EdgeInsets.only(right: 2),
            padding: EdgeInsets.all(6),
            child: Text('All Countries'),
          ),
        ),
      ],
    );
  }
}
