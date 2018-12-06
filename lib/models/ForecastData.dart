import 'package:geocoder/geocoder.dart';


class DailyForecastData {
  final DateTime date;
  final Address name;
  final double tempH;
  final double tempL;
  final String main;
  final String icon;

  DailyForecastData({this.date, this.name, this.tempH, this.tempL, this.main, this.icon});
}

class ForecastData {
  final List list;

  ForecastData({this.list});

  factory ForecastData.fromJson(Map<String, dynamic> json) {
    List list = new List();

    for (dynamic e in json['daily']['data']) {
      DailyForecastData w = new DailyForecastData(
          date: new DateTime.fromMillisecondsSinceEpoch(e['time'] * 1000, isUtc: false),
          name: json['name'],
          tempH: e['temperatureHigh'].toDouble(),
          tempL: e['temperatureLow'].toDouble(),
          main: e['summary'],
          icon: e['icon']);
      list.add(w);
    }

    return ForecastData(
      list: list,
    );
  }
}