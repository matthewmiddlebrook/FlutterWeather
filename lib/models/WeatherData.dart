import 'package:geocoder/geocoder.dart';

class WeatherData {
  final DateTime date;
  final Address name;
  final double temp;
  final String main;
  final String icon;
  final precipTable;

  WeatherData(
      {this.date, this.name, this.temp, this.main, this.icon, this.precipTable});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    List<double> data = [];
    for (var a in json['minutely']['data']) {
      data.add(a['precipIntensity']);
    }

    return WeatherData(
      date: DateTime.fromMillisecondsSinceEpoch(
          json['currently']['time'] * 1000,
          isUtc: false),
      name: json['name'],
      temp: json['currently']['temperature'].toDouble(),
      main: json['currently']['summary'],
      icon: json['currently']['icon'],
      precipTable: data,
    );
  }
}
