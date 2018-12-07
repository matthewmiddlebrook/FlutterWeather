import 'package:FlutterWeather/models/AlertData.dart';
import 'package:flutter/material.dart';

class AlertItem extends StatefulWidget {
  final Alert weatherAlert;

  const AlertItem({Key key, this.weatherAlert}) : super(key: key);

  @override
  AlertItemState createState() => new AlertItemState(weatherAlert);
}

class AlertItemState extends State<AlertItem> with TickerProviderStateMixin {
  final Alert weatherAlert;
  final textColor = Colors.white;

  bool _showDesc = false;

  AlertItemState(this.weatherAlert);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new GestureDetector(
            onTap: () => setState(() {
                  _showDesc = !_showDesc;
                }),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(weatherAlert.name,
                      style: TextStyle(color: textColor, fontSize: 24)),
                  Text(weatherAlert.severity.toUpperCase(),
                      style: TextStyle(
                          color: textColor.withOpacity(0.75), fontSize: 18)),
                ],
              ),
            ),
          ),
          new AnimatedSize(
            duration: const Duration(milliseconds: 120),
            child: _showDesc
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(weatherAlert.description,
                        style: TextStyle(color: textColor)),
                  )
                : Container(),
            vsync: this,
          )
        ],
      ),
    );
  }
}
