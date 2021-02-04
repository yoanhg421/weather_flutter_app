import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:weather_flutter_app/helpers/constants.dart';
import 'package:weather_flutter_app/models/alerts.dart';
import 'package:weather_flutter_app/models/weather_model.dart';

import 'package:geolocator/geolocator.dart';

String buildURL({double lat, double lon, String units = 'imperial'}) {
  String url =
      '$kAPIURL?lat=$lat&lon=$lon&exclude=minutely,hourly&appid=$kAPIKey&units=$units';
  return url;
}

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permantly denied, we cannot request permissions.');
  }

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      return Future.error(
          'Location permissions are denied (actual value: $permission).');
    }
  }

  return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low);
}

Future<WeatherModel> getWeatherData({String units = 'imperial'}) async {
  var position = await determinePosition();
  double lat = position.latitude;
  double lon = position.longitude;
  String url =
      '$kAPIURL?lat=$lat&lon=$lon&exclude=minutely&appid=$kAPIKey&units=$units';
  Map json = await http.get(url).then((res) => jsonDecode(res.body));

  return WeatherModel.fromJson(json);
}

Image getWeatherIcon(String icon) {
  return Image.network('http://openweathermap.org/img/wn/$icon@2x.png');
}

String convertTimestampToTime(int timestamp) {
  return DateFormat.jm()
      .format(DateTime.fromMillisecondsSinceEpoch((timestamp * 1000)));
}

String convertTimestampToDay(int timestamp) {
  return DateFormat.EEEE()
      .format(DateTime.fromMillisecondsSinceEpoch((timestamp * 1000)));
}

Future<void> showAlerts(context, List<Alerts> alerts) async {
  await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select alert for details'),
          children: alerts
              .map(
                (alert) => SimpleDialogOption(
                  onPressed: () {
                    showMyDialog(context, alert);
                  },
                  child: Text(
                    alert.event,
                    style: kWeatherXXSmall,
                  ),
                ),
              )
              .toList(),
        );
      });
}

Future<void> showMyDialog(context, Alerts alert) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(alert.event),
        contentTextStyle: kWeatherXXSmall,
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(alert.description),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Color(0xFF7B8199)),
            ),
            child: Text(
              'Close',
              style: kWeatherXSmall,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
