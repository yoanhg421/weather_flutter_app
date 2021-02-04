import 'package:json_annotation/json_annotation.dart';
part 'alerts.g.dart';

@JsonSerializable(explicitToJson: true)
class Alerts {
  String senderName;
  String event;
  int start;
  int end;
  String description;

  Alerts({this.senderName, this.event, this.start, this.end, this.description});

  factory Alerts.fromJson(Map<String, dynamic> json) => _$AlertsFromJson(json);

  Map<String, dynamic> toJson() => _$AlertsToJson(this);
}
