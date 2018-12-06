import 'package:FlutterWeather/models/ForecastData.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeatherItem extends StatelessWidget {
  final DailyForecastData weather;

  WeatherItem({Key key, @required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(DateFormat.E().format(weather.date),
                style: TextStyle(color: Colors.black, fontSize: 24)),
            Text(weather.main,
                style: TextStyle(color: Colors.black, fontSize: 16)),
            Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Spacer(flex: 4),
                Text('${weather.tempH.round().toString()}°F',
                    style: TextStyle(color: Colors.black, fontSize: 24)),
                Spacer(flex: 1),
                Text('${weather.tempL.round().toString()}°F',
                    style: TextStyle(color: Colors.black, fontSize: 24)),
                Spacer(flex: 4),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
