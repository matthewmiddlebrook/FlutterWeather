import 'package:FlutterWeather/models/WeatherData.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

/// Sample linear data type.
class TempDataPoint {
  final DateTime time;
  final double tempHi;
  final double tempLo;

  TempDataPoint(this.time, this.tempHi, this.tempLo);
}

class TempGraph extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate = true;
  final Color tColor;

  TempGraph(this.seriesList, {bool animate, this.tColor});

  factory TempGraph.withSampleData({WeatherData weather, Color textColor}) {
    return new TempGraph(_createSampleData(weather, textColor),
        animate: true, tColor: textColor);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350.0,
      height: 100.0,
      child: charts.TimeSeriesChart(
        seriesList,
        animate: animate,
        dateTimeFactory: const charts.LocalDateTimeFactory(),
        behaviors: [
          charts.RangeAnnotation([
            charts.LineAnnotationSegment(
                32, charts.RangeAnnotationAxisType.measure),
          ])
        ],
        domainAxis: charts.EndPointsTimeAxisSpec(
          renderSpec: charts.SmallTickRendererSpec(
            labelStyle: charts.TextStyleSpec(
              color:
                  charts.Color(r: tColor.red, g: tColor.green, b: tColor.blue),
            ),
          ),
        ),
        primaryMeasureAxis: charts.NumericAxisSpec(
          tickProviderSpec:
              charts.BasicNumericTickProviderSpec(zeroBound: false),
          renderSpec: charts.GridlineRendererSpec(
            lineStyle: charts.LineStyleSpec(dashPattern: [4, 4]),
            labelStyle: charts.TextStyleSpec(
              color:
                  charts.Color(r: tColor.red, g: tColor.green, b: tColor.blue),
            ),
          ),
        ),
      ),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<TempDataPoint, DateTime>> _createSampleData(
      WeatherData weather, Color textColor) {
    List<TempDataPoint> highData = [];

    for (dynamic e in weather.data['daily']['data']) {
      DateTime dt =
          DateTime.fromMillisecondsSinceEpoch(e['time'] * 1000, isUtc: false);
      highData.add(TempDataPoint(
          dt, e['temperatureHigh'].toDouble(), e['temperatureLow'].toDouble()));
    }

    return [
      new charts.Series<TempDataPoint, DateTime>(
        id: 'High',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (TempDataPoint td, _) => td.time,
        measureFn: (TempDataPoint td, _) => td.tempHi,
        data: highData,
      ),
      new charts.Series<TempDataPoint, DateTime>(
        id: 'Low',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TempDataPoint td, _) => td.time,
        measureFn: (TempDataPoint td, _) => td.tempLo,
        data: highData,
      )
    ];
  }
}
