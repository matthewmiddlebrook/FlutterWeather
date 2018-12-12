class HourlyForecastData {
  final DateTime date;
  final double temp;
  final double tempFeel;
  final String summary;
  final String icon;

  HourlyForecastData(
      {this.date, this.temp, this.tempFeel, this.summary, this.icon});
}

class HourlyData {
  final List list;
  final String icon;
  final String summary;

  HourlyData({this.list, this.icon, this.summary});

  factory HourlyData.fromJson(Map<String, dynamic> json) {
    List list = new List();

    for (dynamic e in json['hourly']['data']) {
      HourlyForecastData w = new HourlyForecastData(
          date: new DateTime.fromMillisecondsSinceEpoch(e['time'] * 1000,
              isUtc: false),
          temp: e['temperature'].toDouble(),
          tempFeel: e['apparentTemperature'].toDouble(),
          summary: e['summary'],
          icon: e['icon']);
      list.add(w);
    }

    return HourlyData(
      list: list,
      icon: json['hourly']['icon'],
      summary: json['hourly']['summary'],
    );
  }
}
