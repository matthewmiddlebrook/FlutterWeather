import 'package:FlutterWeather/models/ForecastData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class WeatherItem extends StatelessWidget {
  final DailyForecastData weather;

  WeatherItem({Key key, @required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: SvgPicture.asset("assets/${weather.icon}.svg",
                  color: Colors.black, width: 54, height: 54),
            ),
            Expanded(
              flex: 6,
              child: Container(
                padding: EdgeInsets.fromLTRB(16.0, 0, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(DateFormat.E().format(weather.date),
                      textAlign: TextAlign.start,
                      style:
                      TextStyle(color: Colors.black, fontSize: 24),
                    ),
                    Text(weather.main,
                        style:
                        TextStyle(color: Colors.black, fontSize: 16)),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('${weather.tempH.round().toString()}°F',
                      style:
                      TextStyle(color: Colors.black, fontSize: 24)),
                  Text('${weather.tempL.round().toString()}°F',
                      style:
                      TextStyle(color: Colors.black, fontSize: 24)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
