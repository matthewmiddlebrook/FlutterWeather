import 'dart:convert';

import 'package:FlutterWeather/APIKeys.dart' as KEYS;
import 'package:FlutterWeather/models/AlertData.dart';
import 'package:FlutterWeather/models/ForecastData.dart';
import 'package:FlutterWeather/models/HourlyData.dart';
import 'package:FlutterWeather/models/WeatherData.dart';
import 'package:FlutterWeather/widgets/AlertItem.dart';
import 'package:FlutterWeather/widgets/HourlyWidget.dart';
import 'package:FlutterWeather/widgets/Weather.dart';
import 'package:FlutterWeather/widgets/WeatherItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart' as LocationManager;

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: KEYS.googleMapsAPI);

LatLng _location;

void main() {
  runApp(MaterialApp(
    title: "Matthew Weather App",
    home: MyApp(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blueGrey,
    ),
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  GoogleMapController mapController;
  List<PlacesSearchResult> places = [];

  bool isLoading = false;
  WeatherData weatherData;
  ForecastData forecastData;
  AlertData alertData;
  HourlyData hourlyData;

//  LocationManager.Location _location = new LocationManager.Location();
  String error;

  void onError(PlacesAutocompleteResponse response) {
    homeScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  Future<LatLng> getUserLocation() async {
    var currentLocation = <String, double>{};
    final location = LocationManager.Location();
    try {
      currentLocation = await location.getLocation();
      final lat = currentLocation["latitude"];
      final lng = currentLocation["longitude"];
      final center = LatLng(lat, lng);
      return center;
    } on Exception {
      currentLocation = null;
      return null;
    }
  }

  void setLocation(Location location) {
    _refreshIndicatorKey.currentState.show();
    LatLng latLng = new LatLng(location.lat, location.lng);
    _location = latLng;
    loadWeather();
  }

  void setLocationToCurrent() async {
    if (_refreshIndicatorKey.currentState != null)
      _refreshIndicatorKey.currentState.show();
    _location = await getUserLocation();
    loadWeather();
  }

  Future<void> _handlePressButton() async {
    try {
      Prediction p = await PlacesAutocomplete.show(
        context: context,
        apiKey: KEYS.googleMapsAPI,
        onError: onError,
        mode: Mode.overlay,
        language: "en",
        hint: "Search for a location",
      );
      PlacesDetailsResponse place =
      await _places.getDetailsByPlaceId(p.placeId);
      setLocation(place.result.geometry.location);
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldKey,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(weatherData != null
            ? weatherData.name.locality + ", " + weatherData.name.adminArea
            : "Weather"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            tooltip: 'Search',
            onPressed: setLocationToCurrent,
            color: Colors.white,
          ),
          IconButton(
            icon: Icon(Icons.search),
            tooltip: 'Search',
            onPressed: _handlePressButton,
            color: Colors.white,
          ),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: loadWeather,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            weatherData == null
                ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  "This is a weather app.\nLocation services are required\nfor this app to function.",
                  textAlign: TextAlign.center,
                  style:
                  TextStyle(color: Colors.white, fontSize: 24)),
            )
                : Container(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                alertData != null && alertData.list.isNotEmpty
                    ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: List.generate(
                        alertData.list.length,
                            (index) {
                          return AlertItem(
                              weatherAlert:
                              alertData.list.elementAt(index));
                        },
                      ),
                    ))
                    : Container(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: weatherData != null
                      ? Weather(weather: weatherData)
                      : Container(),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new HourlyWidget(
                      weather: hourlyData,
                    )),
                Padding(
                    padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
                    child: weatherData != null
                        ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Next 7 Days",
                          style: TextStyle(
                              color: Colors.white, fontSize: 24),
                        ),
                        Text(
                          weatherData.dailySummary,
                          style: TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ],
                    )
                        : Container()),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: forecastData != null
                    ? Column(
                  children: List.generate(
                    forecastData.list.length,
                        (index) {
                      return WeatherItem(
                          weather: forecastData.list.elementAt(index));
                    },
                  ),
                )
                    : Container(),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    loadWeather();
  }

  Future<Null> loadWeather() async {
    setState(() {
      isLoading = true;
    });

    if (_location == null) {
      setLocationToCurrent();
    }

    if (_location != null) {
      final LAT = _location.latitude;
      final LON = _location.longitude;

      final API_KEY = KEYS.darkSkyAPI;

      final weatherResponse =
      await http.get('https://api.darksky.net/forecast/$API_KEY/$LAT,$LON');

      var data = jsonDecode(weatherResponse.body);

      final coordinates = new Coordinates(LAT, LON);
      var addresses =
      await Geocoder.local.findAddressesFromCoordinates(coordinates);
      data['name'] = addresses.first;

      if (weatherResponse.statusCode == 200) {
        return setState(() {
          weatherData = new WeatherData.fromJson(data);
          forecastData = new ForecastData.fromJson(data);
          alertData = new AlertData.fromJson(data);
          hourlyData = new HourlyData.fromJson(data);
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
