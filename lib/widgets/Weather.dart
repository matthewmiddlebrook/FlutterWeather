import 'package:FlutterWeather/models/WeatherData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class Weather extends StatelessWidget {
  final WeatherData weather;
  final conditionColors = {
    'clear-day': Colors.amber,
    'clear-night': Colors.blueGrey,
    'rain': Colors.indigo,
    'snow': Colors.grey[100],
    'sleet': Colors.blueGrey[200],
    'wind': Colors.green,
    'fog': Colors.grey[300],
    'cloudy': Colors.grey,
    'partly-cloudy-day': Color.lerp(Colors.blueGrey, Colors.amber, .75),
    'partly-cloudy-night': Colors.blueGrey[600],
  };
  final textColor = Colors.white;

  Weather({Key key, @required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: conditionColors[weather.icon],
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(weather.name.locality + ", " + weather.name.adminArea,
                    style: TextStyle(color: textColor, fontSize: 16)),
                Text(weather.main,
                    style: TextStyle(color: textColor, fontSize: 32.0)),
                SvgPicture.asset("assets/${weather.icon}.svg",
                    color: textColor, width: 82, height: 82),
                Text('${weather.temp.toString()}°',
                    style: TextStyle(color: textColor,
                        fontSize: 42,
                        fontWeight: FontWeight.bold)),
                Text("Today is " + DateFormat.yMMMd().format(weather.date),
                    style: TextStyle(color: textColor)),
                Text("Updated " + DateFormat.jm().format(weather.date),
                    style: TextStyle(color: textColor)),
                Sparkline(
                  data: weather.precipTable,
                  lineWidth: 10.0,
                  lineGradient: new LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.purple[800], Colors.purple[200]],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
