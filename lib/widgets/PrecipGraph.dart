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

  PrecipGraph(this.seriesList, {bool animate});

  /// Creates a [LineChart] with sample data and no transition.
  factory PrecipGraph.withSampleData({WeatherData weather, Color textColor}) {
    return new PrecipGraph(
      _createSampleData(weather, textColor),
      // Disable animations for image tests.
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350.0,
      height: 100.0,
      child: new charts.TimeSeriesChart(
        seriesList,
        animate: animate,
        // Optionally pass in a [DateTimeFactory] used by the chart. The factory
        // should create the same type of [DateTime] as the data provided. If none
        // specified, the default creates local date time.
        dateTimeFactory: const charts.LocalDateTimeFactory(),
        domainAxis: new charts.EndPointsTimeAxisSpec(),
      ),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<TempDataPoint, DateTime>> _createSampleData(
      WeatherData weather, Color textColor) {
    List<TempDataPoint> highData = [];
//    List<TempDataPoint> lowData = [];

    for (dynamic e in weather.data['minutely']['data']) {
      DateTime dt =
          DateTime.fromMillisecondsSinceEpoch(e['time'] * 1000, isUtc: false);
      highData.add(TempDataPoint(
          dt,
          e['precipAccumulation'] != null
              ? e['precipAccumulation'].toDouble()
              : 0));
//      lowData.add(TempDataPoint(dt, e['temperatureLow']));
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
//      new charts.Series<TempDataPoint, DateTime>(
//        id: 'Low',
//        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
//        domainFn: (TempDataPoint td, _) => td.time,
//        measureFn: (TempDataPoint td, _) => td.temp,
//        data: lowData,
//      ),
    ];
  }
//  PrecipGraph({
//    Key key,
//    @required this.weather,
//  }) : super(key: key);
//
//  final WeatherData weather;
//
//  @override
//  Widget build(BuildContext context) {
//    return Padding(
//      padding: const EdgeInsets.all(8.0),
//      child: Sparkline(
//        data: weather.data,
//        lineWidth: 5.0,
//        lineColor: Colors.white,
//        fallbackHeight: 50,
//        fillMode: FillMode.below,
//        fillGradient: LinearGradient(
//          begin: Alignment.topCenter,
//          end: Alignment.bottomCenter,
//          colors: [Colors.grey[100], Colors.blueGrey[500]],
//        ),
//      ),
//    );
//  }
}
