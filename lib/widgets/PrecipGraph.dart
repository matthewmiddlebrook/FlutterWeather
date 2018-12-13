import 'package:FlutterWeather/models/WeatherData.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

/// Sample linear data type.
class TempDataPoint {
  final DateTime time;
  final double temp;

  TempDataPoint(this.time, this.temp);
}

class PrecipGraph extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate = true;
  final Color tColor;

  PrecipGraph(this.seriesList, {bool animate, this.tColor});

  factory PrecipGraph.withSampleData({WeatherData weather, Color textColor}) {
    return new PrecipGraph(_createSampleData(weather, textColor),
        animate: true, tColor: textColor);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350.0,
      height: 100.0,
      child: new charts.TimeSeriesChart(
        seriesList,
        animate: animate,
        dateTimeFactory: const charts.LocalDateTimeFactory(),
        domainAxis: new charts.EndPointsTimeAxisSpec(
          renderSpec: new charts.SmallTickRendererSpec(
            labelStyle: new charts.TextStyleSpec(
              color:
              charts.Color(r: tColor.red, g: tColor.green, b: tColor.blue),
            ),
          ),
        ),
        primaryMeasureAxis: new charts.NumericAxisSpec(
          renderSpec: new charts.GridlineRendererSpec(
            labelStyle: new charts.TextStyleSpec(
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

    for (dynamic e in weather.data['minutely']['data']) {
      DateTime dt =
          DateTime.fromMillisecondsSinceEpoch(e['time'] * 1000, isUtc: false);
      highData.add(TempDataPoint(
          dt,
          e['precipProbability'] != null
              ? e['precipProbability'].toDouble() *
              e['precipIntensity'].toDouble() *
              2
              : 0));
    }

    return [
      new charts.Series<TempDataPoint, DateTime>(
        id: 'High',
        colorFn: (_, __) => charts.Color(
            r: textColor.red, g: textColor.green, b: textColor.blue),
        domainFn: (TempDataPoint td, _) => td.time,
        measureFn: (TempDataPoint td, _) => td.temp,
        data: highData,
      ),
    ];
  }
}
