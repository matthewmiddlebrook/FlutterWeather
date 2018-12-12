import 'package:geocoder/geocoder.dart';

class WeatherData {
  final data;

  final DateTime date;
  final Address name;
  final double temp;
  final String currentlySummary;
  final String hourlySummary;
  final String minutelySummary;
  final String dailySummary;
  final String icon;

  final double precipProbability;
  final double precipIntensity;
  final double cloudCover;
  final double uvIndex;
  final double pressure;
  final double visibility;
  final double tempFeel;
  final double humidity;

  final double windSpeed;
  final String windBearing;
  final double windAngle;

  final String moonPhase;
  final String moonPhasePic;

  final DateTime sunrise;
  final DateTime sunset;

  WeatherData({
    this.date,
    this.name,
    this.temp,
    this.currentlySummary,
    this.hourlySummary,
    this.minutelySummary,
    this.dailySummary,
    this.icon,
    this.data,
    this.precipProbability,
    this.precipIntensity,
    this.cloudCover,
    this.uvIndex,
    this.pressure,
    this.visibility,
    this.tempFeel,
    this.humidity,
    this.windSpeed,
    this.windBearing,
    this.windAngle,
    this.moonPhase,
    this.moonPhasePic,
    this.sunrise,
    this.sunset,
  });

  static bool inRange(num, begin, end) {
    return num >= begin && num < end;
  }

  static String windBearingName(double windBearing) {
    if (inRange(windBearing, 0, 45) || inRange(windBearing, 360 - 45, 360))
      return 'North';
    else if (inRange(windBearing, 45, 90 + 45))
      return 'East';
    else if (inRange(windBearing, 180 - 45, 180 + 45))
      return 'South';
    else
      return 'West';
  }

  static String moonPhaseName(double lunation) {
    if (inRange(lunation, 1 / 14, 3 / 14))
      return 'Waxing-Crescent';
    else if (inRange(lunation, 3 / 14, 5 / 14))
      return 'First-Quarter';
    else if (inRange(lunation, 5 / 14, 7 / 14))
      return 'Waxing-Gibbous';
    else if (inRange(lunation, 7 / 14, 9 / 14))
      return 'Full';
    else if (inRange(lunation, 9 / 14, 11 / 14))
      return 'Third-Quarter';
    else if (inRange(lunation, 11 / 14, 13 / 14))
      return 'Waning-Crescent';
    else
      return 'New';
  }

  factory WeatherData.fromJson(Map<String, dynamic> json) {
//    List<double> data = [];
//    for (var a in json['minutely']['data']) {
//      data.add(a['precipIntensity']);
//    }

    // SNOW HACK: Dark Sky apparently doesn't know what snow is on the currently summary
    String currently = json['currently']['summary'];
    String icon = json['currently']['icon'];

//    String check = json['minutely']['summary'].toString().toLowerCase();
//    if ((check.contains('snow') || check.contains('flurries')) && !check.contains('starting')) {
//      currently = 'Snow';
//      icon = 'snow';
//    }

    return WeatherData(
      data: json,
      date: DateTime.fromMillisecondsSinceEpoch(
          json['currently']['time'] * 1000,
          isUtc: false),
      name: json['name'],
      temp: json['currently']['temperature'].toDouble(),
      currentlySummary: currently,
      hourlySummary: json['hourly']['summary'],
      minutelySummary: json['minutely']['summary'],
      dailySummary: json['daily']['summary'],
      icon: icon,

      precipProbability: json['currently']['precipProbability'].toDouble(),
      precipIntensity: json['currently']['precipIntensity'].toDouble(),
      cloudCover: json['currently']['cloudCover'].toDouble(),
      uvIndex: json['currently']['uvIndex'].toDouble(),
      pressure: json['currently']['pressure'].toDouble(),
      visibility: json['currently']['visibility'].toDouble(),
      tempFeel: json['currently']['apparentTemperature'].toDouble(),
      humidity: json['currently']['humidity'].toDouble(),

      windSpeed: json['currently']['windSpeed'].toDouble(),
      windBearing: windBearingName(json['currently']['windBearing'].toDouble()),
      windAngle: json['currently']['windBearing'].toDouble(),

      moonPhase: moonPhaseName(json['daily']['data'][0]['moonPhase']),
      moonPhasePic: moonPhaseName(json['daily']['data'][0]['moonPhase']),

      sunrise: DateTime.fromMillisecondsSinceEpoch(
          json['daily']['data'][0]['sunriseTime'] * 1000,
          isUtc: false),
      sunset: DateTime.fromMillisecondsSinceEpoch(
          json['daily']['data'][0]['sunsetTime'] * 1000,
          isUtc: false),
    );
  }
}
