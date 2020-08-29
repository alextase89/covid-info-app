
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/src/text_element.dart';
import 'package:charts_flutter/src/text_style.dart' as style;
import 'package:covid/model/classes.dart';
import 'package:intl/intl.dart';
import '../../i18n/main.i18n.dart';


class HistoricalPerDayChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  final String title;
  static List<PointValue> pointsValues = [];

  HistoricalPerDayChart(this.seriesList, {this.animate, this.title});

  factory HistoricalPerDayChart.drawChartPerDay(
      List<Record> cases, List<Record> deaths, List<Record> recovered, String title) {
    List<Record> casesPerDay = _totalPerDay(cases);
    List<Record> deathsPerDay = _totalPerDay(deaths);
    List<Record> recoveredPerDay = _totalPerDay(recovered);
    return new HistoricalPerDayChart(
      _drawChart(casesPerDay, deathsPerDay, recoveredPerDay),
      animate: true,
      title: title,
    );
  }
  @override
  Widget build(BuildContext context) {
    var f = new NumberFormat("#,###", "en_US");
    return new charts.TimeSeriesChart(seriesList,
        defaultRenderer:
            new charts.LineRendererConfig(includeArea: true, stacked: false),
        animate: animate,
        primaryMeasureAxis: new charts.NumericAxisSpec(
            tickFormatterSpec: charts.BasicNumericTickFormatterSpec.fromNumberFormat(
                NumberFormat.compact()
            ),
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
          new charts.ChartTitle(this.title,
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
          ),
          charts.LinePointHighlighter(
            symbolRenderer: CustomCircleSymbolRenderer()
          ),
        ],
      selectionModels: [
        charts.SelectionModelConfig(
            changedListener: (charts.SelectionModel model) {
              if(model.hasDatumSelection) {
                pointsValues = [];
                model.selectedDatum.forEach((charts.SeriesDatum datumPair) {
                  pointsValues.add(PointValue(
                      bgColor: datumPair.series.colorFn(datumPair.index),
                      text: f.format(datumPair.series.measureFn(datumPair.index)),
                      index: datumPair.index
                    )
                  );
                });
              }
            }
        )
      ],

    );
  }

  static List<charts.Series<Record, DateTime>> _drawChart(
      List<Record> cases, List<Record> deaths, List<Record> recovered) {

    return [
      new charts.Series<Record, DateTime>(
        id: 'Cases'.i18n,
        // colorFn specifies that the line will be blue.
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Record r, _) => r.date,
        measureFn: (Record r, _) => r.cases,
        data: cases,
      ),
      new charts.Series<Record, DateTime>(
        id: 'Deaths'.i18n,
        // colorFn specifies that the line will be blue.
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (Record r, _) => r.date,
        measureFn: (Record r, _) => r.cases,
        data: deaths,
      ),
      new charts.Series<Record, DateTime>(
        id: 'Recovered'.i18n,
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

class CustomCircleSymbolRenderer extends charts.CircleSymbolRenderer {
  @override
  void paint(charts.ChartCanvas canvas, Rectangle bounds, {List<int> dashPattern, charts.Color fillColor, charts.FillPatternType fillPattern, charts.Color strokeColor, double strokeWidthPx}) {
    super.paint(canvas, bounds, dashPattern: dashPattern, fillColor: fillColor, strokeColor: strokeColor, strokeWidthPx: strokeWidthPx);

    List<PointValue> pointsValues = HistoricalPerDayChart.pointsValues;
    if(pointsValues.isNotEmpty) {
      for(int i = 0; i < pointsValues.length; i++) {
        PointValue pointValue = pointsValues[i];
        if(fillColor == pointValue.bgColor) {
          double alignmentLeft = _alignmentLeft(bounds, pointValue);
          double alignmentTop = bounds.top - 20;
          canvas.drawRect(
              Rectangle(alignmentLeft, alignmentTop,
                  bounds.width + pointValue.text.length * 8,
                  bounds.height + 10),
              fill: pointValue.bgColor
          );
          var textStyle = style.TextStyle();
          textStyle.color = charts.Color.white;
          textStyle.fontSize = 15;
          canvas.drawText(
              TextElement(
                  pointValue.text,
                  style: textStyle),
              (alignmentLeft + 5).round(),
              (alignmentTop + 2).round()
          );
        }
      }
    }
  }

  double _alignmentLeft(Rectangle bounds, PointValue pointValue){
    double alignmentLeft = bounds.left - 10 - (pointValue.text.length * 9);
    if(pointValue.index < 15){
      alignmentLeft = bounds.left + 5;
    }
    return alignmentLeft;
  }
}
