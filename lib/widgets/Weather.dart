import 'package:FlutterWeather/models/WeatherData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class Weather extends StatelessWidget {
  final WeatherData weather;

  Weather({Key key, @required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(weather.name.locality + ", " + weather.name.adminArea,
                    style: TextStyle(color: Colors.black, fontSize: 16)),
                Text(weather.main,
                    style: TextStyle(color: Colors.black, fontSize: 32.0)),
                SvgPicture.asset("assets/${weather.icon}.svg",
                    color: Colors.black, width: 82, height: 82),
                Text('${weather.temp.toString()}°F',
                    style: TextStyle(color: Colors.black, fontSize: 42)),
                Text("Today is " + DateFormat.yMMMd().format(weather.date),
                    style: TextStyle(color: Colors.black)),
                Text("Updated " + DateFormat.jm().format(weather.date),
                    style: TextStyle(color: Colors.black)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
