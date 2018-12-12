import 'package:FlutterWeather/models/HourlyData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class HourlyScreen extends StatelessWidget {
  final HourlyData hourlyData;

  HourlyScreen({Key key, @required this.hourlyData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Next 48 Hours"),
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: hourlyData != null
                  ? Column(
                      children: List.generate(
                        hourlyData.list.length,
                        (index) {
                          return HourlyItem(
                              hourlyForecastData:
                                  hourlyData.list.elementAt(index));
                        },
                      ),
                    )
                  : Container(),
            ),
          )
        ],
      ),
    );
  }
}

class HourlyItem extends StatelessWidget {
  final HourlyForecastData hourlyForecastData;

  final conditionColors = {
    'clear-day': Colors.amber,
    'clear-night': Colors.blueGrey,
    'rain': Colors.indigo,
    'snow': Colors.grey[100],
    'sleet': Colors.blueGrey[200],
    'wind': Colors.green,
    'fog': Colors.grey[300],
    'cloudy': Colors.grey[700],
    'partly-cloudy-day': Colors.grey,
    'partly-cloudy-night': Colors.blueGrey[700],
  };
  final textColor = Colors.white;

  Color conditionFontColor(String condition) {
    var lightConditions = ['snow', 'sleet', 'fog'];
    if (lightConditions.contains(condition)) {
      return Colors.black;
    }
    return Colors.white;
  }

  HourlyItem({Key key, @required this.hourlyForecastData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: conditionColors[hourlyForecastData.icon],
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: SvgPicture.asset("assets/${hourlyForecastData.icon}.svg",
                  color: conditionFontColor(hourlyForecastData.icon),
                  width: 54,
                  height: 54),
            ),
            Expanded(
              flex: 6,
              child: Container(
                padding: EdgeInsets.fromLTRB(16.0, 0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${DateFormat.j().format(hourlyForecastData.date)} (${DateFormat.E().format(hourlyForecastData.date)})",
                      style: TextStyle(
                          color: conditionFontColor(hourlyForecastData.icon),
                          fontSize: 24),
                    ),
                    Text(hourlyForecastData.summary,
                        style: TextStyle(
                            color: conditionFontColor(hourlyForecastData.icon),
                            fontSize: 16)),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('${hourlyForecastData.temp.round().toString()}°',
                      style: TextStyle(
                          color: conditionFontColor(hourlyForecastData.icon),
                          fontSize: 24)),
                  Text('${hourlyForecastData.tempFeel.round().toString()}°',
                      style: TextStyle(
                          color: conditionFontColor(hourlyForecastData.icon)
                              .withOpacity(0.5),
                          fontSize: 24)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
