import 'package:weather_flutter_app/models/alerts.dart';
import 'package:weather_flutter_app/models/current.dart';
import 'package:weather_flutter_app/models/daily.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:weather_flutter_app/models/hourly.dart';
part 'weather_model.g.dart';

@JsonSerializable(explicitToJson: true)
class WeatherModel {
  double lat;
  double lon;
  String timezone;
  int timezoneOffset;
  Current current;
  List<Daily> daily;
  List<Hourly> hourly;
  List<Alerts> alerts;

  WeatherModel({
    this.lat,
    this.lon,
    this.timezone,
    this.timezoneOffset,
    this.current,
    this.daily,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) =>
      _$WeatherModelFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherModelToJson(this);
}
