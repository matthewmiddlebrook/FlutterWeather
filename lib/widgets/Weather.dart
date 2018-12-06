import 'package:FlutterWeather/models/WeatherData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class Weather extends StatelessWidget {
  final WeatherData weather;

  Weather({Key key, @required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(weather.name.locality + ", " + weather.name.adminArea,
            style: TextStyle(color: Colors.white, fontSize: 16)),
        Text(weather.main,
            style: TextStyle(color: Colors.white, fontSize: 32.0)),
        SvgPicture.asset("assets/Sun.svg",
            color: Colors.white, width: 82, height: 82),
        Text('${weather.temp.toString()}°F',
            style: TextStyle(color: Colors.white, fontSize: 42)),
        Text("Today is " + DateFormat.yMMMd().format(weather.date),
            style: TextStyle(color: Colors.white)),
        Text("Updated " + DateFormat.jm().format(weather.date),
            style: TextStyle(color: Colors.white)),
      ],
    );
  }
}
