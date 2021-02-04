import 'package:weather_flutter_app/models/temp.dart';
import 'package:weather_flutter_app/models/weather.dart';
import 'package:json_annotation/json_annotation.dart';
part 'daily.g.dart';

@JsonSerializable(explicitToJson: true)
class Daily {
  int dt;
  int sunrise;
  int sunset;
  Temp temp;
  int pressure;
  int humidity;
  double dewPoint;
  var windSpeed;
  int windDeg;
  List<Weather> weather;
  int clouds;
  var pop;
  var uvi;

  Daily(
      {this.dt,
      this.sunrise,
      this.sunset,
      this.temp,
      this.pressure,
      this.humidity,
      this.dewPoint,
      this.windSpeed,
      this.windDeg,
      this.weather,
      this.clouds,
      this.pop,
      this.uvi});

  factory Daily.fromJson(Map<String, dynamic> json) => _$DailyFromJson(json);

  Map<String, dynamic> toJson() => _$DailyToJson(this);
}
