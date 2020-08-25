import 'package:charts_flutter/flutter.dart' as charts;
import 'package:covid/model/classes.dart';
import 'package:flutter/material.dart';

class StackedAreaCustomColorLineChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  StackedAreaCustomColorLineChart(this.seriesList, {this.animate});

  factory StackedAreaCustomColorLineChart.drawChart(
      List<Record> cases, List<Record> deaths, List<Record> recovered) {
    return new StackedAreaCustomColorLineChart(
      _drawChart(cases, deaths, recovered),
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(seriesList,
        defaultRenderer:
            new charts.LineRendererConfig(includeArea: true, stacked: false),
        animate: animate,
        primaryMeasureAxis: new charts.NumericAxisSpec(
            renderSpec: new charts.SmallTickRendererSpec(
              labelStyle: charts.TextStyleSpec(color: charts.MaterialPalette.white),
            )
        ),
        domainAxis: new charts.DateTimeAxisSpec(
            renderSpec: new charts.SmallTickRendererSpec(
              labelStyle: charts.TextStyleSpec(color: charts.MaterialPalette.white),
            )
        ),
        dateTimeFactory: const charts.LocalDateTimeFactory(),
        behaviors: [
          new charts.SeriesLegend(
            position: charts.BehaviorPosition.bottom,
            outsideJustification: charts.OutsideJustification.middleDrawArea,
            horizontalFirst: false,
            desiredMaxRows: 1,
            cellPadding: new EdgeInsets.only(right: 8.0, bottom: 4.0),
            entryTextStyle: charts.TextStyleSpec(
                color: charts.Color.white,
                fontFamily: 'Roboto',
                fontSize: 13),
          )
        ],
    );
  }

  static List<charts.Series<Record, DateTime>> _drawChart(
      List<Record> cases, List<Record> deaths, List<Record> recovered) {

    return [
      new charts.Series<Record, DateTime>(
        id: 'Cases',
        // colorFn specifies that the line will be blue.
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Record r, _) => r.date,
        measureFn: (Record r, _) => r.cases,
        data: cases,
      ),
      new charts.Series<Record, DateTime>(
        id: 'Deaths',
        // colorFn specifies that the line will be blue.
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (Record r, _) => r.date,
        measureFn: (Record r, _) => r.cases,
        data: deaths,
      ),
      new charts.Series<Record, DateTime>(
        id: 'Recovered',
        // colorFn specifies that the line will be blue.
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (Record r, _) => r.date,
        measureFn: (Record r, _) => r.cases,
        data: recovered,
      )
    ];
  }
}
