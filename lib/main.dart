import 'dart:convert';

import 'package:FlutterWeather/models/ForecastData.dart';
import 'package:FlutterWeather/models/WeatherData.dart';
import 'package:FlutterWeather/widgets/Weather.dart';
import 'package:FlutterWeather/widgets/WeatherItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  bool isLoading = false;
  WeatherData weatherData;
  ForecastData forecastData;
  Location _location = new Location();
  String error;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
//          backgroundColor: Colors.blueGrey,
          appBar: AppBar(
            title: Text('Flutter Weather App'),
            actions: <Widget>[
              IconButton(
                icon: new Icon(Icons.refresh),
                tooltip: 'Refresh',
                onPressed: loadWeather,
                color: Colors.white,
//                            iconSize: 32,
              )
            ],
          ),
          body: Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: weatherData != null
                        ? Weather(weather: weatherData)
                        : Container(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: isLoading
                        ? CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor:
                                new AlwaysStoppedAnimation(Colors.white),
                          )
                        : null,
                  ),
                ],
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 300.0,
                  child: forecastData != null
                      ? ListView.builder(
                          itemCount: forecastData.list.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) => WeatherItem(
                              weather: forecastData.list.elementAt(index)))
                      : Container(),
                ),
              ),
            )
          ]))),
    );
  }

  @override
  void initState() {
    super.initState();

    loadWeather();
  }

  loadWeather() async {
    setState(() {
      isLoading = true;
    });

    Map<String, double> location;

    try {
      location = await _location.getLocation();

      error = null;
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error =
            'Permission denied - please ask the user to enable it from the app settings';
      }

      location = null;
    }

    if (location != null) {
      final LAT = location['latitude'];
      final LON = location['longitude'];

      final API_KEY = "9cd9c35b8c859448b9db4d2ab38c7f56";

      final weatherResponse =
          await http.get('https://api.darksky.net/forecast/$API_KEY/$LAT,$LON');

      var something = jsonDecode(weatherResponse.body);

      final coordinates = new Coordinates(LAT, LON);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      something['name'] = addresses.first;

      if (weatherResponse.statusCode == 200) {
        return setState(() {
          weatherData = new WeatherData.fromJson(something);
          forecastData = new ForecastData.fromJson(something);
          isLoading = false;
        });
      }

      setState(() {
        isLoading = false;
      });
    } else {
      print("NULL");
    }
  }
}
