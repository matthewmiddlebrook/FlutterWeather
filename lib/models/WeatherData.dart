import 'package:geocoder/geocoder.dart';

class WeatherData {
  final DateTime date;
  final Address name;
  final double temp;
  final String main;
  final String icon;

  WeatherData({this.date, this.name, this.temp, this.main, this.icon});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      date: DateTime.fromMillisecondsSinceEpoch(
          json['currently']['time'] * 1000,
          isUtc: false),
      name: json['name'],
      temp: json['currently']['temperature'].toDouble(),
      main: json['currently']['summary'],
      icon: json['currently']['icon'],
    );
  }
}
