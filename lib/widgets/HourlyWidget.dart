import 'package:FlutterWeather/HourlyScreen.dart';
import 'package:FlutterWeather/models/HourlyData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HourlyWidget extends StatelessWidget {
  final HourlyData weather;

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

  HourlyWidget({Key key, @required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return weather != null
        ? Card(
            color: conditionColors[weather.icon],
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HourlyScreen(hourlyData: weather),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: SvgPicture.asset("assets/${weather.icon}.svg",
                          color: conditionFontColor(weather.icon),
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
                              "Next 48 Hours",
                              style: TextStyle(
                                  color: conditionFontColor(weather.icon),
                                  fontSize: 24),
                            ),
                            Text(weather.summary,
                                style: TextStyle(
                                    color: conditionFontColor(weather.icon),
                                    fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Container();
  }
}
