class Alert {
  final String name;
  final String severity;
  final String description;
  final DateTime expire;

  Alert({this.name, this.severity, this.description, this.expire});
}

class AlertData {
  final List list;

  AlertData({this.list});

  factory AlertData.fromJson(Map<String, dynamic> json) {
    List list = new List();
    for (dynamic e in json['alerts']) {
      Alert w = new Alert(
        name: e['title'],
        severity: e['severity'],
        description: e['description'],
        expire: DateTime.fromMillisecondsSinceEpoch(e['expires'] * 1000,
            isUtc: false),
      );
      list.add(w);
    }

    return AlertData(
      list: list,
    );
  }
}
