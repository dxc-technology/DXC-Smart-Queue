
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class RewardPoint {
  num id;

  num points;

  String receivedTimeInMillis;

  RewardPoint.name(
    this.id,
    this.points,
    this.receivedTimeInMillis,
  );

  RewardPoint.fromJson(Map<String, dynamic> json) {

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }

}
