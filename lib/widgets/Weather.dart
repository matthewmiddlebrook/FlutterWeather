import 'package:FlutterWeather/models/WeatherData.dart';
import 'package:FlutterWeather/widgets/PrecipGraph.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

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

  Color conditionFontColor(String condition) {
    var lightConditions = ['snow', 'sleet', 'fog'];
    if (lightConditions.contains(condition)) {
      return Colors.black;
    }
    return Colors.white;
  }

  Weather({Key key, @required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: conditionColors[weather.icon],
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(weather.currentlySummary,
                style: TextStyle(
                    color: conditionFontColor(weather.icon), fontSize: 32.0)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(weather.hourlySummary,
                  style: TextStyle(
                      color: conditionFontColor(weather.icon), fontSize: 18.0)),
            ),
            WeatherInfoTable(
                weather: weather, textColor: conditionFontColor(weather.icon)),
            SvgPicture.asset("assets/${weather.icon}.svg",
                color: conditionFontColor(weather.icon), width: 82, height: 82),
            Text('${weather.temp.toString()}°',
                style: TextStyle(
                    color: conditionFontColor(weather.icon),
                    fontSize: 42,
                    fontWeight: FontWeight.bold)),
            new PrecipGraph.withSampleData(
                weather: weather, textColor: conditionFontColor(weather.icon)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(weather.minutelySummary,
                  style: TextStyle(
                      color: conditionFontColor(weather.icon), fontSize: 24.0)),
            ),
            Text("Today is " + DateFormat.yMMMd().format(weather.date),
                style: TextStyle(color: conditionFontColor(weather.icon))),
            Text("Updated " + DateFormat.jm().format(weather.date),
                style: TextStyle(color: conditionFontColor(weather.icon))),
          ],
        ),
      ),
    );
  }
}

class WeatherInfoTable extends StatelessWidget {
  final WeatherData weather;
  final Color textColor;

  const WeatherInfoTable({
    Key key,
    this.weather,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Column(
          children: <Widget>[
            SvgPicture.asset("assets/all_icons/Umbrella.svg",
                color: textColor, width: 48, height: 48),
            Text((weather.precipProbability * 100).toStringAsFixed(0) + "%",
                style: TextStyle(color: textColor, fontSize: 14)),
            Text((weather.precipIntensity).toStringAsFixed(3) + " in",
                style:
                TextStyle(color: textColor.withOpacity(.5), fontSize: 14)),
          ],
        ),
        Column(
          children: <Widget>[
            Transform.rotate(
              angle: radians(weather.windAngle),
              child: SvgPicture.asset("assets/all_icons/Compass-South.svg",
                  color: textColor, width: 48, height: 48),
            ),
            Text(weather.windSpeed.toStringAsFixed(0) + " mph",
                style: TextStyle(color: textColor, fontSize: 14)),
            Text(weather.windBearing,
                style:
                TextStyle(color: textColor.withOpacity(.5), fontSize: 14)),
          ],
        ),
        Column(
          children: <Widget>[
            SvgPicture.asset("assets/all_icons/Shades.svg",
                color: textColor, width: 48, height: 48),
            Text("UV " + weather.uvIndex.toStringAsFixed(0),
                style: TextStyle(color: textColor, fontSize: 14)),
            Text("",
                style:
                TextStyle(color: textColor.withOpacity(.5), fontSize: 14)),
          ],
        ),
        Column(
          children: <Widget>[
            SvgPicture.asset("assets/all_icons/Sunset.svg",
                color: textColor, width: 48, height: 48),
            Text(DateFormat.jm().format(weather.sunset),
                style: TextStyle(color: textColor, fontSize: 14)),
            Text("Sunset",
                style:
                TextStyle(color: textColor.withOpacity(.5), fontSize: 14)),
          ],
        ),
        Column(
          children: <Widget>[
            SvgPicture.asset(
                "assets/all_icons/Moon-${weather.moonPhasePic}.svg",
                color: textColor,
                width: 48,
                height: 48),
            Text(weather.moonPhase,
                style: TextStyle(color: textColor, fontSize: 14)),
            Text("Moon",
                style:
                TextStyle(color: textColor.withOpacity(.5), fontSize: 14)),
          ],
        ),
      ],
    );
  }
}
