import 'package:charts_flutter/flutter.dart' as charts;
import 'package:covid/model/classes.dart';
import 'package:flutter/material.dart';

class StackedAreaCustomColorLineChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  final String title;

  StackedAreaCustomColorLineChart(this.seriesList, {this.animate, this.title});

  factory StackedAreaCustomColorLineChart.drawChart(
      List<Record> cases, List<Record> deaths, List<Record> recovered, String title) {
    return new StackedAreaCustomColorLineChart(
      _drawChart(cases.sublist(1), deaths.sublist(1), recovered.sublist(1)),
      animate: true,
      title: title,
    );
  }

  factory StackedAreaCustomColorLineChart.drawChartPerDay(
      List<Record> cases, List<Record> deaths, List<Record> recovered, String title) {
    List<Record> casesPerDay = _totalPerDay(cases);
    List<Record> deathsPerDay = _totalPerDay(deaths);
    List<Record> recoveredPerDay = _totalPerDay(recovered);
    return new StackedAreaCustomColorLineChart(
      _drawChart(casesPerDay, deathsPerDay, recoveredPerDay),
      animate: true,
      title: title,
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
        behaviors: [new charts.ChartTitle(this.title,
            behaviorPosition: charts.BehaviorPosition.top,
            titleStyleSpec: charts.TextStyleSpec(
                color: charts.Color.white,
                fontFamily: 'Roboto',
                fontSize: 18
            ),
            titleOutsideJustification:
            charts.OutsideJustification.middleDrawArea
        ),
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

  static List<Record> _totalPerDay(List<Record> records){
    List<Record> recordsPerDay = [];
    for(int i = 1; i<records.length; i++){
        Record record = records.elementAt(i);
        Record prevRecord = records.elementAt(i - 1);
        int cases = record.cases - prevRecord.cases;
        recordsPerDay.add(Record(record.date, cases));
    }
    return recordsPerDay;
  }
}
